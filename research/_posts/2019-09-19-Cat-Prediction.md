---
title: Cat Prediction
image: /assets/img/research/Cat_pred.png
description: >
  Neural Networks can be used to effectifely classify images - unless...
---

Image classification is nowadays a common job for neural networks. The RGB values of a photo are unrolled into a feature vector and the neurons will learn the label given to it.

Cat photos are an all-time favorite. Can the computer learn how to distinguish cat photos from non-cat photos?

While the Neural Network had a **Train Accuracy** of 0.986 and a **Test Accuracy** of 0.8, this does not the trained network will make perfect perfect predictions.

Especially the test accuracy is very high high that means that the Neural Network most overfit to the Training Set (i.e., learns it too well), which compromises accuracy for the Test Set.

Most likely a regularization technique would have prevented some overfitting and adding training data would be another way.

In the meantime, I have to live with the fact that my computer thinks I am a cat.

<img src="https://raw.githubusercontent.com/ChristianHallerX/Deeplearning.ai/master/1%20Neural%20Networks%20and%20Deep%20Learning/Week%204/Deep%20Neural%20Network%20Application%20Image%20Classification/images/my_image.jpg" alt="Cat" style="width:500px">

You are invited to download the Jupyter Notebook and run it with you own photo. Let me know what happens.

## GitHub

<a href="https://github.com/ChristianHallerX/Deeplearning.ai/blob/master/1%20Neural%20Networks%20and%20Deep%20Learning/Week%204/Deep%20Neural%20Network%20Application%20Image%20Classification/Deep%2BNeural%2BNetwork%2B-%2BApplication%2Bv8.ipynb" target="_blank">Jupyter Notebook</a>
