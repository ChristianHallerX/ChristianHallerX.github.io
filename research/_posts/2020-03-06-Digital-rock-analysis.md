---
title: Digital Rocks
image: /assets/img/research/berea0.png
description: >
  Rock analysis is not only an analog process in the laboratory anymore.
---

The need for small-scale analysis of rocks is a common necessity in academia and industry. Digital analysis is precise and manipulation in a computer is non-destructive to the sample. This is an important consideration if the sample is rare or was expensive to obtain.

Benefits of digital analysis are the easy measurement of desired volumina and subsequent use in simulations. Digitalisation is realized with X-ray computed tomography (CT or MicroCT) or Focused Ion Beam in a Scanning Electron Microscope (FIB/SEM, which is technically destructive in a small area, since the ion beam removes layer after layer). In either case, a stack of equidistant 2d slices is created and can be used to reconstruct a 3d volume.

When sample is to be characterized it is a common task to segment and visualize and quantify pores, pore throats, post-depositional crystalizations, pore shapes etc.

I want to describe how geologists go about quantifying **porosity** and then model **permeability** from digital rocks.

**Step 1** Take a hand sample, whole core, core plug, sidewall core in the field.

**Step 2** Scan the sample with the appropriate device for the size of the sample and required resolution. The CT device will scan the sample, create a virtual model, and then export a stack of black-and-white images (so-called "slices").

**Step 3** Import stack of slices into a digital rock analysis suite. In my case, I used ThermoFisher PerGeos.

**Step 4** Preprocess noisy images.

<img src="/assets/img/research/berea5.png" alt="berea5" style="width:420px"><br>

**Step 5** Segment objects into classes. For example mask only the pores and assign them to class "pore space", then mask the mineral grains etc. Various segmentation techniques exist: manual selection, magic wand, thresholding by color value, watershed. To avoid operator bias, a completely automatic routine such as wathershed should be used that delivers repeatable results. 

<img src="/assets/img/research/berea1.png" alt="berea1" style="width:420px"><br>

**Step 6** Remove disconnected porosity (that has no permeability) from the total porosity and obtain the connected pore space.

<img src="/assets/img/research/berea3.png" alt="berea3" style="width:420px"><br>

**Step 7** Divide the total pore space into separate pores and give each an identification.

**Step 8** Generate a pore-network model.

<img src="/assets/img/research/berea4.png" alt="berea4" style="width:420px"><br>

**Step 9** Model the pressure field and permeability/hydraulic conductivity (K) by setting fluid viscosity and other boundary conditions

<br>

Basically, this analysis pathway can also be applied to single thin sections, which were photographed under the optical microscope. In that case, no valid stack of equidistant slices is available. Some software suites can model the 3d stacking pattern of the grains if the type of rock is known. However, this is a much less quantitative approach.

The software used is ThermoFisher PerGeos 2019.4 with the freely available MicroCT dataset "Berea Sandstone Mini Plug". More info about the <a href="https://en.wikipedia.org/wiki/Berea_Sandstone" target="_blank">Berea Sandstone</a> and how it can be digitally processed in <a href="https://cases.pergeos.com/use-cases/analyzing-full-micro-ct-image-of-a-berea-sandstone-mini-plug-and-the-associated-challenges" target="_blank">ThermoFisher PerGeos</a>.

## Play on Youtube

*MicroCT Sandstone Porosity Segmentation*

<a href="https://www.youtube.com/watch?v=4AAFVgJ63bE" target="_blank"><img src="http://img.youtube.com/vi/4AAFVgJ63bE/0.jpg" alt="MicroCT Sandstone Porosity Segmentation" width="180" border="10" /></a>

*Single-Phase Flow Simulation through Sandstone*

<a href="https://www.youtube.com/watch?v=qUhcul-zl0c" target="_blank"><img src="http://img.youtube.com/vi/qUhcul-zl0c/0.jpg" alt="Single-Phase Flow Simulation through Sandstone" width="180" border="10" /></a>