---
layout: post
title:  "Unblocking our release train with Istio traffic management"
summary: >
  Wealth Wizards employs a microservice architecture. This means lots of services, each being actively developed. To
  ensure that our changes work a variety of tools are used, including unit-tests, contract tests and linting tools which
  can be used against work in progress.
  However, there is still a number of steps that need to happen using the whole suite of services, or at least a
  reasonable portion of them. This includes end to end testing, review or demonstrations with stakeholders to get
  feedback.
image: "istio.jpg"
date:   2019-01-11 16:00:00
tags: istio devops release deployment kubernetes
---
Wealth Wizards employs a microservice architecture. This means lots of services, each being actively developed. To
ensure that our changes work a variety of tools are used, including unit-tests, contract tests and linting tools which
can be used against work in progress.

However, there is still a number of steps that need to happen using the whole suite of services, or at least a
reasonable portion of them. This includes end to end testing, review or demonstrations with stakeholders to get
feedback.

There’s a number of ways these steps could be achieved, but the easiest and most common method is to merge the change
into the mainline and push it out to the test environment.

The problem with this is that as soon as a change is in the mainline, it’s on the release train and any subsequent
changes to the same service end up in a queue. If that change results in a delay, e.g. some feedback caused some rework,
then all subsequent changes get stuck and then have to be released together as a bundle. Making bigger and bigger
changes that all have to be applied in one go… this starts to become risky and difficult to manage.

---

There are many way to try and avoid these problems, but one of the best ways is to stop changes from getting on the
release train until there is almost no risk of that change holding it up.

What if it was possible to build a branch from version control and deploy it alongside the mainline version? If it could
interact with the mainline versions of it’s dependencies and be available to anyone who wants to use it for testing or
demonstrations without affecting the use of the mainline version?

This can be done using [Istio](https://istio.io/). Istio does many things, but the
[traffic management](https://istio.io/docs/concepts/traffic-management/) functionality is the key to this solution. It
allows traffic to be routed to different versions of the same service based on a http
header.

The Wealth Wizards implementation will route all traffic to the mainline or master version of a service by default.
However, if the hostname includes a version prefix then it will route traffic to the corresponding version of the
service, if it exists.

---

Our microservices run on [Kubernetes](https://kubernetes.io/); this gives us a lot of flexibility on how they are
deployed.

Istio is deployed to our Kubernetes cluster, which includes an
[ingress gateway](https://istio.io/docs/tasks/traffic-management/ingress/) and we have enabled
[sidecar injection](https://istio.io/docs/setup/kubernetes/sidecar-injection/) for the namespaces hosting our test
services. This means that external traffic is routed via the Istio gateway and internal traffic is routed via the Istio
proxy sidecars.

By defining destination rules and virtual services we can control how traffic is routed by Istio.

A destination rule defines subsets of pods for a given services that are available and uses labels on pods to identify
these subsets, we use a ‘version’ label which is set to ‘master’ for our mainline deployments and the ticket number when
we have deployed a variant from a branch.

In this case ‘some-microservice’ has a master subset and a subset for ticket ‘ABC-1234’.

```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: some-microservice
spec:
  host: some-microservice.some-namespace.svc.cluster.local
  subsets:
  - name: ABC-1234
    labels:
      version: ABC-1234
  - name: master
    labels:
      version: master
```

A virtual service definition defines the rules on how to route traffic. This is used by the Istio gateway and the Istio
proxy sidecars to decide which pods to route traffic to. It will typically route based on the requested host and HTTP
paths, headers and other rules.

In this ingress gateway example, requests to `some-address.wealthwizards.com/some-microservice` will be routed to the
master subset by default or the ‘ABC-1234’ subset if the `x-variant-id` header is set to ‘ABC-1234’ or the host (aka
authority) is `abc-1234.some-address.wealthwizards.com/some-microservice`.

```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: some-microservice-ingress
spec:
  gateways:
    - default-gateway
  hosts:
    - some-address.wealthwizards.com
    - "*.some-address.wealthwizards.com"
  http:
    -
      appendHeaders:
        x-variant-id: ABC-1234
      match:
        -
          authority:
            regex: (ABC-1234|abc-1234).some-address.wealthwizards.com
          uri:
            regex: ^/some-microservice(/.*)?$
      route:
        -
          destination:
            host: some-microservice.default.svc.cluster.local
            subset: ABC-1234
    -
      match:
        -
          uri:
            regex: ^/some-microservice(/.*)?$
          headers:
            x-variant-id:
              regex: (ABC-1234|abc-1234)
      route:
        -
          destination:
            host: some-microservice.default.svc.cluster.local
            subset: ABC-1234
    -
      match:
        -
          uri:
            regex: ^/some-microservice(/.*)?$
      route:
        -
          destination:
            host: some-microservice.default.svc.cluster.local
            subset: master
```

---

We wanted to apply this to all of our feature branches across all microservices, to enable this we have introduced
automation around this, so that the delivery teams don’t have to do too much to make use of this.

First, when a branch is pushed it is already built and tested, so we’ve added an extra step to deploy that to
Kubernetes, this was pretty trivial as we already do a very similar step when we build the mainline. We use the ticket
number from the branch name to identify a variant.

To keep the destination rules and virtual service configurations up to date, we created a little tool called
[AutoKube](https://github.com/WealthWizardsEngineering/AutoKube). This listens for deployments on Kubernetes and
generates the Istio configuration and applies it based on the variants deployed.

Once a branch is finished with, it needs to be cleaned up, for this we introduced
[kube-housekeeper](https://github.com/WealthWizardsEngineering/kube-housekeeper), a simple job that will delete old
branch deployments.

Finally, we wanted to be able to test services downstream from those we’re interacting with directly. For this the
x-variant-id header needs to be propagated through our services. This has to be done by the services themselves, but
rather than manually passing it through we created [hpropagate](https://github.com/WealthWizardsEngineering/hpropagate),
a node.js module that handles it all for us. So when a variant of a service is requested, any downstream requests will
also ask for the variant. You can read more about hpropagate in
[this article](https://medium.com/ww-engineering/headers-propagation-with-hpropagate-27de8347f76a).
 
---

With all this, our delivery teams can develop features in a branch, and test them before they are committed to the
release train, even if they cross microservice boundaries. This has become an invaluable tool to help keep change
flowing through our system.