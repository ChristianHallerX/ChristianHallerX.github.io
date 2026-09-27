---
title: From Prompt to Production
image: /assets/img/research/Prompt_to_production/Prompt_to_production_Cover.jpg
description: >
  What changes when an AI pipeline has to survive outside the notebook
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

This is a small reference design rather than a claim that one stack fits every team. The example is an AI request-routing service: it reads an incoming support request, assigns one of a small set of known categories, and returns a structured result that another system can use.

Generating a convincing AI demo is getting easier. A few prompts can produce a useful answer, a clean API, and a polished interface in a short amount of time.

<br>
<p align="center"><img src="/assets/img/research/Prompt_to_production/Prompt_to_production_fig1.jpg" alt="Developer working at a laptop in a modern workspace" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@cgower" target="_blank">Christopher Gower</a> on <a href="https://images.unsplash.com/photo-1498050108023-c5249f4df085" target="_blank">Unsplash</a>
{:.figcaption}

That is not the same as having a production service.

The difficult questions begin when the service has to handle malformed input, ambiguous requests, changing models, latency limits, operating costs, and failures that a demo never encountered. The code is only one part of the problem. The rest is deciding what the system is supposed to do and collecting enough evidence to know whether it does it.

The example is deliberately modest. It does not resolve the request, write to a ticketing system, or replace a support agent. It demonstrates the boundary around one model-backed decision, because that boundary is where a prototype starts becoming an engineering system.

## Start With Intent, Not Code

Before choosing a model or framework, write down the boundary of the service.

This could be simply dumping your Product Requirements Document (PRD) into the AGENTS.MD file or use the following as guide.

### Scope

Given the text of an incoming support request, return its category, a confidence or abstention signal, and a short explanation suitable for a downstream support workflow.

### Acceptance Criteria

- Every accepted request returns exactly one known category or an explicit `needs_review` result.
- Empty, oversized, or malformed requests are rejected before they reach the model.
- The response includes the category, confidence signal, explanation, and pipeline version.
- The evaluation set contains representative examples, ambiguous requests, and requests that belong outside the supported categories.

### Out of Scope

- Automatically replying to the customer or changing a ticket.
- Detecting every possible support topic outside the defined category set.
- Guaranteeing that a low-confidence prediction is correct.

This small specification is not bureaucracy. It is the reference point against which the implementation can be verified. Without it, a successful response can still be evidence that the system solved the wrong problem.

## Choose the Smallest Useful Architecture

The first version should have one clear path from request to response:

```text
Client -> HTTP API -> Input validation -> AI pipeline -> Output validation -> Response
                              |                    |
                              +---- logs ----------+
```

For this example, the AI pipeline is represented by a typed classification module, the HTTP boundary is a FastAPI-style service, and Docker provides a reproducible runtime. DSPy can be used to define and optimize the pipeline, but the service contract should remain independent of that choice. The same API should still make sense if the underlying model or orchestration framework changes.

The point of this stack is not that it is universally correct. The point is that each component has a job that can be tested independently:

- The pipeline transforms an accepted input into a proposed result.
- The API enforces the external contract.
- The container makes the runtime reproducible.
- The deployment provides a place to observe and operate the service.

Avoid adding a second model, a queue, a feature store, or a generalized orchestration layer until the first path has a failure that requires it.

<br>
<p align="center"><img src="/assets/img/research/Prompt_to_production/Prompt_to_production_fig2.jpg" alt="Team collaborating around a laptop" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@anniespratt" target="_blank">Annie Spratt</a> on <a href="https://images.unsplash.com/photo-1551434678-e076c223a692" target="_blank">Unsplash</a>
{:.figcaption}

## Build One Vertical Slice

The first implementation should answer one complete request from beginning to end. It does not need every feature. It needs a path that can be exercised repeatedly.

```python
@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest) -> PredictionResponse:
    result = pipeline(request.text)
    return PredictionResponse.from_result(result)
```

The vertical slice should make the following decisions explicit:

1. What inputs are accepted?
2. What does the service return when the model is uncertain?
3. Which failures are client errors, service errors, or valid low-confidence results?
4. Where are model and prompt/program versions recorded?

## Test the Contract, Not Just the Happy Path

A service can return plausible answers and still be unfit for use. The test set needs to represent the behavior promised in the intent statement.

| Test group | Question | Evidence |
| --- | --- | --- |
| Representative examples | Does the common path work? | Compare predictions with reviewed labels. |
| Boundary inputs | What happens at empty, long, or malformed input? | Expect a deterministic validation error. |
| Ambiguous examples | Does the service know when to defer? | Expect `needs_review` or a low-confidence result. |
| Unsupported examples | Does it avoid inventing a category? | Expect an explicit out-of-scope response. |
| Contract checks | Does every response match the schema? | Validate the response before returning it. |
| Operational checks | Is latency and cost within the target? | Run a fixed batch under documented conditions. |

The most valuable test is often not another happy-path example. It is a case that exposes an assumption hidden in the original prompt or ticket.

<br>
<p align="center"><img src="/assets/img/research/Prompt_to_production/Prompt_to_production_fig3.jpg" alt="Laptop used for software development" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@christinhumephoto" target="_blank">Christin Hume</a> on <a href="https://images.unsplash.com/photo-1516321318423-f06f85e504b3" target="_blank">Unsplash</a>
{:.figcaption}

## Measure Before You Optimize

The old saying holds true "You can't manage what you don't measure", but furthermore, the service needs a baseline before it needs a more elaborate architecture.

Set targets before the first optimization pass, then record observed values under documented conditions:

- **Quality:** macro-F1 or per-category recall on a reviewed evaluation set
- **Latency:** p50 and p95 response time at the expected concurrency
- **Cost:** estimated cost per request, including model and hosting costs
- **Reliability:** request error rate over a defined observation window
- **Failure modes:** examples of wrong categories, unsupported requests, and service errors

For this reference design, the initial targets might be a documented evaluation set, a p95 latency suitable for the support workflow, and a safe abstention behavior on ambiguous inputs. Those are targets, not results. Publishing a number without the dataset, model, prompt or program version, and test conditions makes comparison almost meaningless.

These measurements are not a promise that the service will behave the same way forever. They are a way to detect when a model, prompt/program, dependency, or deployment change has altered the behavior.

## Make Failure Visible

Production systems fail. A useful service makes those failures diagnosable instead of hiding them behind a generic fallback.

At minimum, capture:

- A correlation or request identifier
- Model and pipeline version
- Input and output metadata that is safe to retain
- Validation failures and downstream errors
- Latency and resource measurements
- A clear distinction between rejected input and internal failure

Do not log sensitive request content by default. Decide what can be retained, who can access it, and how long it should remain available before the service goes live.

## What AI Can Generate, and What It Cannot Verify

An AI assistant can help produce scaffolding, tests, documentation, and alternative implementations. It can also suggest an architecture that sounds more complete than the problem requires.

The engineer still has to verify:

- Whether the implementation matches the intent
- Whether the framework APIs exist in the selected versions
- Whether the tests measure the behavior that matters
- Whether errors are handled according to the service contract
- Whether the deployment assumptions are true
- Whether the data and logs are appropriate to use

The production boundary is where plausible code meets real constraints. That boundary deserves more scrutiny than the first successful response.

## A Small Production-Readiness Checklist

Before calling the service production-ready, ask:

- Is the scope written down and approved?
- Are non-goals explicit?
- Does the API reject invalid input predictably?
- Are representative and adversarial examples tested?
- Are quality, latency, cost, and failure behavior measured?
- Can the running version be identified?
- Are logs useful without exposing sensitive data?
- Is there a rollback or disable path?
- Is the service owner clear?

If several answers are “not yet,” the service may still be a valuable prototype. The important thing is to describe it accurately.

## Final Thoughts

The distance from prompt to production is not measured by how many lines of code separate the two. It is measured by how many unanswered questions remain.

A small AI service becomes easier to trust when its intent is visible, its boundary is narrow, its behavior is tested, and its failures are observable. That process does not remove engineering judgment. It gives engineering judgment something concrete to inspect.

The next step would be to run the reference design against a small, reviewed dataset and publish the results with the model, pipeline version, evaluation criteria, and test conditions. That evidence matters more than a claim that the service is “production-ready.”