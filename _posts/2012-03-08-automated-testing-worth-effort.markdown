---
layout: post
title:  "Is Automated Testing Worth The Effort"
summary: >
  I recently came across a question asking whether the work involved in maintaining a suite of automated tests was worth the effort involved, this is my response.
date:   2012-03-08 18:43:00
tags: development testing agile tdd
---
I recently came across a question asking whether the work involved in maintaining a suite of automated tests was worth the effort involved, this is my response.

When you first start looking at automated testing it can seem like a lot of work to write and maintain the tests, with very little benefits, particularly if you are trying to add them to an existing product, because of this I have known people actually comment out failing tests rather than fix them because they didn't have time and that was the easier option. However, if automated testing is understood and implemented effectively then it can be a very powerful tool, especially if it is considered throughout the development process rather than something to bolt on at the end. Automated testing is not about providing stats to the management or customers, it's about helping the development team produce high quality software, this is because:

* It encourages developers to think about the architecture of the application to keep the design as simple of possible and to enforce the [separation of concerns][separation-of-concerns]
* It encourages developers to think about the requirements for each of the components in an application before designing the implementation
* It helps prevent [regression][software-regression]
* It provides a safety net for refactoring

The difficultly with writing automated tests is knowing what to test and how to test it. If you get this wrong then you can find that your tests are very time consuming to write and to maintain. There many different types of tests, these are the three areas that I think should be considered for automation:

* [Unit Testing][unit-testing] – This involves isolating a piece of code/logic and making sure it works as you expect. By isolating it you are making sure you are only testing this logic and if a test fails then you know it's a problem with this piece of code and not something else that it is dependant on. This means that you can be confident that wherever this logic is used within your application then it will do what you expect
* [Integration Testing][integration-testing] – These tests make sure that when two or more parts of your application are plugged together they work as they should. These tests don't need to test every scenario in your logic, because your unit tests will take care of this
* User Interface Testing – This is about testing that the logic of your UI is correct. This can be done using unit tests, particularly if your UI implements something like the MVC pattern where you would test your controller and model components. Alternatively, or in addition to this, you can tools that interact with the user interface directly, using tools like [Selenium][selenium]

[James Shore discusses types of automated testing in a bit more detail][james-shore]

*"Can your test suite pass, but your app not function properly (false positive)?"* – Yes, automated tests will only cover the specific scenarios they were written for and will be based on the understanding of the developer who wrote the test which means that developer hadn't foreseen a particular scenario then it won't be tested. The other reason is that a conscious decision was made not to test a particular scenario because the effort out weighed the risk. This is why it is still important to do manual testing.

*"Can your test suite fail, but your app function completely normally (false negative)?"* – Yes, if a test fails that is testing a bit of code that is rarely used in a production application or there is no way to get to that area of the system through the interface.

*"Do your customers care how many lines of code have test coverage?"* – Probably not. However, analysis like test coverage should be primarily a tool for the development team. The difficult part of writing automated tests is knowing how much of you software to test. I think that in many companies it is unrealistic to create 100% test coverage of you code, so you need to work out what the important areas of your application to ensure you have tests. For example, do you really need automated tests on all your simple model objects? This is where code coverage tools like [Cobertura][cobertura] come in. Using something like this allows the developers to see which area of the code is being tested and to what extent. This can give you an idea of areas of the application that might be higher risk than others. It is important to remember that this is just a guide; you need to decide whether the risk outweighs the cost of developing tests for them.

Customers are interested in whether your application is of a high quality, testing is one way of doing this, but it is important to ensure that quality is continually managed, this is commonly done by following [good continuous integration practices][martin-fowler], automated testing is just a small part of this.

*"It does feel good to see every single test in your suite pass, but how helpful is it really?"* - Seeing all your tests pass is not really helpful, but if everything is normally passing, then if a test fails it is easily and quickly identified so that it can be fixed. If you leave failing tests for any length of time then developers don't notice when other tests start to fail, if you're not careful you will end up in a position when you have quite a few tests failing and it's now a big job to go back and fix them.

If you are finding that a lot of your tests are fragile then it probably suggests that there a problem with the way you are testing your application. It could be that your unit tests are not truly isolated or you integration tests are not just focusing on integration.

*"Are Cucumber and RSpec intended to be replacements for human QA?"* – No, tools do not replace manual testing. Like any tool, it helps someone do their job, not do it for them. What these tools do instead is change the focus of a tester from making sure the application does what we designed to do and repeating the same tests over and over after each release, to making sure that the product adds business value and is delivered with the quality that customers require and finding those unexpected issues by using methods like [exploratory testing][exploratory-testing]
.

I have just started reading [Agile Testing: A Practical Guide for Testers and Agile Teams][agile-testing]
 and although I haven't finished it yet it does explore much of what I have touched on above. Even if you are not working in an agile way then you can still apply a lot of the testing principles discussed in the book.

Finally, it is important to realise that there is no "one size fits all" solution to automated testing and it will largely come down to your application and your needs. You should look at the various ideas that I've discussed above and work out what you can do to add the most benefit to your organisation. You don't have jump head first into, automated testing, start small and continually refine your processes, framework and tests to get to where you want to be.

[separation-of-concerns]:   http://en.wikipedia.org/wiki/Separation_of_concerns
[software-regression]:      http://en.wikipedia.org/wiki/Software_regression
[unit-testing]:             http://en.wikipedia.org/wiki/Unit_testing
[integration-testing]:      http://en.wikipedia.org/wiki/Integration_testing
[selenium]:                 http://docs.seleniumhq.org/
[james-shore]:              http://www.jamesshore.com/Blog/Alternatives-to-Acceptance-Testing.html
[cobertura]:                http://cobertura.github.io/cobertura/
[martin-fowler]:            http://martinfowler.com/articles/continuousIntegration.html#PracticesOfContinuousIntegration
[exploratory-testing]:      http://en.wikipedia.org/wiki/Exploratory_testing
[agile-testing]:            http://www.amazon.co.uk/Agile-Testing-Practical-Addison-Wesley-Signature/dp/0321534468