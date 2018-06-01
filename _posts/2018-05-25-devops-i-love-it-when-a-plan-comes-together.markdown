---
layout: post
title:  "DevOps: I love it when a plan comes together"
summary: >
  When I first started in my current role as a platform/operations bod I seemed to spend a good majority of my time
  sorting out configuration, deploying new software and looking after our growing microservice ecosystem.
image: "devops-i-love-it-when-a-plan-comes-together.jpg"
date:   2018-04-25 17:00:00
tags: devops agile
---
When I first started in my current role as a platform/operations bod I seemed to spend a good majority of my time
sorting out configuration, deploying new software and looking after our growing microservice ecosystem.

I'd spend a day trying to get a new microservice deployed, or a week trying to get a new environment set up while our
developers were sitting around waiting for me.

This is on top of the 'big picture' pieces of work that we wanted to do in order to provide better support and grow the
platform to support the growing number of customers we have been taking on. This stuff was just not getting the time needed.

This problem wasn't because the developers didn't want to do the work, but rather it was because they couldn't. We
promote a DevOps culture, but we were preventing the developers from owning their own work all the way into production.

Now, a year later, I rarely get involved in deployments, I keep an eye on our monitoring and I am on hand to support our
teams, but actually I'm getting a lot of the 'big picture' work done and the developers are delivering safely at speed.

So what changed?

We implemented a number of things that drastically changed the game.

* Developers have the ability to see and modify all configuration across all environments, whilst still having appropriate
controls in place
* Developers use a chatbot to trigger deployments and apply configuration changes and can monitor the progress
* Secrets are stored or managed using Vault, engineering can access the systems they need to access in order to do their
job
* Logs are aggregated and available across all microservices and available to everyone who needs them

Although each change was relatively small, when they all come together they form an ever growing ecosystem that supports
DevOps, safe delivery at speed and a greater sense of freedom to get the features that our customers want out there
rather than dealing with mundane work and problems.