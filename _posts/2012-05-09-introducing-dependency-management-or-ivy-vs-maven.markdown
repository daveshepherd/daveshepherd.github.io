---
layout: post
title:  "Introducing Dependency Management (or Ivy vs Maven)"
summary: >
  Following on from my previous article, I having been working on a project where the dependencies between modules is becoming unmanageable. The solution to this problem is to use a dependency management system like Apache Ivy or Apache Maven.
image: ivy-maven-logo.png
date:   2012-05-09 20:33:00
tags: ant java maven development dependency-management
---
Following on from my [previous article][software-building-hell], I having been working on a project where the dependencies between modules is becoming unmanageable. The solution to this problem is to use a dependency management system like [Apache Ivy][ivy] or [Apache Maven][maven].

The basic idea behind dependency management tools is that the project defines the artifacts that it depends on by referencing their coordinates (group Id, artifact Id and version). Using the coordinates the build mechanism can ensure that the correct version of the dependency is made available to the project build. The use of a dependency management tool simplifies the build process and will always ensure that the correct artifacts are made available to a project. This is particularly useful when your projects are made up of multiple modules that are dependent on each other.

I have been reading up on the two main dependency management tools to get an idea of how they work and to see which is the best tool for our project. It is worth noting at this point that Ivy and Maven are not directly comparable; Ivy is purely a dependency management tool can be used by [Ant][ant], whereas Maven is better described as a build automation tool. A better comparison is *Apache Ant + Ivy* vs *Apache Maven*.

This [topic][m2-comparison] has been [covered][stackoverflow] many times [before][lex-hazlewood], with [varying conclusions][lex-hazlewood-revisited]. This article focuses on my experiences with learning both tools and my initial impressions.

## Lets Get Started...

The first big difference between Ant builds and Maven builds is that Maven focuses on describing the project rather how to build it and uses conventions to decide how to build, this is based on the idea that most projects are built in the same way. Whereas Ant involves explicitly defining what needs to be done and how to do it, providing extreme flexibility.

To illustrate this I have developed a simple Java archive (JAR) without any dependencies that will be compiled and packaged into the output artifact (JAR file). I have created both an Ant build script and and a Maven project definition to do build this project.

Ant build script - build.xml ([get project source][simple-jar-ant]):

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8" ?>
<project name="simple-jar-ant" default="package">
 <target name="compile">
  <mkdir dir="target/classes" />
  <javac srcdir="src" destdir="target/classes" />
 </target>
 <target name="package" depends="compile">
  <mkdir dir="target" />
  <jar destfile="target/simple-jar-ant.jar" basedir="target/classes" />
 </target>
 <target name="clean">
  <delete dir="target" />
 </target>
</project>
{% endhighlight %}

Running `ant package` for this project will compile the main java code, package the project's artifact (JAR file) and place it into the `target` directory.

Maven project definition - pom.xml ([get project source][simple-jar-mvn]):

{% highlight xml %}
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
 <modelVersion>4.0.0</modelVersion>
 <groupId>uk.co.daveshepherd.examples</groupId>
 <artifactId>simple-jar-mvn</artifactId>
 <version>0.0.1-SNAPSHOT</version>
</project>
{% endhighlight %}

Running `mvn package` for this project will compile the main java code, package the project's artifact (JAR file) and place it into the `target` directory.

Maven is made up of a series of plug-ins which are downloaded from a repository the first time they are needed, you will see this the first time you run a Maven build. The artifacts that Maven downloads will be cached so that they are not downloaded again.

In this simple example there is little difference in the complexity between Ant and Maven, so lets move on and add some unit tests to our project.

## Adding Some Unit Tests

Most Java projects will hopefully have at least some unit tests and in order to ensure the project remains stable the tests should executed as part of the build. This example introduces two items to the build; the JUnit test source files which are placed in the test directory and the JUnit library that is required to compile and execute the tests. The external dependency will be defined by the project and the build will ensure that the correct version is made available to the compilation and execution of the tests.

Ant build script - build.xml ([get project source][simple-jar-test-ivy]):

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8" ?>
<project name="simple-jar-test-ant" default="package" xmlns:ivy="antlib:org.apache.ivy.ant">
 <target name="resolve">
  <ivy:settings file="ivysettings.xml" />
  <ivy:retrieve />
 </target>
 <target name="compile" depends="resolve">
  <mkdir dir="target/classes" />
  <javac srcdir="src" destdir="target/classes" />
 </target>
 <target name="compile-test" depends="resolve, compile">
 <mkdir dir="target/test-classes" />
 <javac srcdir="test" destdir="target/test-classes">
   <classpath location="target/classes" />
   <classpath path="lib/junit-4.10.jar" />
  </javac>
 </target>
 <target name="test" depends="compile-test" description="Run automated tests for project">
  <mkdir dir="target/test-results" />
  <junit printsummary="yes" haltonfailure="yes">
   <classpath location="target/classes" />
   <classpath location="target/test-classes" />
   <classpath path="lib/junit-4.10.jar" />
   <formatter type="plain" />
   <batchtest fork="yes" todir="target/test-results">
    <fileset dir="test">
     <include name="**/*Test*.java" />
    </fileset>
   </batchtest>
  </junit>
 </target>
 <target name="package" depends="test">
  <mkdir dir="target" />
  <jar destfile="target/simple-jar-test-ant.jar" basedir="target/classes" />
 </target>
 <target name="clean">
  <delete dir="lib" />
  <delete dir="target" />
  </target>
</project>
{% endhighlight %}

The dependency definition file (ivy.xml):

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<ivy-module version="2.0" xmlns:m="http://ant.apache.org/ivy/maven">
 <info organisation="uk.me.daveshepherd.examples" module="simple-jar-test-ivy" />
 <dependencies>
  <dependency org="junit" name="junit" rev="4.10" />
 </dependencies>
</ivy-module>
{% endhighlight %}

This build script introduces the `resolve`, `compile-test` and `test` targets to the original example, it also introduces the dependency definition file called `ivy.xml`.

The `resolve` target is responsible for ensuring that the defined project dependencies are made available to the rest of the build script, this is done by placing the dependencies in the `lib` directory. The dependencies are then included on the classpath explicitly when they are required by the build script.

As you would expect, the `compile-test` target compiles the tests and the `test` target executes them.

Running `ant package` for this project will compile and execute all tests, prior to packaging.

The first time this is executed you will see Ivy retrieving JUnit from the repository along with its dependencies. This is only done the first time it is needed, after that it is cached locally making the build quicker.

As you can see from the output, one test was run and there were no failures or errors:

{% highlight bash %}
[junit] Running uk.me.daveshepherd.examples.simplejar.TestSimpleClass
[junit] Tests run: 1, Failures: 0, Errors: 0, Time elapsed: 0.015 sec
{% endhighlight %}

Maven project definition - pom.xml ([get project source][simple-jar-test-mvn]):

{% highlight xml %}
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
 <modelVersion>4.0.0</modelVersion>
 <groupId>uk.co.daveshepherd.examples</groupId>
 <artifactId>simple-jar-test-mvn</artifactId>
 <version>0.0.1-SNAPSHOT</version>
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

The only change required to the Maven project definition is the addition of a dependency on the JUnit library. Maven will automatically check to see if there are any tests in the tests directory and then compile and execute them.

Running `mvn package` for this project will compile and execute all tests, prior to packaging.

The first time this is executed you will see Maven retrieving JUnit from the repository, along with its dependencies. This is only done the first time it is needed, after that it is cached locally making the build quicker.

You will also see the output from the unit tests:

{% highlight bash %}
-------------------------------------------------------
T E S T S
-------------------------------------------------------
Running uk.me.daveshepherd.examples.simplejar.TestSimpleClass
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.062 sec
Results :
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
{% endhighlight %}

My preference at this stage is Maven, the reason for this is that Maven has identified that most projects are build the same way, most projects have the same requirements for testing, etc. and it uses that idea to make the build as simple as possible. You can see that adding tests has caused the Ant build script to grow significantly and if you look at its content you can see that much of it is just like any other Java project, so why repeat yourself?.

I have two outstanding concerns with Maven at this point:

1. How does Maven cope with larger projects and projects made up of multiple modules
2. Can I use Maven to all the other bits and pieces that our current Ant builds do? For example, integration tests, test coverage analysis, deployment to an application server, etc.

I am going to attempt to address these concerns as my investigation continues.

## Source Code for Examples

You can download and run the complete projects used in this article from [bitbucket][bitbucket]

[software-building-hell]:   {{ site.baseurl }}/2012-04-software-building-hell
[ivy]:                      http://ant.apache.org/ivy/
[maven]:                    http://maven.apache.org/
[ant]:                      http://ant.apache.org/
[m2-comparison]:            http://ant.apache.org/ivy/m2comparison.html
[stackoverflow]:            http://stackoverflow.com/questions/318804/maven-or-ivy-for-managing-dependencies-from-ant
[lex-hazlewood]:            http://leshazlewood.com/2008/03/18/maven-2-vs-antivy-our-selection-process/
[lex-hazlewood-revisited]:  http://leshazlewood.com/2010/01/13/maven-2-vs-antivy-revisited/
[simple-jar-ant]:           https://bitbucket.org/daveshepherd/examples/src/80282593a97a/simple-jar-ant/
[simple-jar-mvn]:           https://bitbucket.org/daveshepherd/examples/src/80282593a97a/simple-jar-mvn/
[simple-jar-test-ivy]:      https://bitbucket.org/daveshepherd/examples/src/80282593a97a/simple-jar-test-ivy/
[simple-jar-test-mvn]:      https://bitbucket.org/daveshepherd/examples/src/80282593a97a/simple-jar-test-mvn/
[bitbucket]:                https://bitbucket.org/daveshepherd/examples/src