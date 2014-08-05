---
layout: post
title:  "The Launch of Java 7"
summary: >
  The 7th July (7/7) saw the launch of Java 7 by Oracle. The launch was hosted in California, with speakers from the São Paulo and London Java User Groups, and was broadcast live through the Oracle web site. To see what Oracle Java 7 had to offer we joined in the webcast for the evening.
image: java.jpg
date:   2011-07-08 19:41:00
tags: java development technology
---
The 7th July (7/7) saw the launch of Java 7 by Oracle. The launch was hosted in California, with speakers from the São Paulo and London Java User Groups, and was broadcast live through the Oracle web site. To see what Oracle Java 7 had to offer we joined in the webcast for the evening.

Java 7 is the latest release of the Java programming language, standard libraries and runtime environment from Oracle. Java is used extensively for developing enterprise level applications and this release continues to build on an already strong product, with an extensive community across the world.

The latest release of Java is being advertised as evolutionary rather than revolutionary; which basically means that the emphasis has been on a number of smaller changes to improve particular aspects rather than any fundamental or large scale changes.

The Java 7 launch web cast introduced the latest released and discussed some of the key changes. These are:

## Project Coin – Small Language Enhancements

These are some relatively minor changes to the Java language to make it quicker and easier for developers to use. This includes things like switch statements that can use strings, try with resources for ensuring the resources are closed properly when an exception is thrown, improved type inference for generic instance creation and improved exception handling (multi-catch).

## Improved Concurrency Framework

A lightweight fork/join framework which makes it easier to split intensive workloads into multiple concurrent processes so workloads can be spread across multiple processor cores. Concurrent processing can provide real benefit on modern servers that commonly have multiple processors each with multiple cores.

## New API for file system access

This new API provides an improved file system interface and support asynchronous I/O compared to the previous file system API.

## Improvements in Support for Dynamically Typed Languages (InvokeDynamic)

It is becoming quite common to provide implementations of other programming languages (particularly scripting languages) that run on the Java Virtual Machine. This has become popular because it removes the need to install individual scripting engines, when working with modern heterogeneous environments and systems. Dynamically typed languages like Ruby and Python already have Java implementations (JRuby and Jython respectively) that are widely used and in fact scripting languages are often chosen to produce small simple solutions quickly and without compilation that would otherwise be quite an undertaking if developing in pure Java. These improvements mean that when running dynamically typed languages in the JVM they run at performance levels near to Java.

The video presentations and slides from the launch are available on the [Oracle Web Site][java-7-launch].

There are other improvements that were not discussed, but you can review the [JDK 7 features page][java-7-features].

[java-7-launch]:	http://www.oracle.com/us/corporate/events/java7/index.html
[java-7-features]:	http://openjdk.java.net/projects/jdk7/features/