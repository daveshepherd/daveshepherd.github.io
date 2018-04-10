---
layout: post
title:  "Working with Vault secrets on Kubernetes"
summary: >
  Hashicorp’s Vault is more than just a secrets store, it can be used to dynamically create secrets with the relevant permissions at the time that they are required. This has great security benefits, because it not only means that no-one actually needs to know passwords and other secrets as they only exist when they are required, but also it encourages applications and systems to expect secrets to become invalid at some point (expire).  This makes the idea of regular passwords/secrets rotation the norm rather than something to be scared of. I’m sure you’ve come across the scenario: “I don’t know what’s using this password and I don’t want to break anything so I’ll leave it as it is”.
image: "vault-and-kubernetes.png"
date:   2018-04-04 17:30:00
tags: devops vault kubernetes secrets docker
---
[Hashicorp’s Vault](https://www.vaultproject.io/) is more than just a secrets store, it can be used to dynamically create secrets with the relevant permissions at the time that they are required. This has great security benefits, because it not only means that no-one actually needs to know passwords and other secrets as they only exist when they are required, but also it encourages applications and systems to expect secrets to become invalid at some point (expire). This makes the idea of regular passwords/secrets rotation the norm rather than something to be scared of. I’m sure you’ve come across the scenario: “I don’t know what’s using this password and I don’t want to break anything so I’ll leave it as it is”.

At Wealth Wizards we have been using [Kubernetes](https://kubernetes.io/) for a little while now and wanted to start using Vault for the applications that run on Kubernetes cluster. This is a two part blog post and in this first article I will discuss how to use the [Kubernetes](https://www.vaultproject.io/docs/auth/kubernetes.html) and [AppRole](https://www.vaultproject.io/docs/auth/approle.html) authentication methods to allow an Kubernetes application to request secrets from Vault. In the second part I’ll discuss dynamic secrets that expire and how to use them in applications that are not aware of Vault.

# Basic authentication and secrets retrieval

The [Vault getting started guide](https://www.vaultproject.io/guides/getting-started/index.html) introduces the concepts of authentication and secrets retrieval, if you have not gone through the guide then I strongly suggest you do. In order to retrieve any secrets from Vault a user must be authenticated. This is an example of the sequence of events for a user to retrieve a secret from Vault:

![The sequence for the retrieval of a secret from Vault][vault-basic-usage-sequence]

1. A user will login to Vault using one of the [Auth Methods](https://www.vaultproject.io/docs/auth/index.html); if successful, the user will be given a [token](https://www.vaultproject.io/docs/concepts/tokens.html).
2. The token can then be used to request a secret from a secrets engine.

Simple!

However, it’s a little more complicated under the covers. Firstly, there are several auth methods, one of the simplest is [userpass](https://www.vaultproject.io/docs/auth/userpass.html) which allows simple username and password logins that are stored in Vault. Others methods allow Vault to use another authority, for example LDAP. Once authenticated, a token is provided which will be required for all requests to Vault, although this is handled for you when using the CLI.

A secret is requested against a [secrets engine](https://www.vaultproject.io/docs/secrets/index.html), there a number of secrets engines, the easiest to get started with is [key/value secrets engine](https://www.vaultproject.io/docs/secrets/kv/index.html), which is just a key/value store. This engine is unlike other engines in that the secrets retrieved do not expire.

# Application authentication with Kubernetes

The userpass authentication method requires the user to provide the credentials to authenticate. However, when deploying an application it is not desirable to be asked for any credentials when deploying an application as they need to be known and risk being compromised. Instead we use Kubernetes as a trusted authority, by configuring the [Kubernetes authentication backend](https://www.vaultproject.io/docs/auth/kubernetes.html).

Now, the user from the example above has been replaced by our application and Kubernetes and some additional auth methods have been introduced. We have chosen to use Kubernetes for the initial authentication, but hand off to AppRole as soon as possible, to encourage separation of concerns when it comes to authentication and policy definitions.

![The sequence for retrieving a secret from Vault on Kubernetes][vault-kubernetes-authentication-sequence]

1. Kubernetes has a service account defined for this application, which is specified against the Kubernetes deployment for the application.
2. When Kubernetes starts a pod for this deployment a JWT token linked to the service account is created and injected onto the file system of the containers in that pod.
3. The application can use the JWT token to login to Vault with the Kubernetes auth method. The resulting token has been defined so that it only has access to the AppRole that we have defined for this application.
4. The AppRole role id and and secret id is requested
5. These are then used to login to Vault using the AppRole auth method. This creates a token that has the relevant permissions to retrieve only the secrets that this application requires.
6. The application can then use the AppRole token to request it’s secrets and make use of them.
6. So now an application has been deployed to Kubernetes that authenticates against Vault allowing it to retrieve it’s own passwords, API keys and other secrets and nothing outside of the application needs to know any of them.

This is great!

However….

# Leases

As I mentioned at the start of this article, secrets only exist when they are required. In order to enforce this in Vault [leases](https://www.vaultproject.io/docs/concepts/lease.html) are used.

A lease is associated with every authentication token and secret that Vault provides, the lease has an expiration or time to live (TTL), after which Vault will revoke the token or secret. When a lease is revoked then the token or secret associated with it will no longer work. This ensures that tokens or secrets are not accidentally left lying around.

If this happens to the token that was issued when a user logged into Vault using their username and password or when they have requested credentials to query a database then they can just log in or request them again. However, if this happens for an application, this could render it useless. Even if there was a mechanism in the application to login again, there might be a period of time where the application cannot access the database while this re-authentications is happening, it is unlikely that this would be desirable.

This is where lease renewal comes into play. The application would regularly renew it’s authentication token and any secrets it requires before they expire:

![The sequence for renewing leases in Vault][vault-lease-renewal-sequence]

This means that while the application is running the token and secrets continue to work. However, when the application is stopped they are allowed to expire and can no longer be used.

In the examples in this article the application has to know about and interact with Vault. This is great when working with applications that can have this functionality added. However, quite often the applications that need to be run don’t know anything about Vault and customising them might not be possible or practical.

This is particularly important when working with Kubernetes, as Docker images are used to run applications. It is normally desirable to run official Docker images for applications as these are maintained, tested and patched against vulnerabilities. If they were modified in-house to include something that handles the interaction with Vault then that adds an overhead to maintaining and updating these applications.

The [next article](/2018-04-working-with-vault-secrets-that-expire-on-kubernetes) in this series will talk about how init and sidecar containers in Kubernetes can be used to handle all this instead.

[vault-basic-usage-sequence]: {{ site.baseurl }}/assets/vault-basic-usage-sequence.png
[vault-kubernetes-authentication-sequence]: {{ site.baseurl }}/assets/vault-kubernetes-authentication-sequence.png
[vault-lease-renewal-sequence]: {{ site.baseurl }}/assets/vault-lease-renewal-sequence.png