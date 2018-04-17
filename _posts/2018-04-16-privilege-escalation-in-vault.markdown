---
layout: post
title:  "Privilege escalation in Vault  "
summary: >
  After using Vault for a period of time we recognised a risk around the KV secrets engine which means that users could accidentally overwrite or delete secrets stored there using the Vault CLI, accidents happen after all. Unlike other secrets engine, like the AWS secrets engines where the secrets are created when requested and if revoked can be requested again, the key value secrets are lost if they are updated or deleted.
image: "sudo-vault.png"
date:   2018-04-16 17:00:00
tags: devops vault secrets
---
After using [Vault](https://www.vaultproject.io/) for a period of time we recognised a risk around the [KV secrets engine](https://www.vaultproject.io/docs/secrets/kv/index.html) which means that users could accidentally overwrite or delete secrets stored there using the Vault CLI, accidents happen after all. Unlike other secrets engines, like the [AWS secrets engine](https://www.vaultproject.io/docs/secrets/aws/index.html) where the secrets are created when requested and if revoked can be requested again, the key value secrets are lost if they are updated or deleted.

If this happens, the backup can be used to restore only the secrets that have been lost. However, this is not a trivial process and could take a little bit of time. In fact, shortly after identifying this risk, this backup process was put into practice for real after one of our engineers made a mistake when trying to add some new secrets.

Restricting access to do this is not desirable and doesn’t eliminate the risk, so an alternative was required. The [versioning of k/v secrets is coming very soon](https://github.com/hashicorp/vault/issues/1364), but is not yet available, this should allow old values to be retrieved in the event of data loss. So, in the meantime our Vault users are given a gentle reminder if they are performing a destructive action to ensure that they intended to do it.

# The solution

This is done with a [little script](https://gist.github.com/daveshepherd/973f017e4f21e1de0dd1cae02d9b3350), an [AppRole](https://www.vaultproject.io/docs/auth/approle.html) and [some policies](https://www.vaultproject.io/docs/concepts/policies.html), which looks like this for the user.

Check that the secret doesn’t exist:

```
$ vault read secret/my-key
No value found at secret/my-key
```

Write the new secret:

```
$ vault write secret/my-key value=original
Success! Data written to: secret/my-key
```

Read the new secret:

```
$ vault read secret/my-key
Key                 Value
---                 -----
refresh_interval    768h
value               original
```

Fail to update the secret:

```
$ vault write secret/my-key value=new
Error writing data to secret/my-key: Error making API request.
URL: PUT https://vault.example.com/v1/secret/my-key
Code: 403. Errors:
* permission denied
```

Use the sudo-vault script to update the secret:

```
$ sudo-vault write secret/my-key value=new
You are working with increased privileges - do you know what you're doing (y/n)? y
Success! Data written to: secret/my-key
```

The new value has been stored:

```
$ vault read secret/my-key
Key                 Value
---                 -----
refresh_interval    768h
value               new
```

By adding the following script on your path as “sudo-vault”, you can easily elevate your privileges:

{% gist 973f017e4f21e1de0dd1cae02d9b3350 %}

This script is just a wrapper for the Vault CLI your current Vault token to request a new token from the power-user AppRole and then use that token to make the Vault request using the parameters passed to the script.

# Configuration

To set this up you need the following configuration in Vault.

A power user sudo policy, this policy defines the escalated privileges to apply when using sudo-vault, in this case full permissions.

```
$ echo -n ‘path “*” {
  capabilities = [“create”, “read”, “update”, “delete”, “list”, “sudo”]
}’ | vault policy write power-user-sudo -
```

An AppRole that is used to generate a short lived token to make a single Vault request from the sudo-vault script which has the power-user-sudo permissions:

```
$ vault write auth/approle/role/power-user \
  secret_id_ttl=5m \
  secret_id_num_uses=1 \
  period=30m \
  bind_secret_id=”true” \
  policies=”power-user-sudo”
```

A base user policy (power-user) which is the policy a user would normally have associated with their token, this has the no-privileged access defined (create, read and list) and access to the AppRole defined above:

```
echo -n ‘path “*” {
  capabilities = [“create”, “read”, “list”]
}
# AppRole permissions — explicit in case the above changes
path “auth/approle/role/power-user/role-id” {
  capabilities = [“read”]
}
path “auth/approle/role/power-user/secret-id” {
  capabilities = [“update”]
}’ | vault policy write power-user -
```

This doesn’t prevent a trusted user from destroying data, but it does help prompt them if they try, which should prompt them to think about whether they are doing the right thing.