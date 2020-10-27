---
title: Digital Rocks
image: /assets/img/research/DigitalRock/berea0.png
description: >
  Rock analysis is not only an analog process in the laboratory anymore.
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}

## Introduction

The need for small-scale analysis of rocks is a common necessity in academia and industry. Digital analysis is precise and manipulation in a computer is non-destructive to the sample. This is an important consideration if the sample is rare or was expensive to obtain.

Benefits of digital analysis are the easy measurement of desired volumina and subsequent use in simulations. Digitalisation is realized with X-ray computed tomography (CT or MicroCT) or Focused Ion Beam in a Scanning Electron Microscope (FIB/SEM, which is technically destructive in a small area, since the ion beam removes layer after layer). In either case, a stack of equidistant 2d slices is created and can be used to reconstruct a 3d volume.

When sample is to be characterized it is a common task to segment and visualize and quantify pores, pore throats, post-depositional crystalizations, pore shapes etc.

I want to describe how geologists go about quantifying **porosity** and then model **permeability** from digital rocks.

## Step 1: Sampling

Take a hand sample, whole core, core plug, sidewall core in the field.


## Step 2: Scanning -> Slice Stack

Scan the sample with the appropriate device for the size of the sample and required resolution. The CT device will scan the sample, create a virtual model, and then export a stack of black-and-white images (so-called "slices").


## Step 3: Loading

Import stack of slices into a digital rock analysis suite. In my case, I used ThermoFisher PerGeos.


## Step 4: Noise Removal

Preprocess noisy images.

<img src="/assets/img/research/DigitalRock/berea5.png" alt="berea5" style="width:420px"><br>


## Step 5: Image Segmentation

Segment objects into classes. For example mask only the pores and assign them to class "pore space", then mask the mineral grains etc. Various segmentation techniques exist: manual selection, magic wand, thresholding by color value, watershed. To avoid operator bias, a completely automatic routine such as wathershed should be used that delivers repeatable results. 

<img src="/assets/img/research/DigitalRock/berea1.png" alt="berea1" style="width:420px"><br>


## Step 6: Disconnected Pores

Remove disconnected porosity (that has no permeability) from the total porosity and obtain the connected pore space.

<img src="/assets/img/research/DigitalRock/berea3.png" alt="berea3" style="width:420px"><br>


## Step 7: Separate Unique Pores

Divide the total pore space into separate pores and give each an identification.

<img src="/assets/img/research/DigitalRock/berea6.png" alt="berea6" style="width:420px"><br>


## Step 8: Network Model

Generate a pore-network model.

<img src="/assets/img/research/DigitalRock/berea4.png" alt="berea4" style="width:420px"><br>


## Step 9: Flow Modeling

Model the pressure field and permeability/hydraulic conductivity (K) by setting fluid viscosity and other boundary conditions. Watch the vectorized flow pattern *Single-Phase Flow Simulation through Sandstone*.<br>

Basically, this analysis pathway can also be applied to single thin sections, which were photographed under the optical microscope. In that case, no valid stack of equidistant slices is available. Some software suites can model the 3d stacking pattern of the grains if the type of rock is known. However, this is a much less quantitative approach.

The software used is ThermoFisher PerGeos 2019.4 with the freely available MicroCT dataset "Berea Sandstone Mini Plug". More info about the <a href="https://en.wikipedia.org/wiki/Berea_Sandstone" target="_blank">Berea Sandstone</a> and how it can be digitally processed in <a href="https://cases.pergeos.com/use-cases/analyzing-full-micro-ct-image-of-a-berea-sandstone-mini-plug-and-the-associated-challenges" target="_blank">ThermoFisher PerGeos</a>.

## Videos

*MicroCT Sandstone Porosity Segmentation*

<iframe width="560" height="315" src="https://www.youtube.com/embed/4AAFVgJ63bE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

*Single-Phase Flow Simulation through Sandstone*

<iframe width="560" height="315" src="https://www.youtube.com/embed/qUhcul-zl0c" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>