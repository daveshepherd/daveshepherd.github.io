---
layout: post
title:  "Test Driven Development"
summary: >
  Test driven development (TDD) is a programming technique that advocates the development of unit tests before writing the production code. This does not mean that developers forge ahead and write a load of failing tests and then spend ages trying to work out how to get the tests to run. In fact it is a very controlled way of working, that ensures that you are never too far away from 100% test pass rate and your code does exactly what you expect it to do. This is achieved through a rapid cycle of writing a test, develop the production code and refactor/tidy up.
image: "tdd-cycle.png"
date:   2012-07-17 15:27:00
tags: agile development testing
---
Test driven development (TDD) is a programming technique that advocates the development of unit tests before writing the production code. This does not mean that developers forge ahead and write a load of failing tests and then spend ages trying to work out how to get the tests to run. In fact it is a very controlled way of working, that ensures that you are never too far away from 100% test pass rate and your code does exactly what you expect it to do. This is achieved through a rapid cycle of writing a test, develop the production code and refactor/tidy up.

##The TDD Development Cycle

1. Think about the requirement you are going to work on - you should start with all tests passing
2. Write the test for requirement - test should now be failing
3. Write the production code for this test - all tests should pass
4. Do any tidying up/refactoring to improve the code - all tests should pass

##Benefits

Unit tests allow developers to ensure that the production code they write does what they expect, and continues to do so as the software evolves. Test driven development adds to the benefits of unit testing by:

* Ensuring that there are unit tests for all production functionality; because by definition production code is not written until there is a failing test for it
Encouraging developers to think about the desired behaviour of the production code before writing it
* Encouraging the development to be broken up into small manageable tasks that can be implemented quickly
* Focusing on the development of one requirement at a time, i.e. 'just enough'; if future requirements involve changes to code previously written then the existing tests will prevent any regression
* Documenting the code; if the test are given appropriate names explaining the purpose of the test, they are kept small by only testing a single requirement and are clearly written then it should be straightforward to work out what the required behaviour is

##Misconceptions

TDD does not:

* Ensure that the production code meets the requirements; this is because the developer is writing the tests as well as the production code, therefore if there is a flaw in the developer's understanding of the requirements then that flaw will be present in both the tests and production code
* Ensure that everything still works when it's plugged together with other components; this would need to be covered by integration tests

##Good Practice

* Keep tests small; a single test should be responsible for ensuring a small, discrete piece of functionality works correctly, if done properly it should be clear from a failed test what the problem is
* Keep changes/iterations small; when a change causes a test to fail then it is easy to identify the cause and, if required, undo the change to get back to a passing test, with large changes it can be difficult to identify which part of the change caused the failure
* Only refactor code with passing tests; this makes it easier to resolve issues introduced by refactoring
* Give your tests explanatory names; this is largely down to personal preference, but it is quite common to include the expected outcome and conditions of the test e.g. PriceShouldBeFiveWhenAfterNoon
* Ensure that the output from a failed test is clear; compare the two failure messages shown below, in the first example the error states that the value '4' was expected, but the value was actually '1', but it gives no indication where that value came from. Just by adding a short message that includes the name of the value being tested to the assertion, as in the second example, we can immediately see that the problem was with 'some object id', without having to dig around in the source and match line numbers:

A bad assertion:

`junit.framework.ComparisonFailure: expected:<[4]> but was:<[1]>`

A good assertion:

`junit.framework.ComparisonFailure: some object id expected:<[4]> but was:<[1]>`

## Further Information

For further information have a read of [James Shore's article on Test Driven Development][james-shore-tdd]

[james-shore-tdd]:   http://www.jamesshore.com/Agile-Book/test_driven_development.html