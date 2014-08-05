---
layout: post
title:  "Software Building Hell"
summary: >
  I have always used Apache Ant for building Java projects. It has served me well, allowing me to do pretty much everything I've needed to do so far. However, as the projects I work on start get larger and more complicated, so do the scripts that build them.
image: apache-ant-logo.png
date:   2012-04-02 16:48:00
tags: development technology java ant build
---

I have always used [Apache Ant][ant] for building Java projects. It has served me well, allowing me to do pretty much everything I've needed to do so far. However, as the projects I work on start get larger and more complicated, so do the scripts that build them.

Once you get in to projects made up of multiple modules then you need to start ensuring that the builds reflect the dependencies between the various modules. Add this to the need to run unit tests, integration test, javadoc generation, static code analysis and you find that your Ant scripts have become very large, complicated, difficult to maintain and extremely easy to break.

A recently project I worked on had a single Ant script for building five web applications made up of about 20 or so modules, each web application having a slightly different combination of required modules, with many of them sharing. The build actually worked quite well and built the applications fairly quickly. However, it was difficult understand exactly what the builds were doing, you didn't really have the option to build individual modules which meant that you built everything every time and they were quite fragile.

The latest project that I'm working is already made up of a large number of modules and is going to continue to grow over the next few years to be very big. I wanted to ensure that it didn't suffer from the build headaches that I'd seen before, so I insisted that we separated the builds so that each module had it's own script. This meant:

* The build scripts are kept small
* The build script are kept with the code that they are responsible for
* A module could be build and tested individually

We still have a master build script, but it is simpler than in the past, with it only having the following responsibilities:

* Build the EAR file by calling the individual module builds and using the generated artefacts
* Deploy the EAR to the server
* Run integration tests and collating the results from the application server

Although this solution is a huge improvement over previous projects I am already seeing potential problems with it, primarily around the dependencies between modules.

![Simplified example of module dependencies][project-dependencies]

At the time, I thought my solution for managing these dependencies was quite neat. What I had done was create an Ant script called "classpath.xml" in each of the modules were referenced from other modules, in the example above this would be the two interface projects. This Ant script was a simple classpath definition that had a global reference to the generated artefacts and any shared libraries that it was responsible for. The other modules that depended on these modules would import "classpath.xml" and reference the class path in the compile target.

However, this solution still has the following problems:

* To build a module all of it's dependencies have to be built first, otherwise the classpath would point to a non-existent artefact
* To work on or build a single module you have to check out the whole workspace
* The master build script also needs to know about the dependencies in order to ensure modules are built in the right order, this means that dependencies have to be managed in multiple locations
* Despite the master build doing very little, it has still ended up being very large

In addition to these problems, the long term plan for this project is that many of the modules will optional or may have country or customer specific implementations. I am currently expecting that this would be managed by having a different master build script for each combination or modules. This means that the dependencies will have to be managed in each of these master build scripts, making it very likely that if the dependencies change or new modules are added then the dependencies will not be updated in all the right places.

I have found that Ant is very good at building modules and is very flexible. However, in order to manage build dependencies you need something more. The two options that seem to be popular are [Apache Ivy][ivy] (in conjunction with Ant) and [Apache Maven][maven], which is a complete build manager, so in theory could replace your Ant scripts entirely.

[ant]:   				http://ant.apache.org/
[project-dependencies]:	{{ site.url }}/assets/project-dependencies.png
[ivy]:					http://ant.apache.org/ivy/
[maven]:				http://maven.apache.org/
