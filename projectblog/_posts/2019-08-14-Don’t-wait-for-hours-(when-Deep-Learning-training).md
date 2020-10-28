---
title: Don’t wait for hours (when Deep Learning training)
image: assets/img/research/Dont_Wait_For_Hours/Dont_Wait_For_Hours_Cover.jpg
description: >
  Consider making use of your GPU for massive efficiency gains.
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

## Introduction

When analyzing large data sets and building machine learning models, you will inevitably come across the question of how you want to write your code and then where to execute it. This is an especially important question when you are starting out with your endeavors and learning how the modeling is all done nowadays. Computational power is not part of that question and neither that important for toy examples.

<img src="https://pics.me.me/the-1-programmer-excuse-for-legitimately-slacking-off-my-neural-31632597.png" alt="Training Comic" width="400">

A lot of training classes will funnel you directly into their online platforms, touting free access and fully managed backends. This takes a lot of work off your hands that you would otherwise have to commit to setting up the environment, curating libraries, worrying about compatibilities etc. Great!

Nevertheless, when you start using Neural Networks, you may want to give your own workstation a shot at crunching the numbers. It may pay off. For comparison, I ran the same Jupyter notebook with a Keras sequential model once on IBM Cloud Watson Studio (free tier) and once on the workstation under my desk. The data set is the IMDB sentiment analysis provided pre-processed by Keras and is of moderate size. Here is what I experienced:

## Cloud-based Instance

e.g. IBM Watson Studio, AWS SageMaker

**Cons**
- Lowest tier provides limited CPU and memory capacity, no GPU
- If connection to kernel breaks down, all is lost (think cable company maintenance at night)

**Pros**
- Fully managed
- Get going instantly
- Lowest tier is free

## Workstation with GPU (single node)

The GPU takes 5 milliseconds per step and 119 seconds (~2 minutes) per epoch. This adds up to 1,785 seconds or ~30 minutes for the training process.

![Benchmark](/assets/img/research/Dont_Wait_For_Hours/benchmark.png)


**Cons**
- Time spent managing your system
- Costs for powerful discrete GPU…

**Pros**
- …but that may already exist in your system
- Nobody fiddles your setup but you
- Create environments with older language versions
- Parallelized computation on GPU


## Conclusion

Neural Networks are calculation intensive tasks that can take hours to days to train depending on the number of samples and model design. The example above indicates that your training can be expedited by many hours (57x faster) by running it on your GPU. The saved time more than compensates for the time spend in setting up Python on your workstation. Even older GPU models by Nvidia will do great and do not require the investment in an RTX 3090 or professional grade board.

Free tiers of online platforms such as IBM Watson Studio provide you with CPU power that does not harness the power of GPUs, resulting in long processing times. Of course, if you invest in a higher tier, that may be alleviated with more CPU cores. Or you may directly migrate your code to an advanced library that can address an Apache Spark Cluster, which can deal with industrial-scale amounts of data. But that may be beyond your scope. Meanwhile, your small workstation will save you a lot of time.