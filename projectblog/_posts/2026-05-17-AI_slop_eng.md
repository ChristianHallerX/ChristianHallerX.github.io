---
title: AI Code Slop 
image: /assets/img/research/AI_slop/AI_Code_Slop_Cover.jpg
description: >
  Why Traditional Code Review Is Breaking
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}


As an MLE Tech Lead, I have seen firsthand how quickly AI can accelerate software development. It can help engineers move faster, explore ideas more quickly, and produce working implementations with less manual effort. But I have also seen the other side of that speed: when teams are not careful, AI can scale technical debt just as quickly as it scales output.
The uncomfortable reality is that code is no longer the scarce resource; review capacity is.
Code review is becoming a bottleneck because AI has made it much easier to generate large amounts of code, but it has not made humans proportionally faster at reviewing that code.
That leaves many teams stuck between two uncomfortable options. They can slow everything down with deep human code reviews to preserve quality, or they can keep velocity high by relying on AI reviews, shallow human reviews, or rubber-stamped approvals.
Neither option is satisfying.
The real issue is that most engineering organizations still do not have a clear process for scaling code review in the AI era. We can generate more code than ever, but we do not yet have a reliable way to verify that this code is correct, maintainable, and aligned with the intent of the system.
That gap is where **AI code slop** appears.

## Code Review Was Not Designed for the AI Era

Traditional code review was built for a different development model.
When an engineer opens a pull request, the code usually comes with a trail of human intent. The author understands the tradeoffs they made, the alternatives they considered, and the constraints they worked within. Even when that reasoning is not fully written down, it is usually available through conversation.
AI-generated code changes that dynamic.
A pull request may now contain hundreds or thousands of lines generated from a prompt, a ticket, or a short exchange with an AI assistant. The implementation is preserved, but the reasoning behind it often is not.
This creates a new kind of review problem. Code can compile, tests can pass, and a pull request can look reasonable at a glance without actually being correct.
That is what makes AI code slop dangerous: it does not always look sloppy.

## What Is AI Code Slop?

AI code slop is code that looks legitimate but is poorly aligned with the actual needs of the system.
It may be syntactically correct, reasonably formatted, and even covered by tests. But underneath the surface, it may contain incorrect assumptions, unnecessary abstractions, broken conventions, or failure modes that are difficult to spot in review.
The danger is not that AI writes obviously bad code. The danger is that AI writes code that looks good enough to merge.
When teams are under pressure to move quickly, this kind of code can slip through review and accumulate as technical debt. Over time, the codebase becomes harder to reason about, harder to maintain, and harder to safely extend.

<br>
<p align="center"><img src="/assets/img/research/AI_slop/AI_Code_Slop_fig1.jpg" alt="Christian Haller fig1" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@dkoplyk?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Dmytro Koplyk</a> on <a href="https://unsplash.com/photos/the-milky-way-galaxy-arches-over-a-dark-calm-landscape-WBets1CItK4?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}

      

## Six Ways AI Code Goes Wrong Without Looking Wrong

### 1. Plausible but Incorrect Logic

The code reads well, the syntax is correct, and the structure looks reasonable, but the logic is wrong.
These bugs are difficult to catch because they require understanding what the code was supposed to do, not just what it appears to do. That is hard enough with human-written code, and it becomes even harder when the original intent was buried in a prompt or never captured at all.

### 2. Over-Engineering

AI models are trained on enormous amounts of code, including enterprise systems, framework-heavy applications, and production architectures with layers of abstraction. As a result, a model may respond to a simple problem with an unnecessarily complex solution.
A small helper function may become a multi-class abstraction. A straightforward change may turn into a generalized framework. This can look thoughtful in review, but unnecessary abstraction creates long-term maintenance cost.

### 3. Convention Blindness

AI models are good at generating generic code, but they do not automatically understand the specific conventions of your codebase.
Your repository may have established patterns for naming, logging, error handling, module boundaries, testing style, and API design. AI-generated code often ignores these conventions unless they are made explicit.
The result is code that works in isolation but feels foreign inside the system.

### 4. Hallucinated APIs and Deprecated Usage

AI models can confidently call methods that do not exist, reference configuration options from older library versions, use deprecated APIs, or assume access to internal interfaces that are unavailable in the current service context.
Some of these errors are caught immediately by type checks, builds, or tests. Others are more subtle and may only appear in specific paths, environments, or production scenarios.

### 5. Defensive Overreach

AI-generated code often tries to be helpful by adding defensive programming patterns everywhere. That can mean excessive `try/catch` blocks, broad exception handling, redundant logging, fallback behavior that hides real failures, or silent error absorption.
On the surface, this may look safe. In practice, it can make systems harder to debug because failures that should be loud become quiet.

### 6. Cargo-Cult Patterns

AI is very good at reproducing patterns, but it does not always understand why those patterns exist.
It may add retry logic where retries are unsafe, introduce circuit breakers around calls that do not need them, or copy error-handling patterns into contexts where they do not apply.
The pattern is present, but the reasoning behind it is missing.

<br>
<p align="center"><img src="/assets/img/research/AI_slop/AI_Code_Slop_fig2.jpg" alt="Christian Haller fig2" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@auchynnikau?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Slava Auchynnikau</a> on <a href="https://unsplash.com/photos/mount-everest-illuminated-by-golden-sunrise-light-at-sunrise-ksglBz2VHQQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}


## The Common Thread: Slop Passes the Eye Test

The common thread across these failure modes is that AI code slop often looks like real code. It is formatted well, uses familiar patterns, appears complete, and may even include tests.
That is exactly what makes it hard to catch.
Traditional code review relies heavily on human judgment. Reviewers scan for correctness, maintainability, style, edge cases, and alignment with system design. But when the volume of generated code increases dramatically, reviewers have less time to deeply inspect each change.
Large AI-generated pull requests make this worse. A 500-line diff is hard to review carefully, and a 2,000-line AI-assisted implementation is even harder. Under deadline pressure, reviewers may focus on obvious issues and miss the deeper ones.
The result is a review process that still exists formally but no longer functions as a strong quality gate.

## Why Existing Processes Are Not Enough

Some teams assume existing safeguards will catch the problem. They rely on code review, tests, linters, type checks, and CI pipelines. These are all necessary, but they are not sufficient.
Linters catch style and formatting problems. Type checks catch certain interface issues. Tests verify expected behavior. Code review catches implementation and design concerns.
But AI-generated code introduces failure modes that can pass through all of these filters.
The problem is not that these processes are useless. The problem is that they were not designed for a world where code can be generated faster than humans can understand it.

### Code Review Misses Intent

Code review is most effective when reviewers understand the purpose of the change.
With AI-generated code, the intent behind the implementation may not be visible. It may live in a prompt, a chat thread, a vague ticket, or only in the engineer’s head. When intent is missing, reviewers are forced to infer what the code was supposed to accomplish.
That changes the review from verification into guesswork.
A reviewer can comment on naming, structure, duplication, and conventions. But it is much harder to answer the most important question: **does this implementation actually match what we intended to build?**

### Tests Catch Less Than We Assume

Automated testing is essential, but tests only verify the behavior someone thought to test.
AI-generated code can introduce failure modes that were not anticipated. If the engineer did not think to specify a requirement, the AI may not implement it. If the test author did not think of an edge case, the test suite will not catch it.
A test suite can confirm that the code meets the expectations encoded in the tests, but it cannot confirm that the expectations were complete.

### CI Catches Surface-Level Slop

Continuous integration is excellent at catching mechanical issues such as build failures, linting violations, type errors, failing tests, and formatting problems.
But CI usually cannot tell whether a design decision was appropriate, whether a feature was overbuilt, whether a pattern was copied into the wrong context, or whether the implementation aligns with a business requirement that was never clearly written down.
CI is a filter, not a substitute for intent.

## The Real Bottleneck Is Understanding

The AI era changes the economics of software development.
Generating code is becoming cheaper, while reviewing and understanding code is becoming more expensive. This means engineering teams need to rethink where quality control happens.
If review only happens after the code exists, teams are forced to inspect large implementations after many decisions have already been made. By the time a pull request is ready, design assumptions have been embedded in code, missing requirements have turned into implementation gaps, and ambiguous prompts have become architectural choices.
Fixing those issues after the fact often requires rework.


<br>
<p align="center"><img src="/assets/img/research/AI_slop/AI_Code_Slop_fig3.jpg" alt="Christian Haller fig3" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@ikemura?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Jonathan Ikemura</a> on <a href="https://unsplash.com/photos/crowd-with-hands-up-at-a-bright-concert-stage-z0R4XB25ozI?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}


## What Comes Next

The solution is not to abandon code review. The solution is to move more of the review earlier.
Before teams generate large amounts of AI-assisted code, they need a clearer way to capture and review intent. They need to define what the code is supposed to do, what is out of scope, what constraints matter, and how success will be verified.
In Part Two, we will look at how intent-driven verification works, why spec-first workflows are becoming more important, and what practical guardrails engineering teams can adopt to reduce AI code slop without giving up the productivity benefits of AI-assisted development.