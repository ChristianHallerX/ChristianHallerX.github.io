---
title: What Geoscience Still Teaches AI Engineers About Data
image: /assets/img/research/Geoscience_AI/Geoscience_AI_Cover.jpg
description: >
  Labels, scale, uncertainty, and domain shift were never just machine-learning problems
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

Machine-learning projects often begin with a table. The columns have names, the rows have labels, and a model can be trained in a few lines of Python.

That table is rarely the beginning of the story.

<br>
<p align="center"><img src="/assets/img/research/Geoscience_AI/Geoscience_AI_fig1.jpg" alt="Ocean wave patterns showing variation in a natural system" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@matthardy" target="_blank">Matt Hardy</a> on <a href="https://unsplash.com/photos/body-of-water-under-sky-6ArTTluciuA" target="_blank">Unsplash</a>
{:.figcaption}

In geoscience, a row may represent a measurement taken at a particular depth, with a particular instrument, from a particular well, after a chain of sampling and interpretation decisions. A label may be a geologist's description of a core interval rather than an objective property that can be read directly from the rock. A pixel or voxel may look like an independent observation even though it belongs to the same specimen as thousands of neighboring pixels.

These details are not background information. They define what the data means and what a model can learn.

My earlier work with sedimentary facies classification, rock permeability, digital rocks, and MicroCT repeatedly returned to the same lesson: **before choosing a model, understand the measurement.** That lesson applies far beyond geology.

## A Dataset Is a Measurement of the World

The SEG facies classification dataset is a useful example. The input features come from wireline measurements collected in wells, while the target facies were assigned by subject-matter experts. The rows are not abstract records. They are observations tied to depth and well context.

The distinction matters because the same numeric value can mean different things in different settings. A gamma-ray response, density measurement, or porosity-related feature is not a label by itself. It is evidence that must be interpreted alongside the other measurements, the depth interval, and the geological setting.

This is true in less obviously scientific projects as well:

- A medical record is the result of a clinical workflow, not just a collection of numbers.
- A customer-support label reflects a taxonomy and an annotator's interpretation.
- A satellite pixel reflects an instrument, acquisition date, atmosphere, and geographic context.
- A manufacturing sensor reading reflects a machine, calibration state, and operating regime.

When a model performs unexpectedly, inspect how the data was produced before assuming that the algorithm is the problem.

<br>
<p align="center"><img src="/assets/img/research/Geoscience_AI/Geoscience_AI_fig2.jpg" alt="Eroded sandstone cliffs exposing geological layers" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@ed_wingate" target="_blank">Ed Wingate</a> on <a href="https://unsplash.com/photos/golden-sand-dunes-under-a-clear-blue-sky-viSgI4trvK8" target="_blank">Unsplash</a>
{:.figcaption}

## Lesson One: Labels Are Interpretations

The word “ground truth” can make labels sound more certain than they are.

In the facies project, a subject-matter expert manually described core sections and assigned facies names. That is valuable information, but it is still an interpretation. Boundaries between geological units may be gradual. Two experts may disagree about a transition. Some categories may be easier to distinguish than others, and some may be absent from the training examples altogether.

That uncertainty should influence the model workflow.

### Ask Where the Label Came From

For every supervised target, document:

- Who assigned it and what expertise they used
- Which observation or time window the label describes
- Whether multiple people reviewed the same examples
- How disagreements were resolved
- Which categories are ambiguous or rare
- Whether the label was available at prediction time

This is not paperwork added after modeling. It determines whether a score measures useful agreement or merely agreement with one particular labeling process.

### Do Not Hide Ambiguity in a Single Number

When labels are uncertain, a model should not be forced to express certainty that the data does not support. Depending on the application, useful responses may include:

- A probability distribution across categories
- An explicit “needs review” outcome
- A prediction interval or uncertainty estimate
- A request for another measurement
- A record of the examples most similar to the prediction

The right choice depends on the cost of being wrong. In a scientific workflow, a questionable prediction can be more useful when it is visible than when it is silently converted into a confident class.

## Lesson Two: Scale Changes the Question

Geoscience moves across scales constantly. A MicroCT scan can reveal internal structure in a small specimen. A core plug can support a laboratory measurement. A well log records properties along depth. A basin model asks questions across a much larger spatial and temporal scale.

Those observations cannot automatically be treated as interchangeable.

<br>
<p align="center"><img src="/assets/img/research/Geoscience_AI/Geoscience_AI_fig3.jpg" alt="Mountain lake and surrounding terrain" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@lucabravo" target="_blank">Luca Bravo</a> on <a href="https://unsplash.com/photos/brown-house-near-body-of-water-zAjdgNXsMeg" target="_blank">Unsplash</a>
{:.figcaption}

In digital-rock analysis, for example, a workflow can begin with a stack of two-dimensional CT slices, segment pore space, remove disconnected pores, construct a pore-network model, and simulate flow. Each step changes the representation. The final permeability estimate depends not only on the rock but also on resolution, segmentation, connectivity assumptions, boundary conditions, and the modeled volume.

The same pattern appears in computer vision and time-series ML. A model trained on individual pixels may fail when asked to classify an entire image. A model trained on short sensor windows may fail when the operating regime changes. A model trained on individual transactions may accidentally learn customer or account identity.

### Check the Unit of Independence

Before splitting data, ask what counts as one independent example.

| Apparent row | Possible independent unit | Risk if ignored |
| --- | --- | --- |
| Depth sample | Well or geological interval | Neighboring samples leak context across splits |
| Image patch | Specimen, patient, or scene | Near-duplicate patches appear in training and validation |
| Sensor window | Machine or operating run | The model memorizes equipment-specific behavior |
| Customer event | Customer or account | Identity becomes a shortcut for the target |

The row is a storage format. It is not automatically the unit at which a model will encounter new data.

## Lesson Three: Domain Shift Is Normal

The facies dataset includes measurements from multiple wells, and the hidden test wells represent a different prediction setting from the labeled training rows. That makes the evaluation question more meaningful than a simple random split: can the model generalize to an unseen well, not merely to another nearby depth sample?

Domain shift appears whenever the data-generating conditions change. Examples include:

- A new well, field, formation, or instrument
- A new hospital, scanner, or patient population
- A new camera, season, geography, or lighting condition
- A new factory line or machine configuration
- A new product category or customer segment

Randomly dividing rows can make a problem look easier than it is. Neighboring depth samples may be highly correlated. Image patches from one specimen may share the same texture. Repeated measurements from one machine may share a signature unrelated to the desired target.

### Make Validation Resemble Deployment

The validation strategy should follow the way the model will be used:

1. Identify the unit that should be unseen at prediction time.
2. Split by that unit where possible: well, specimen, patient, machine, site, or time period.
3. Preserve a final evaluation set that is not repeatedly used for decisions.
4. Compare the grouped result with a random row split to expose leakage.
5. Report performance by relevant subgroup, not only as one overall score.

A lower grouped score is not necessarily bad news. It may be the first honest measurement of the deployment problem.

<br>
<p align="center"><img src="/assets/img/research/Geoscience_AI/Geoscience_AI_fig4.jpg" alt="Mountain landscape illustrating variation between geological environments" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@von_co" target="_blank">Ivana Cajina</a> on <a href="https://unsplash.com/photos/silhoutte-of-mountains-during-sunset-dQejX2ucPBs" target="_blank">Unsplash</a>
{:.figcaption}

## Lesson Four: Missing Data Can Carry Meaning

In the facies example, some wireline measurements are missing, including the photoelectric-effect feature in portions of the data. Replacing a missing value with a mean can make a matrix convenient for a model, but it does not restore the measurement.

Missingness may be caused by tool limitations, sample quality, acquisition choices, or conditions under which the measurement is difficult. Those causes can be informative. A model should not confuse “the instrument did not produce a value” with “the value was average.”

For missing features, consider:

- Adding an explicit missingness indicator
- Recording why the value is missing when that information exists
- Testing whether missingness differs across sites, classes, or time periods
- Evaluating imputation inside the training pipeline to prevent leakage
- Measuring performance on cases with the same missingness pattern expected in use

The same warning applies to data cleaning. Removing unusual measurements may remove the exact rare event the model is supposed to detect. Cleaning should be justified by the measurement process, not only by a statistical rule.

<br>
<p align="center"><img src="/assets/img/research/Geoscience_AI/Geoscience_AI_fig5.jpg" alt="Desert dunes showing variation in geological environments" style="width:640px"></p>
<br>
Photo by <a href="https://unsplash.com/@gkumar2175" target="_blank">Ganapathy Kumar</a> on <a href="https://unsplash.com/photos/sandstone-buttes-in-monument-valley-L75D18aVal8 " target="_blank">Unsplash</a>
{:.figcaption}

## Model Choice Comes After Data Questions

The facies project used XGBoost with feature engineering and Bayesian hyperparameter optimization. Those are reasonable tools for structured data, but they were not the first source of meaning in the project.

The important earlier decisions included:

- Which measurements were available as features
- How missing values were handled
- How facies categories were represented
- How depth-neighborhood features were constructed
- Which wells were used for training and testing
- Which metric reflected the classification objective

An advanced model cannot repair a target that was defined incorrectly, a split that leaks information, or a measurement that does not exist at prediction time. A simpler model with a defensible evaluation design is usually more informative than a sophisticated model trained on an accidental shortcut.

## A Practical Data-Understanding Checklist

Before training an applied ML model, write down:

| Question | Record or decide |
| --- | --- |
| What physical, human, or operational process produced each feature? | Document its source, measurement context, and relevant acquisition conditions. |
| What exactly does the target describe, and who assigned it? | Define the target and record the labeling process and criteria. |
| What is the true unit of independence? | Identify the entity that should not be split across training and evaluation data. |
| Which groups, locations, instruments, or time periods must be unseen at prediction time? | Hold out the groups that reflect the intended deployment setting. |
| Which measurements are missing, and why? | Summarize missingness patterns and their known causes. |
| What shortcuts could a model use that would not survive deployment? | Check for leakage, identity signals, and other non-deployable predictors. |
| What does a useful error look like, and what does a dangerous error look like? | Define acceptable errors and the consequences of harmful ones. |
| Which metric and evaluation split expose those errors? | Choose metrics and a split that reflect the intended use and risks. |

Then create one deliberately simple baseline. Its purpose is not to win. It is to establish whether the data and evaluation design are coherent before more modeling effort is invested.

## Final Thoughts

Geoscience did not teach me that every AI problem should be solved with a geological analogy. Instead, it taught me to be suspicious of tidy tables.
-> Measurements have provenance. -> Labels have interpretation. -> Scale changes meaning. -> Missingness has causes. -> And the rows in a dataset are often less independent than they appear.
These are the conditions under which machine learning can be understood and should not be obstacles to machine learning tasks.
The most useful question before training a model is often not “Which algorithm should I use?”

It is:
> What would have to be true about this data for the result to mean what I think it means?