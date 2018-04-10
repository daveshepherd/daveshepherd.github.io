---
layout: post
title:  "Working with Vault secrets that expire on Kubernetes"
summary: >
  One of the most powerful features of Vault is the dynamic secrets provided by a number of secrets engines. Most of these secrets engines integrate with authenticated services to generate access credentials when they are needed, like a database username and password. The credentials are then revoked after a period of time. In my previous article I discussed how to authenticate a Kubernetes application against Vault so that the application could retrieve secrets and manage it’s own leases. However, what happens if the application you want to run doesn’t know anything about working with Vault?
image: "vault-init-renew.png"
date:   2018-04-10 15:30:00
tags: devops vault kubernetes secrets docker
---
One of the most powerful features of [Vault](https://www.vaultproject.io/) is the dynamic secrets provided by a number of [secrets engines](https://www.vaultproject.io/intro/getting-started/secrets-engines.html). Most of these secrets engines integrate with authenticated services to generate access credentials when they are needed, like a database username and password. The credentials are then revoked after a period of time. In my [previous article](2018-04-working-with-vault-secrets-on-kubernetes) I discussed how to authenticate a Kubernetes application against Vault so that the application could retrieve secrets and manage it’s own leases. However, what happens if the application you want to run doesn’t know anything about working with Vault?

A number of the services we run on Kubernetes are out of the box solutions, like [git2consul](https://github.com/breser/git2consul). In these cases it is prefered to use existing public Docker images from [Docker Hub](https://hub.docker.com/), so that we don’t have to maintain them. However, when these images require secrets to be injected in order to run it makes it difficult to get them from Vault and avoid the application breaking due to the [leases expiring](https://www.vaultproject.io/docs/concepts/lease.html).

# Initialising the application with secrets from Vault

To solve the first problem of injecting secrets into our application an [init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) is used as part of the Kubernetes deployment. This is a container that runs once when a pod is first deployed before the main container(s) are started. The init container will be responsible for authenticating against Vault using the Kubernetes Auth Method, it then queries the secrets required for the container and passes them onto the main application container.

![The sequence of initialising secrets on Kubernetes][vault-init-container-sequence]

The process is similar to that described in my [previous article](2018-04-working-with-vault-secrets-on-kubernetes), except that the init container does most of this work and hands over to the main application container when it’s finished.

Unfortunately, it is not possible to inject the secrets into the application container as environment variables from the init container using normal Kubernetes configuration, so the following process is used:

1. Inject secret references into the init container; specifically the environment variable names that the application requires and the corresponding Vault key for retrieving the secret
2. Retrieve the secrets from Vault
3. Write the secrets to a file that is on a volume that is shared between the init container and the application container
4. When the application container is started the secrets file is [sourced](https://en.wikipedia.org/wiki/Source_%28command%29) which sets the environment variables ready for the application to use them; this is done by modifying the Docker run command
5. The secrets that the init container needs to get are defined as environment variables or the init container; the init container will look for all environment variables starting with `SECRET_` and use the value as the location to read from Vault. The secret is the stored in a variable using the original name without the `SECRET_` prefix.

For example:

`SECRET_TOP_SECRET=consul/creds/my_app`

Would read `consul/creds/my_app` from Vault and store it in the variable `TOP_SECRET` for the application container to use.

For more details on how this works and to see the source for the init container then have a look at the [GitHub repository](https://github.com/WealthWizardsEngineering/kube-vault-auth-init). You can find the Docker image on [Docker Hub](https://hub.docker.com/r/wealthwizardsengineering/kube-vault-auth-init/).

# Renewing the secrets from Vault

We now have an application that knows nothing about Vault running on Kubernetes using secrets from Vault. However, if we did nothing, the leases for the the secrets would expire at which point the application would be unable to use them any more, so we need something that will keep renewing the secrets for the lifetime of the application.

This is done by running a [sidecar container](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar), the sidecar container runs inside the same pod as the main application container and keeps an eye on the TTLs for the Vault authentication token and any secrets, when they are nearing expiration it will send a request to Vault to renew them. When the pod is terminated the sidecar stops renewing the token and secrets and they are allowed to expire.

![The sequence for using a sidecar to renew leases in Vault][vault-renewer-container-sequence]

To keep it simple, the init container process from the previous section has been abbreviated.

The renewer container runs while the application container is running and is periodically checking the TTLs on the authentication token and secrets and, when necessary, sending a renewal request to Vault. In order to do this, the renewer container requires the Vault authentication token and a list of lease ids for the secrets that need to be renewed.

As before, the only way we can pass information between the init container and the renewer container is by writing to a file, so we use the same file as the application container and use the following environment variables available from the init container:

* `VAULT_TOKEN`
* `LEASE_IDS` — a comma separated list

The TTL and renewal periods should be tweaked to meet your own needs, the TTLs should to be long enough that the renewer is not constantly renewing tokens, but short enough that the secrets don’t hang around too long after the application is stopped.

For more details on how this works and to see the source for the renewer container then have a look at the [GitHub repository](https://github.com/WealthWizardsEngineering/kube-vault-auth-renewer). You can find the Docker image on [Docker Hub](https://hub.docker.com/r/wealthwizardsengineering/kube-vault-auth-renewer/).

With both the init container and the renewer sidecar it is possible to run applications that do not interact with Vault, whilst getting the benefits of Vault secrets management.

[vault-init-container-sequence]: {{ site.baseurl }}/assets/vault-init-container-sequence.png
[vault-renewer-container-sequence]: {{ site.baseurl }}/assets/vault-renewer-container-sequence.png