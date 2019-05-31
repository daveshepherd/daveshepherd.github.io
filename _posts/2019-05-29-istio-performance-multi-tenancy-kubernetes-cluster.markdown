---
layout: post
title:  "Istio performance in a multi-tenancy Kubernetes cluster"
summary: >
  At Wealth Wizards we run a soft multi-tenancy set up in Kubernetes by defining a namespace to each of our customers
  and restricting access between tenant namespaces, the number of services and configurations we had caused our Istio
  installtion to consume a large number of resources due to the amount of unnecessary configuration being pushed around.
image: "multi-tenancy.png"
date:   2019-05-29 17:00:00
tags: istio multi-tenancy kubernetes service-mesh
---
At Wealth Wizards we run a soft multi-tenancy set up in [Kubernetes](https://kubernetes.io/) by defining a namespace to
each of our customers (or tenants) and restricting access between tenant namespaces using
[network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) and
[weave](https://github.com/weaveworks/weave). This set up was defined to ensure isolation between different tenants'
services.

There is also a "common" namespace for tenant agnostic services which can be used by services in any tenant namespace.

When the [Istio service mesh](https://istio.io/) was introduced into our Kubernetes cluster it used the default setup of
a single control plane. After running it for a short while it became evident that all of the Envoy proxy sidecars were
getting the configuration for all namespaces irrelevant on whether that service was allowed to communicate with services
in those other namespaces or not.

This did not cause us any security issues because the network policy prevented access, but it did appear to add
unnecessary load to the control plane; as well as a reasonably high base load there was also spikes of anything up to
800% CPU.

We looked into options to restrict the configurations being sent based on namespaces, but the only option at the time
was to have [one control plane per namespace](https://istio.io/blog/2018/soft-multitenancy/#watching-specific-namespaces-for-service-discovery).

This wasn’t acceptable for two reasons:

1. The resources required to run a control plane per namespace was unacceptable for the number of namespaces that we wanted
to run
2. The communication to the common namespace would be forced to leave the cluster and re-enter via the ingress
At the time, we decided to park this problem and just boosted the control plane resources.

Along came [Istio 1.1](https://istio.io/about/notes/1.1/) and with it came the introduction of the
[sidecar resource](https://istio.io/docs/reference/config/networking/v1alpha3/sidecar/); this can be defined in a
namespace and \allows you to configure the sidecar in that namespace, including specifying the egress hosts which can
restrict which namespaces sidecars in the current namespace will receive configuration for.

```
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
metadata:
  namespace: my-tenant
spec:
  egress:
  - hosts:
    - my-tenant/*
    - common-services/*
    - istio-system/*
```

We now use this to limit the Istio sidecars to the information regarding it’s own namespace, the common namespace and
the istio system namespace

Since then the load from Istio control plane has been a lot more consistent, and a noticeable reduction in the size of
any CPU spikes and therefore the resources required to run Istio, this is a great improvement for Istio and a prime example of the Istio community responding to the needs of it’s user base.