---
layout: post
title:  "Characteristics of Enterprise Application Security"
summary: >
  Enterprise application security has a number of characteristics that should be considered as part of application design. These have been defined in the security sections of the Java EE Tutorial and have been reproduced and expanded on below to try and explain what it all means.
date:   2011-10-12 19:42:00
tags: development technology security
---
Enterprise application security has a number of characteristics that should be considered as part of application design. These have been defined in the security sections of the [Java EE Tutorial][oracle-security] and have been reproduced and expanded on below to try and explain what it all means.

## Authentication

*The means by which communicating entities (for example, client and server) prove to one another that they are acting on behalf of specific entities that are authorised for access. This ensures that users are who they say they are.*

The most common mechanism for authentication is the entering of a username and password, but there are many other mechanisms, e.g. tokens, certificates, etc.

## Authorisation or Access Control

*The means by which interactions with resources are limited to collections of users or programs for the purpose of enforcing integrity, confidentiality, or availability constraints. This ensures that users have permission to perform operations or access data.*

This is about assigning users/groups permissions allowing them to perform actions within an application and also to prevent them doing anything they should not be allowed to do.

## Data Integrity

*The means used to prove that information has not been modified by a third party (some entity other than the source of the information). For example, a recipient of data sent over an open network must be able to detect and discard messages that were modified after they were sent. This ensures that only authorized users can modify data.*

The two main areas that this refers to is protecting the infrastructure and ensuring that connections are encrypted, for example using HTTPS/SSL.

## Confidentiality or Data Privacy

*The means used to ensure that information is made available only to users who are authorized to access it. This ensures that only authorized users can view sensitive data.*

This item would partially be covered by ensuring that the authorisations are appropriate and set up correctly, but also about how the application is designed so that sensitive information is not unnecessarily made available to users.

## Non-repudiation

*The means used to prove that a user performed some action such that the user cannot reasonably deny having done so. This ensures that transactions can be proven to have happened.*

This would largely be catered for my ensuring that appropriate data or logging is included in the application so that user’s actions can be traced accurately.

## Quality of Service

*The means used to provide better service to selected network traffic over various technologies.*

It is not entirely clear what this means. A likely example of this would be the prevention of the back office system being adversely affected if the services exposed on the Internet are brought down by a Denial of Service (DOS) attack.

## Auditing

*The means used to capture a tamper-resistant record of security-related events for the purpose of being able to evaluate the effectiveness of security policies and mechanisms. To enable this, the system maintains a record of transactions and security information.*

The capturing of potentially concerning activities on the system that could indicate an attack on the system, e.g. continuous failed logon attempts.

[oracle-security]:  http://docs.oracle.com/javaee/5/tutorial/doc/bnbwk.html#bnbwx