---
title: Taming the Tail - Adventures in Improving AI Economics - a16z
image: /assets/img/research/Taming_Tail/Taming_Tail_Cover.jpg
description: > 
  Summary from reading the Andreessen Horowitz blog
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}
The writeup below are some highlights I wrote for myself. If you find the writeup useful and want to know more, then you should absolutely read the article linked.
{:.note}

This is my personal summary from reading <a href="https://a16z.com/2020/08/12/taming-the-tail-adventures-in-improving-ai-economics/" target="_blank">Taming the Tail: Adventures in Improving AI Economics</a>, which was published on the Andreessen Horowitz blog https://a16z.com/, a Silicon Vally venture capital (VC) investor. This VC supported the likes of Skype and Facebook when they were still little known and dozens of others whos digital services we are using in our daily lives.
The article is excellently written, and part of the <a href="https://a16z.com/2020/12/17/ai-in-2020/" target="_blank">AI in 2020</a> series. This series is a distillation of dozens of interviews the authors lead with ML tams and thus marks a great resource for machine learning professionals who want deep insights into new AI developments, be it startups or mature companies. And last but not least it helps evaluating the next job opportunities. Most of all, the series is intended by Andreessen Horowitz to support AI companies, a sector in which they are investing heavily.

AI companies is different from traditional software companies and are more challenging to scale and achieve the same profit margins. Often they have lower margins, are harder to scale, and don’t always have strong defensive moats.


## Part I: Understanding the problem to be solved
(...in the presence of long-tailed data distributions)

### Building vs. experimenting (or, software vs. AI)

Traditional software is a task of engineering. The specifications of a product are defined and then slowly added to the software - one line of code at a time.

AI developers build statistical models, measure them, build a new one, measure, and so on. Until a satisfactory quality threshold was crossed, the AI modeler has to go through this experimentation loop. The article quotes an AI CTO that the process is “closer to molecule discovery in pharma” than engineering. Another issue is that the code written by the AI developer only indirectly influences the output, which adds an additional layer of complexity. It mainly governs how the dataset is processed, but the quality of the outcome is unsure.

### The long tail and machine learning

Many ML natural datasets have a long-tailed (skewed) frequency distribution. The long tail makes up ~70% of the total amount of samples. This makes it when picking randomly much more likely to receive a sample from the tail. Head and Middle, where the most common samples are, receive only 30% of picks.

However, the low-frequency samples from the tail are harder to train with supervised learning, while value is relatively low. These long-tail samples are often also called "edge cases" and are much harder to get right.

### Impact on the economics of AI

- Improving models on the long tail costs a lot of compute resources and thus creats more (cloud) costs than traditional software would cause (3-5x higher).

- Data has a cost to collect, process, and maintain. That means the larger the long-tailed dataset becomes, the harder it becomes to work with it and more costly, too. The projects actually show "DISeconomies of scale". While more data  to improve a model is often available, the long-taildness also means a diminishing return. AI developers may need 10x more data to achieve a 2x subjective improvement. While computing power becomes cheaper and more available (Moore's Law), this does not occur with model performance at the moment.



## Part II: Building Better AI Systems

### Toward a Solution

Economics of AI are a function of the problem (dataset modeling/characterizing causes computing costs), not part of the technology used (computing efficiency gains). Hence, the approach of the long-tail frequency distribution has to be optimized.

### Easy mode: Bounded problems

First of all, it has to be determined if a long-tailed frequency dataset is there at all. If not, then no ML or DL should be used. Linear or Polynomial Regression will be much more efficient.

Logistic Regression and Random Forests are popular because they are A) interpretable, B) scalable, C) computationally efficient. DL may have its use cases in NLP (text generation and understanding), sentiment analysis but accuracy improvement has to be tightly balanced with training and maintenance costs.

ML is not always the best solution to everything, which should be very closely evaluated. Heuristic and if/then approaches may be much easier to implement.

### Harder: Global long tail problems

Serving a single (global) model if there is large customer-segment/region overlap is much cheaper than building multiple models. -> "One size fits all"

Tactics to build around the long tail:

- Optimize the model -> add more (customer) training data, adjust hyperparameters, tweak architecture.
- Narrow the problem to the fat head -> restrict user-input complexity to avoid creating an unnecessary tail -> e.g. auto-comlete text input for the user.
- Convert the problem -> human intervention for special edge cases or create single-turn interfaces that cover the long tail more easily.

Componentizing:

Train different simpler models to do different jobs concurrently. Example: Couldflare using 7 models to detect 6-7 different bot types attacking websites. Each model is global, and relatively easy to maintain.

### Really hard: Local long tail problems

It is common to observe local problem (data) variation with customers, which do have to be addressed. Effort in modeling is based on the degree of local variation (countries, specific large customers....). Example: streaming services generating playlist models for each country.

How to bring the benefits of global models to local problems?

- Adoption of the meta-model technique, which covers multiple clients and tasks: e.g., combine thousands of user-specific models into a single, cheaper meta model.
- Transfer Learning: Using pre-trained models simplifies training needs and makes fine-tuning per customer easier. Example: GPT-3 NLP model that needs to be adjusted for local needs.
- Join similar model with a common trunk to reduce complexity. Making the trunk as thick as possible, the branches as thin as possible without decreasing accuracy. Example: Facebook combining models for furniture, cars, fashion which is cheaper and more accurate. Benefits: parallel model training and high local accuracy, yielding a global-pattern-like model.

### Table stakes: Operations
Operational best practices to improve AI economics:
- Consolidate data pipelines. Do not use one pipeline per model. Combine multiple customers into one ETL process, re-train less often (only at night, or when enough data available).
- Edge case engine, a collection of odd long-tail samples and systematically collecting long-tail samples.
- On-Prem ML clusters with GPUs can unlock massive savings. Example: startup saved 10 Million USD with their own cluster in colocation facility compared to AWS.
- Model quantization, distillation, pruning, compression, and compilation (including APIs and pre-trained models)
- Frequent testing, not only accuracy, F1 etc. but also on A) bad data, B) privacy violations, C) precision mismatches, D) model drift, E) bias, and F) adverserial tactics.


## Summary
AI is still in its early years and has not yet crossed the peak of the hype cycle. More efficiency is needed. Structures similar to software development will likely appear