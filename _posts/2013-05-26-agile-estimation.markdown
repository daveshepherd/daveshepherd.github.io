---
layout: post
title:  "Agile Estimation"
summary: >
  Estimating is difficult and if done badly it will only lead to disappointment. This is because usually when someone estimates how long a project is going to take they are optimistic, and that means that at some point there will be a realisation that a team is not going to deliver the project when they said they would.
  Agile estimation is about using information about what that the team has delivered in the past in order get an idea of what that team can deliver in the future. In order to do this we need a way of measuring what has been delivered.
date:   2013-05-26 11:44:00
tags: agile development
---
Estimating is difficult and if done badly it will only lead to disappointment. This is because usually when someone estimates how long a project is going to take they are optimistic, and that means that at some point there will be a realisation that a team is not going to deliver the project when they said they would.

Agile estimation is about using information about what that the team has delivered in the past in order get an idea of what that team can deliver in the future. In order to do this we need a way of measuring what has been delivered.

Rather than trying decide how long a particular story will take to complete, agile estimation compares stories to each other to come up with relative sizing of stories. It is much easier for people to say whether a story will involve more, less or about the same effort as another story.

Using this idea we can use the idea of “buckets” that contain a load of stories that are of a similar size. Each bucket is given a number to represent the size of the stories that will go into that bucket, for example 1, 2, 3, 5, 8, 13. Now, when we want to place a story to a bucket, we look for the bucket that contains the stories that are the most similar in size to the one we’re placing. If a story is too large or not defined enough to estimate then we place it in the largest bucket, 13. Stories are assigned story points based on the value of the bucket that they are in.

When you first start estimating you won’t have any previous stories to compare against, there are various ways to manage this all of which involve comparing the stories to each other. One way is to pick a smallish story, but not the smallest and put it in bucket 2, then pick the next story and decide whether it is bigger, smaller, or about the same size and put in the appropriate bucket.

Given that all stories that we work on have a value of points we can work out how many story points the team delivers in each sprint. The average of these values over the last few sprints is the team’s velocity. We can use the team’s velocity when looking at the product backlog to get a good idea of which stories are likely to be completed in the next sprint by adding up their story points until we get to our velocity.

For example, if we have a velocity of 15 and this is our backlog:

Feature A (3)  
Feature B (2) = 5  
Feature C (5) = 10  
Feature D (3) = 13  
Feature E (1) = 14  
Feature F (5) = 19  
Feature G (1) = 20  
Feature H (3) = 23  
…

We can see that in our next sprint we can deliver features A through E which total 14 points.