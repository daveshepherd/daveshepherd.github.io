---
layout: post
title:  "Continuous Delivery - What is the point?"
summary: >
  There are many reasons to adopt continuous delivery, one of them is so that you can release multiple times a day, but it’s not the main reason. In fact, you may implement continuous delivery and not release that frequently, either by choice or due to other restrictions.
date:   2015-07-03 17:30:00
tags: software continuous-delivery agile
---
There are many reasons to adopt continuous delivery, one of them is so that you can release multiple times a day, but it’s not the main reason. In fact, you may implement continuous delivery and not release that frequently, either by choice or due to other restrictions. These are some of the key reasons for adopting it:

# Agility

CD is a natural extension to Agile development, Agile is all about small feedback loops and reacting to change in demand. So decreasing the time between releases, even if it’s only to you internal users, decreases that feedback loop. Ideally changes would be made available to your end users as soon as possible so that you can get feedback just as quickly, because they are really the only people that will show you whether they want that new feature.

# Repeatability

Deploying into all environments in the same way and doing that regularly means that the release process becomes a quick, rock solid automated process out of necessity. Compare this to a manual process that only occurs once a month or once a year, quite often there’s that tweak to the deployment process that got it working last time, but after the release the documentation never got updated so that same issue occurs again. Over time a release become a non-event, so say goodbye to out of hours deployments and late night debugging in production.

# Reliability
Once you get to releasing to all environments in the same way then you know that the release to production is going to work, because it’s been proven in at least a couple of pre-production environments, including a production-like staging environment.

# Reduced risk

Releasing more frequently means that changes are small incremental changes, they would normally be backward compatible or versioned so would have little impact on the system. When you companies boast about releasing many times a day, the majority of the changes are not big new features, they’re tweaks to APIs or minor changes to UI. The larger changes evolve over time, but because each change on it’s own has little impact there is less risk that the change will break anything.
