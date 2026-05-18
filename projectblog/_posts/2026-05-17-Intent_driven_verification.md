---
title: Intent-Driven Verification
image: /assets/img/research/AI_intent/AI_intent_Cover.jpg
description: >
  A Better Way to Review AI-Generated Code
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}


As an MLE Tech Lead, I have seen how quickly AI-assisted development can change the rhythm of an engineering team. It helps engineers move faster, explore solutions more easily, and get from idea to implementation with less friction. But it also creates a new review problem: when code is generated faster than teams can fully understand it, the real bottleneck shifts from writing code to verifying intent.
In Part One, we looked at why traditional code review is starting to break under the pressure of AI-assisted development.
AI can generate code faster than engineering teams can review it. That speed is useful, but it also creates a new risk: code that looks correct, passes basic checks, and still fails to reflect the real intent of the system.
The solution is not to abandon code review. It is to move the most important review earlier.
Instead of waiting until hundreds or thousands of lines of code have already been generated, teams should review the intent before implementation begins.

## The Missing Ingredient: Intent

Most bad AI-generated code does not fail because the model cannot write syntax. It fails because the model is solving an **underspecified problem**.
The prompt may be vague.
The ticket may be incomplete.
The acceptance criteria may be missing. The engineer may understand the desired behavior, but that understanding may never be written down in a form that can be reviewed or verified.
That creates a gap between what the team intended and what the AI implemented.
This is why intent needs to become a first-class artifact in AI-assisted development.
Before generating code, teams should specify what the change is supposed to accomplish, what is explicitly out of scope, and how the output will be judged.
This is alwo why this approach is sometimes called **Spec-Driven Development**.
This does not require a heavyweight process.
In many cases, intent can be captured with a short specification:

- Two or three sentences describing the scope
- A short list of acceptance criteria
- Any important constraints, conventions, or non-goals

The format matters less than the discipline of making intent visible before implementation starts.

## Why Review Should Move Upstream

The most expensive review is the one that happens after the code already exists.
When a design issue is caught in a written spec, fixing it may require changing a sentence. When that same issue is caught after implementation, fixing it may require rewriting tests, changing APIs, restructuring components, or reworking several pull requests.
This is especially true with AI-generated code because models can quickly turn ambiguity into implementation. A vague requirement does not stay vague for long. It becomes a database field, a service method, a frontend state model, or an API contract.
Once that happens, the team is no longer debating the requirement. They are debating code that already encodes an assumption.
Moving review upstream changes the quality gate. Instead of asking only, “Is this code acceptable?” teams also ask, “Are we asking the AI to build the right thing in the first place?”
That is a much better question to answer early.


<br>
<p align="center"><img src="/assets/img/research/AI_intent/AI_intent_fig1.jpg" alt="Christian Haller fig1" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@mikehindle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Mike Hindle</a> on <a href="https://unsplash.com/photos/modern-architectural-building-with-sharp-angles-against-dark-sky-qCrt7p6yu2Y?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}


## What Intent-Driven Verification Looks Like

Intent-driven verification is the practice of checking AI-generated code against a reviewed statement of intent.

The workflow can be simple:

1. Write or generate a lightweight spec.
2. Review the spec before code generation.
3. Generate the implementation.
4. Verify the output against the acceptance criteria.
5. Use human code review for implementation-level issues.

This does not replace traditional review. It gives reviewers a better target.
Instead of asking reviewers to infer the purpose of a large AI-generated pull request, the team gives them a shared reference point. The reviewer can compare the implementation against the stated intent, rather than trying to reconstruct that intent from the diff.
That makes review more focused, more consistent, and less dependent on guesswork.

## A Realistic Example

Imagine a team needs to add a repository-level configuration system.
Without intent-driven verification, the prompt might be something like:

> Build a configuration system that supports global and repository-specific settings.

That sounds reasonable, but it leaves a lot unresolved. Should repository settings override global settings? Should configuration changes be versioned? Who can edit settings? How should invalid values be handled? Where should the resolved configuration be used? What should the UI show when a value comes from a global default?
If those questions are not answered up front, the AI will still make choices. The problem is that those choices may not be the ones the team wanted.
A better approach is to first turn the request into a lightweight spec. For example:


```
## Scope

Build a repository-level configuration system that supports global defaults and repository-specific overrides.

## Acceptance Criteria

- Repository-level settings override global settings.
- The system records configuration change history.
- Invalid configuration values are rejected with clear validation errors.
- The API exposes both the resolved value and the source of that value.
- The frontend shows whether each setting comes from a global default or a repository override.

## Out of Scope

- Organization-level configuration inheritance.
- Bulk editing across repositories.
- Custom permission models beyond existing admin checks.
```

This spec is not long, but it makes the intent much clearer. It gives AI stronger guidance, gives reviewers something concrete to approve, and gives the team a basis for verification after implementation.


<br>
<p align="center"><img src="/assets/img/research/AI_intent/AI_intent_fig2.jpg" alt="Christian Haller fig2" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@ssszy?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Zhiyuan Sun</a> on <a href="https://unsplash.com/photos/snow-capped-mountains-under-a-starry-night-sky-2nwL6D1CsDU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}


## Use AI to Write Better Specs

One objection to spec-first workflows is that engineers do not want more process.
That concern is valid. If writing specs becomes slow or bureaucratic, teams will skip it under pressure.
But AI changes the cost of writing specs. The same tools that generate code can also help generate acceptance criteria, clarify ambiguity, and turn a rough ticket into a structured plan.
Instead of jumping straight to code generation, engineers can ask AI to:

- Turn a rough ticket into acceptance criteria
- Identify missing edge cases
- List likely out-of-scope items
- Ask clarifying questions before implementation
- Convert a product requirement into testable behavior

This uses AI to improve the request before using AI to produce the implementation.

## What Human Review Should Still Catch

Intent-driven verification does not make human code review obsolete. It changes what human review should focus on.
Spec review is good at catching missing requirements, unclear behavior, scope creep, and design-level ambiguity. Code review is still valuable for implementation-level issues that require familiarity with the codebase.
Human reviewers are especially important for naming conventions, module boundaries, error-handling patterns, logging standards, testing style, security-sensitive assumptions, maintainability, and consistency with existing architecture.
The goal is not to replace human judgment. The goal is to stop wasting human review capacity on issues that should have been caught before code existed.

## Five Guardrails Teams Can Start Using Now

### 1. Scope AI Tasks Tightly

Large, open-ended prompts produce the most slop.
A prompt like “build this feature” gives AI too much latitude. AI performs better when work is decomposed into smaller, well-specified tasks with explicit checkpoints.

### 2. Make Intent a Pull Request Requirement

For AI-assisted work above a certain complexity threshold, require a short intent section in the pull request:

```
## Intent

What is this change supposed to accomplish?

## Acceptance Criteria

How do we know it works?

## Out of Scope

What should this change not attempt to solve?
```

This gives reviewers a clear reference point and forces the author to separate the purpose of the change from the implementation details.

### 3. Review Intent Before Implementation

For larger AI-assisted changes, review the spec before generating the code.
This helps teams catch missing requirements, ambiguous behavior, and questionable scope while the artifact is still small and cheap to change.

### 4. Automate the Mechanical Checks

Tests, linting, type checks, formatting, static analysis, and CI all still matter. They catch surface-level slop and prevent reviewers from spending time on issues machines can detect.
Automation is one layer in a broader verification system, not a substitute for intent.

### 5. Build a Team Slop List

Every codebase has patterns that AI tends to get wrong.
Maybe it mishandles a specific error pattern, imports deprecated utilities, violates module boundaries, generates noisy logging, or uses a library the team has moved away from.
Write these recurring issues down.
A simple slop list can feed better prompts, improve coding instructions, and eventually become CI checks.


<br>
<p align="center"><img src="/assets/img/research/AI_intent/AI_intent_fig3.jpg" alt="Christian Haller fig3" style="width:480px"></p>
<br>
Photo by <a href="https://unsplash.com/@litvinov?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Egor Litvinov</a> on <a href="https://unsplash.com/photos/a-repeating-pattern-of-rounded-blue-tiles-rF1goYJuxbY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
{:.figcaption}


## You Do Not Need the Full Workflow to See Results

The biggest pushback against intent-driven workflows is that they sound slower.
But the goal is not to add bureaucracy.
The goal is to move expensive review work earlier, where changes are cheaper.
Teams can start small.
Require a short intent section for large AI-assisted pull requests.
Add acceptance criteria for higher-risk changes. Introduce spec review for larger features.
Over time, build a slop list and automate the most common recurring mistakes.
Even a few sentences of captured intent are better than asking reviewers to reverse-engineer the purpose of a large AI-generated diff.

## Final Thoughts

AI-assisted development does not eliminate the need for engineering judgment.
It makes engineering judgment more important.
As code generation becomes cheaper, the bottleneck shifts from writing code to understanding, verifying, and maintaining it.
Traditional code review still matters, but it should no longer be the first time the team evaluates the shape of a solution.
The better workflow is to review intent first, generate code second, and then verify implementation against the agreed-upon intent.
That is how teams can keep the productivity benefits of AI-assisted development without letting AI code slop quietly accumulate in the codebase.
