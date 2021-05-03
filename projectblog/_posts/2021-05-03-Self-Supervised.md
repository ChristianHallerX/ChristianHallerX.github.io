---
title: Self-Supervised Learning - A recap by Facebook AI
image: /assets/img/research/Self_supervised_learning/Self_supervised_learning_Cover.jpg
description: > 
  Are we done with labeling yet?
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}


## Preface

This is my personal summary from reading <a href="https://ai.facebook.com/blog/self-supervised-learning-the-dark-matter-of-intelligence" target="_blank">Self-supervised learning: The dark matter of intelligence (4th March 2021)</a>, which was published on the Facebook AI blog <a href="https://ai.facebook.com/blog/" target="_blank">https://ai.facebook.com/blog/</a>.
This department at Facebook is dedicated to applied research, but also assembles smart scientists that undertake relatively basic, but ground-braking research.
The article is offering an overview of Facebook's AI-frontier research on self-supervised learning (SSL) in the wake of other papers published by Facebook in the same month <a href="https://ai.facebook.com/blog/dino-paws-computer-vision-with-self-supervised-transformers-and-10x-more-efficient-training/" target="_blank">DINO and PAWS: Advancing the state of the art in computer vision</a>.


## Introduction

Supervised models are specialized on relatively narrow tasks and require *massive amounts of carefully labeled data*.
As we want to expand the capabilities of state-of-the-art models to classify things, "it’s impossible to label everything in the world.
There are also some tasks for which there’s simply not enough labeled data [...]".
The authors postulate that supervised learning may be at the limits of its capabilities and AI can develop beyond the paradigm of training specialist models.
Self-supervised learning can expand the use of specialised training sets to bring AI closer to a generalized, human-level intelligence.

Going beyond a specialized training set and forming a common sense from repeated trial-and-error cycles is in essence what humans and animals do.
Humans learn without massive amounts of teaching all kinds of possible variants of the same but rather build upon previously learned input.
This common sense is what AI research is aspiring to when referring to self-supervised learning and what has remained elusive for a long time.
The authors call this form of generalized AI the "Dark Matter" of AI: it is assumed to be everywhere and pervasive in nature, but we can't see or interact with it (yet?).

While SSL is not entirely new. It has found widespread adoption in training models in Natural Language Processing (NLP).
Here, Facebook AI uses SSL for Computer Vision tasks and explains why SSL may be a good method for unlocking the "Dark Matter" of AI.


## Self-supervised learning is predictive learning

Self-supervised learning is trained by signals from the data itself instead of labels.
The data in the training set is not a complete set of observations (samples) and thus the missing parts are predicted using SSL.
In an ordered dataset such as a sentence or a series of video frames, missing parts or the future/past can be predicted without the use of labels.

Since training signals are originating from the dataset itself, the term self-supervised learning is more fitting than the older term "unsupervised learning".
The authors argue that self-supervised learning uses more supervision signals than both supervised and reinforcement learning.


## Self-supervised learning for NLP and CV

In Natural Language Processing, a model is trained by showing it long texts - but no labels.
These models are pretrained in a self-supervised phase and then fine-tuned for a use case, such as classifying the topic of a text (see sentiment analysis etc.).
When given a sentence with blanked out words, the model can predict the "correct" words.
The same concept was tried to apply towards Computer Vision (CV) but so far has never shown the same improvements as in NLP.
A large challenge to overcome is the expression of uncertainty for predicted gaps in CV, which was relatively easy in NLP.
That is because NLP always works with a finite vocabulary and each word can be given a probability value.
Having to design a model for CV requires incorporating accurate representations of errors, which used to be costly in computation and memory.

In the past, Facebook's FAIR workgroup designed a new architecture of Convolutional Networks called RegNet (Regular Network) that solves this issue and efficiently stores billions/trillions of network parameters.
It is still impossible to assign error to an infinite number of possible missing frames or patches within a frame, since we do not have a vocabulary as in NLP.
However, efficient SSL techniques such as SwAV are improving vision-task accuracy using billions of samples.


<p align="center"><img src="/assets/img/research/Self_supervised_learning/NLP_book.jpg" alt="Christian Haller book" style="width:480px"></p>
Photo by <a href="https://unsplash.com/@priscilladupreez" target="_blank">@priscilladupreez</a> on Unsplash
{:.figcaption}


## Modeling the uncertainty in prediction

During NLP's prediction process the uncertainty is expressed with a softmax function across the entire vocabulary.
That means the sum of all vocabulary probabilities add up to 1.0 and the most likely word gets the highest probability assigned.

In CV, a frame or patch in a frame out of infinite possibilities is predicted instead of NLP's discrete vocabulary.
We may never be able to assign prediction scores to infinite frames of a high-dimensional continuous space or find techniques to solve this problem.


## A unified view of self-supervised methods

Self-supervised models can be viewed within the framework of energy-based models (EBM). For this model, `x` is trained material, which is compared to `y`.
A single energy number tells how compatible `x` and `y` are or how likely it is that video clip/photo `y` follows clip/photo `x`.
Low energy denotes good compatibility, high energy bad compatibility.
The smaller the differences in x and y, the lower the energy value will be.


### Joint embedding, Siamese networks

Siamese networks use two identically architected deep neural networks with shared parameters that encode two images.
The networks calculate the two image embeddings, which are compared with each other.
The networks are trained to produce low energies, which makes it sometimes difficult to calculate high energies when needed for different images.
Several techniques exist to avoid the network to produce very similar embeddings for every sample, which is called "collapse".

<p align="center"><img src="/assets/img/research/Self_supervised_learning/siamese_twins.jpg" alt="Christian Haller siamese twins" style="width:480px"></p>
Photo by <a href="https://unsplash.com/@mrcageman" target="_blank">@mrcageman</a> on Unsplash
{:.figcaption}


#### Contrastive energy-based SSL

Latent-variable models can be trained with contrastive methods.
A good example of contrastive models is the Generative Adverserial Network (GAN) architecture.
In SSL, selecting well-chosen pairs of `x`, `y` that are incompatible to achieve high energies.

As desribed above, NLP problems are easier to tackle with its finite vocabulary.

A latent-variable predictive architecture can be given an observation `x`, the model must be able to produce a set of *multiple* compatible predictions.
Latent-variable predictive models contain an extra input variable `z`.
This variable `z` is called latent because its value is never observed.
As the latent variable `z` varies within a set, the output varies over the set of predictions.

However, it is very difficult to find maximally incompatible pairs of images (high-dimensional data).
So, how could it be possible to increase energy for incompatible candidates?


#### Non-contrastive energy-based SSL (regularization-based)

This is a very actively researched field in SSL and are divided into two groups: 
 1. computing virtual target embeddings for groups of similar images
	- DeeperCluster
	- SwAV
	- SimSiam

 2. making the two encoders slightly different (architecture or parameter vector)
	- BYOL
	- MoCo

However, the authors hypothesize that it may be beneficial in the future to combine non-contrastive models with latent variables.

Future research will focus on top performing models without requiring large amounts of labeled data.


<p align="center"><img src="/assets/img/research/Self_supervised_learning/predict.jpg" alt="Christian Haller predict" style="width:480px"></p>
Photo by <a href="https://unsplash.com/@vork" target="_blank">@vork</a> on Unsplash
{:.figcaption}


## Advancing self-supervised learning for vision at Facebook

A new network was trained at Facebook AI called *SEER* that may bring about a paradigm shift in CV:
 - The network contains 1 billion parameters, with the SwAV method applied to a Convolutional Network.
 - It was trained on random Instagram images without any labels.
 - It outperforms any other self-supervised dataset.
 - It reached 84.2 percent top-1 accuracy on ImageNet data.

## Summary

Supervised learning is at the forefront of everyone's attention today.
Self-supervised methods have been restricted to certain niches such as NLP, where predictions were descrete and finite.
Current challenges with bringing Self-supervised methods to CV requires solving problems of calculating probabilities for infinite continuous, hyperdimensional predictions.
Siamese networks trained on non-contrasting data is current state-of-the-art to avoid endless training of supervised networks.
Facebook released a new, open-source network called SEER that outperforms any other self-supervised network after it was pre-trained on random, un-labeled images.