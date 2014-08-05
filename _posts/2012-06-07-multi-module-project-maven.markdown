---
layout: post
title:  "Multi-Module Project with Maven"
summary: >
  In my last article I looked at how we can manage external dependencies in the Java build process with examples using both Apache Ivy and Apache Maven. This article is going to take it one step further and look at how we can manage several java modules that depend on each other and share dependencies and configuration using Apache Maven.
date:   2012-06-07 16:52:00
tags: java maven development dependency-management
---
The example used in this article is based around a JEE project that produces an EAR file made up of two other modules. This example has two main modules:

* simple-jar-child - A java library
* simple-war-child - A web application

Which are built into an EAR file, defined as a third module called standard-ear.

To group configuration together and to provide a central place to build from we create a parent project called multi-module-mvn.

![Diagram of Multi-Module example][multi-module-maven]

The example project refered to in this article is available on [bitbucket][bitbucket-examples].

## The Parent pom

The parent pom is used to group the child modules together and the centralise common configuration.

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
 <modelVersion>4.0.0</modelVersion>
 <groupId>uk.co.daveshepherd.examples</groupId>
 <artifactId>multi-module-mvn</artifactId>
 <name>Multi-Module Maven Example</name>
 <version>0.0.1-SNAPSHOT</version>
 <packaging>pom</packaging>
 <modules>
  <module>simple-jar-child</module>
  <module>simple-war-child</module>
  <module>standard-ear</module>
 </modules>
 <dependencies>
  <dependency>
   <groupId>junit</groupId>
   <artifactId>junit</artifactId>
   <version>4.10</version>
   <scope>test</scope>
  </dependency>
 </dependencies>
</project>
{% endhighlight %}

The key elements in the parent pom are:

* packaging - defined as "pom"
* modules - contains a list of all the child modules

### The simple-jar-child and simple-war-child Child Modules

The pom for these projects are very similar to a standalone module:

{% highlight xml %}
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
 <modelVersion>4.0.0</modelVersion>
 <artifactId>simple-jar-child</artifactId>
 <name>Simple JAR Child Module</name>
 <parent>
  <artifactId>multi-module-mvn</artifactId>
  <groupId>uk.co.daveshepherd.examples</groupId>
  <version>0.0.1-SNAPSHOT</version>
 </parent>
</project>
{% endhighlight %}

However, the groupId and version of this module is not defined, instead these values are inherited from its parent which is defined using the parent element. There are also no dependencies defined in this pom despite simple-jar-child requiring JUnit in order to run the tests, this is because these projects inherit this dependency from the parent.

## The standard-ear Child Module

The standard-ear module is used to pull the other two child projects into an EAR file that can be deployed to a JEE container. This project is slightly different from the other children, firstly it contains no source files as the EAR file contents are pulled from the other modules, secondly the pom is a little bit more complex:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
 <modelVersion>4.0.0</modelVersion>
 <artifactId>standard-ear</artifactId>
 <name>Standard Ear File</name>
 <packaging>ear</packaging>
 <parent>
  <artifactId>multi-module-mvn</artifactId>
  <groupId>uk.co.daveshepherd.examples</groupId>
  <version>0.0.1-SNAPSHOT</version>
 </parent>
 <dependencies>
  <dependency>
   <groupId>uk.co.daveshepherd.examples</groupId>
   <artifactId>simple-jar-child</artifactId>
   <version>0.0.1-SNAPSHOT</version>
  </dependency>
  <dependency>
   <groupId>uk.co.daveshepherd.examples</groupId>
   <artifactId>simple-war-child</artifactId>
   <version>0.0.1-SNAPSHOT</version>
   <type>war</type>
  </dependency>
 </dependencies>
 <build>
  <plugins>
   <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-ear-plugin</artifactId>
    <version>2.3.2</version>
    <configuration>
     <modules>
      <jarModule>
       <groupId>uk.co.daveshepherd.examples</groupId>
       <artifactId>simple-jar-child</artifactId>
       <bundleDir>lib</bundleDir>
      </jarModule>
      <webModule>
       <groupId>uk.co.daveshepherd.examples</groupId>
       <artifactId>simple-war-child</artifactId>
      </webModule>
     </modules>
    </configuration>
   </plugin>
  </plugins>
 </build>
</project>
{% endhighlight %}

The output of this module is an EAR file, the contents of this file has to be defined in the module's pom. The pom has two references to the other children that we want to include, firstly they are defined as dependencies so that maven knows that this module cannot be build until it has the artifacts from the other modules. Secondly, the list of artifacts to be included in the EAR file are defined in the maven EAR plugin configuration.

## Building the multi-module Project

Now if we navigate to the multi-module-mvn directory and execute mvn install; maven automatically works out the right order based on the defined dependencies, building each module in turn. The EAR file is created in "standard-ear/targets".

{% highlight bash %}
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO]
[INFO] Multi-Module Maven Example ........................ SUCCESS [0.391s]
[INFO] Simple JAR Child Module ........................... SUCCESS [1.421s]
[INFO] Simple WAR Child Module ........................... SUCCESS [0.891s]
[INFO] Standard Ear File ................................. SUCCESS [0.672s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.594s
[INFO] Finished at: Fri May 25 16:18:54 BST 2012
[INFO] Final Memory: 6M/15M
[INFO] ------------------------------------------------------------------------
{% endhighlight %}

## Building Individual Modules

As you project grows you won’t want to build all modules every time you make a change, so we can build just the modules that we want, there are two ways of doing this:

Specify the module at the command line:

`mvn --projects standard-ear install`

if you also build the project’s dependencies then add the “also-make” parameter:

`mvn --projects standard-ear --also-make install`

Alternatively, you can navigate to the child module and run maven, this will automatically pick up the parent pom.

[multi-module-maven]: {{ site.url }}/assets/multi-module-mvn.png
[bitbucket-examples]: https://bitbucket.org/daveshepherd/examples/src/de8d67762528/multi-module-mvn/