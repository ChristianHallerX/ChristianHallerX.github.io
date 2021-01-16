---
title: My Machine Learning Model Is Perfect
image: /assets/img/research/ML_Perfect/ML_Perfect_Cover.jpg
description: > 
  Reasons that make ML experts look at your code twice.
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

## Code that needs refactoring

Strange and hard-to-read code is a common reason to elicit refactoring (rewriting).
Think of unstructured Spaghetti Code&trade; without a lot of documentation &#8211; or the opposite &#8211; too much documentation that you can't see the forest for the trees anymore.
These kind of code issues are called "code smell".
A term that has been widely adopted after 1999 when the book <a href="https://martinfowler.com/books/refactoring.html" target="_blank">"Refactoring: Improving the Design of Existing Code"</a> by Martin Fowler was published.
Its essence, refactoring is applying a series of small behavior-preserving transformations with the cumulative effect of "reducing the risk of introducing errors".


Some smells are easy to spot, some subtler and more insidious than others.
While these problems and signs may not be detrimental by themselves, they warrant a closer look.
You may have seen some of them before:

- Unnecessary complexity (a.k.a. showing off).
- Functions with too many arguments, indicating "God functions" without partitioning into helper-functions.
- Runaway function length across the screen making it hard to read.
- Excessive commenting making it hard to distinguish code from non-code.
- Duplicated code - That's where the principle Don't Repeat Yourself (DRY) comes from.

Have a look at the full list of code smells and their description on <a href="https://en.wikipedia.org/wiki/Code_smell" target="_blank">Wikipedia</a> and what Anupam Chugh discusses in his TowardsDataScience post <a href="https://towardsdatascience.com/5-python-code-smells-you-should-be-wary-of-c48cc0eb9d8b" target="_blank">"5 Python Code Smells You Should Be Wary Of"</a>.


### Breakout: Who has the smelliest code?

At the time of writing this, Google Search users from Washington state were the most interested in code smells or at least ranking very highly. <a href="https://trends.google.com/trends/explore?date=all&geo=US&q=%2Fm%2F01h_xq" target="_blank">Check now on Google Trends</a>. 
Is their code the smelliest of them all? Interest likely correlates with the amount of coders in a state and inevitably there is problematic code among.

<br>
<p align="center"><img src="/assets/img/research/ML_Perfect/ML_perfect_dog.jpg" alt="Christian Haller ML_Perfect dog" style="width:360px"></p>
Photo by <a href="https://unsplash.com/@claybanks" target="_blank">@claybanks</a>  on Unsplash
{:.figcaption}
<br>

## What does Machine Learning smell like?

Almost all Machine Learning entails someone writing code.
This means the known problems or smells may be emanating from the codebase - regardless if we have written it or someone else put it into a black box for us to call.
Machine Learning models are traditional functions but are mathematically adhering to different paradigms: a function that relates sample value X to some target value y.
While all the functions of a comprehensive ML/DL library such as PyTorch, TensorFlow, and Scikit-learn are hopefully optimized and free of code smells under the hood, a project involves more than just a single algorithm that's invoked in a single function.
The workflow of invoking the library's functions bespoke to our project's needs is a <a href="https://en.wikipedia.org/wiki/Metamodeling" target="_blank">"metamodel"</a> with design complexities of its own.

So what are the "ML smells" that might alert us to deeper problems in our prediction tools?

<a href="https://agilescientific.com/who" target="_blank">Dr. Matt Hall</a> recently asked the following question on Twitter and in the geological machine learning community <a href="https://softwareunderground.org/" target="_blank">Software Underground</a> he co-founded:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">🐽 ML smell is probably not a thing, but maybe it should be. What are the superficial signs of potentially deeper problems in a <a href="https://twitter.com/hashtag/machinelearning?src=hash&amp;ref_src=twsrc%5Etfw">#machinelearning</a> project?</p>&mdash; Matt Hall (@kwinkunks) <a href="https://twitter.com/kwinkunks/status/1313841986886152194?ref_src=twsrc%5Etfw" target="_blank">October 7, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

<br>

Matt crowdsourced some excellent responses:

- **Black-box services** such as AutoML.

- **Counterintuitive model weights** -> known effects have low feature importance. (Reece Hopkins, Anchorage)

- **Unreproducible, non-deterministic code** -> not setting random seeds. (Reece Hopkins, Anchorage)

- **No train–val–test split description/justification**. Leakage between training and blind data is easy to introduce with random splits in spatially correlated data. (Justin Gosses, Houston)

- **No evaluation metric discussion** -> how it was selected or designed (Dan Buscombe, Flagstaff)

- **No ground truth discussion** and how the target labels relate to it. (Justin Gosses, Houston)

- **Excessive hyperparameter precision** -> might suggest over-tuning. (Chris Dinneen, Perth)

- **Precision–recall trade-off not considered** -> especially in a binary classification task. (Dan Buscombe, FLagstaff)

- **Strong class imbalance** and no explicit mention of how it was handled. (Dan Buscombe, Flagstaff)

- **Skewed feature importance** on one or two features might suggest feature leakage. (John Ramey, Austin)

- **Making excuses** -> “we need more data”, “the labels are bad”, etc. (Hallgrim Ludvigsen, Stavanger)

- **Time spend cleaning data too short** -> Less than 80-90% of the effort spent on preparing the data. (Michael Pyrcz, Austin)

- **Very high accuracy**, e.g., 0.99 for a complex model on a novel task. (Ari Hartikainen, Helsinki and Lukas Mosser, Athens). In most real-world scenarios accuracy near 0.7 is excellent, and anything >0.8 indicates something unusual going on.

That’s a long list, but there are most likely more.

Most likely we have our own biases and tendencies to produce some smell because we were not aware, did not know any better, or had no other choice.
This is where peer review provides a second (or third, or fourth...) pair of eyes is critical and all smells get cleaned up.

What do you think?

How perfect is *your* ML code and what kind of surface phenomena have you seen that may indicate deeper-rooted problems in ML projects?

Maybe it is time for someone to officially coin a new term called "ML Smell".....

Thank-you to <a href="https://twitter.com/kwinkunks/status/1313841986886152194?ref_src=twsrc%5Etfw" target="_blank">Matt Hall</a> whose question inspired me to write this up!
