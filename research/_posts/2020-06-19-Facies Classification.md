---
title: Machine Learning - Facies Classification with Boosted Trees
image: /assets/img/research/Bonneville/Bonneville_Article_Cover.png
description: >
  Let the computer describe the rock
---

**Structured data classification** is one of the important and typical task in supervised machine learning (ML). Assigning categories to structured data, which can be anything stored in a spereadsheet, relational database content (SQL). For example names, dates, addresses, credit card numbers, stock information, geolocation, etc. In this article, I would like to demonstrate how we can do data classification using Python, XGBoost, and a little bit of Scikit-learn.

In the last couple of years it has become more and more common for data scientists and geoscientists to make use of **open source software** and open source data alike. Even Microsoft now believes that open source is <a href="https://www.theverge.com/2020/5/18/21262103/microsoft-open-source-linux-history-wrong-statement" target="_blank">the future</a>. This way users have shared and standardized data sets to work with - no legal or licnsing restrictions apply. Resulting from this democratizaton movement, we have seen Machine Learning competitions on <a href="https://www.kaggle.com/" target="_blank">Kaggle</a> , or  <a href="https://xeek.ai/" target="_blank">Xeek</a>.

The Society of Exploration Geophysicists (SEG), Matt Hall (Agile), and Brendon Hall (Enthought) ran in 2016 a **competition** on who can create the best Machine Learning model in classifying sedimentary facies in several wells using wireline measurements. For the dataset provided, a **subject-matter expert** (e.g., sedimentologist) manually described core sections and gave the facies names, which is calles labeling. This complete dataset can be used to train a Machine Learning Model. Note that in Artificial Intelligence rules are not hard-coded as in traditional programming, rather we give the computer the inputs and outputs, and the let it figure out the rules. These rules can then be used to make predictions on new, unseen, data. In this case we can then use new wireline data to predict sedimentological facies.

The dataset, along with instructions were made available online in an article in SEG The Leading Edge <a href="https://library.seg.org/doi/10.1190/tle35100906.1" target="_blank">"Facies classification using machine learning"</a>. The article included a link to <a href="https://github.com/seg/2016-ml-contest/blob/master/Facies_classification.ipynb" target="_blank">some starter code in a Jupyter notebook</a> with a simple Support Vector Machine model that had to be surpassed in accuracy.

In 2017, the results of the SEG competition were published in the <a href="https://doi.org/10.1190/tle36030267.1" target="_blank">SEG Leading Edge journal</a> including <a href="https://github.com/seg/2016-ml-contest" target="_blank">all submission files</a> for contestants to learn from each other. Teams were allowed to send new and improved models

**The goal of this discussion** is working through what a good submission did to improve on the starter code, but does not necessarily have to be the winning submission. In this case, I want to discuss the HouMath team's last submission and add my annotation and own modifications to the code. Of course, this Facies Classification project is at the core not much different from any other Data Science or Machine learning structure.

Utilizing over 4000 training samples (downhole readings) based on 7 features (predictor variables) from wireline logs in ten wells and over 800 test data in two wells to predict 9 different facies classes from a carbonate gas reservoir, the classifier algorithm resulted in F1 score of 0.630! This was in the contest a good result in the top group.

Let’s divide the classification problem into below steps:

1. Prerequisite and setting up the environment
2. Loading the data set in Jupyter
3. Extracting features from text files
4. Running ML algorithms
5. Grid Search for parameter tuning
6. Useful tips and a touch of XGBoost


## Step 1: Prerequisite and setting up the environment

The prerequisites to follow this example are python version 2.7 and Jupyter notebook. You can just install <a href="https://www.anaconda.com/" target="_blank">Anaconda</a> and it will get everything for you. Also, little bit of Python and ML basics including data classification is required. We will be using XGBoost and Scikit-learn (Python) libraries for our example.

<img src="/assets/img/research/SEG/1.png" alt="AnacondaNavigatorHomescreen" style="width:640px"><br>

Having installed Anaconda, you open the Anaconda Navigator and land on the Home screen. There, click the Install button for JupyterLab to make it accessible in future. Next, update all the libraries includied. Click on the Anaconda home screen on "CMD.exe Prompt" and enter 'conda update --all'. This will online-update all the pre-installed libraries. When asked, reply with 'y' for yes to execute the updates.


## Step 2: Loading the data set in Jupyter.

The SEG data set "1610_Facies_classification" mentioned above is hosted on GitHub: <a href="https://github.com/seg/tutorials-2016/" target="_blank">https://github.com/seg/tutorials-2016/</a>

<img src="/assets/img/research/SEG/2.png" alt="Forking" style="width:640px"><br>

To obtain the data choose one of  the two ways:

- fork (clone) the repository to your own GitHub account which makes it possible to mirror your account's content on your local file system. Remember, that all GitHub files in your own account should be free to use for anyone in the world, since anyone can see and copy them.

<img src="/assets/img/research/SEG/3.png" alt="Forking" style="width:640px"><br>

- download the repository as a zip to your computer. Then unzip the folder.

<img src="/assets/img/research/SEG/4.png" alt="DownloadUnzip" style="width:640px"><br>

I suggest building up from the tutorial file that calls a few custom-coded libraries for graphing and explains the structure of the data provided. Open JupyterLab, and navigate to the unzipped folder and double click "Facies Classification - SVM.ipynb".


## Step 3: Exploring features from provided csv files.


## Step 4: Running ML algorithms


## Step 5: Grid Search for parameter tuning

<img src="/assets/img/research/SEG/Stuart_yhat.png" alt="Stuart_yhat" style="width:640px"><br>

## Step 6: Useful tips and a touch of XGBoost


## Acknowledgements:
Thanks to Matt Hall (Agile) and Brendon Hall (Enthought) for organizing the SEG Machine Learning challenge.  And the HouMath team for their contribution.

## References 
Hall, B. (2016). Facies classification using machine learning. The Leading Edge, 35(10), 906-909.  
Friedman, J. H. (2000) Greedy function approximation: A gradient boosting machine: Annals of Statistics, 29, 1189–1232. 