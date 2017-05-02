---
title: "Problem Statement"
---

## 7 Years Worth of Data
Following the Deepwater Horizon Oil Spill of 2010, researchers at the Scripps Institute of Oceanography decided to deploy a detector which recorded ocean sounds. It was left in the area for 7 years and has since collected a significant amount of acoustic data. Much of this data is comprised of fish calls.

## What Do We Do With These Fish Calls?
Of the 7 years of acoustic data, researchers have been able to successfully anotate 2 years worth, classifying recurring acoustic patterns by the fish species that are believed to have produced them. This however, is not an efficient process and even if researchers were to successfully parse all of the data, the question remains: What should be done with all of this information? 

## The Solution: Convolutional Neural Networks
By taking the 2 years of annotated data and feeding it into a custom Convolutional Neural Network as training data, the remaining data can be systematically organized and classified. Further, by developing a detector in parallel, the Neural Network can be used as a research tool for the long-term surveilance of sea-life populations.

## Project Deliverables
1. An Automated Detector - that takes in acoustic data and outputs the time of signal occurence. An ideal implementation would require an efficient means of processing large amounts of data.

2. A User Friendly Interface - a means of interfacing between detector and classifier. Additionally, a graphical executable that will allow researchers without a deep knowledge of MATLAB to use the tool

3. The Classifier - a Convolutional Neural Network designed to classify fish species by the noises they produce. Continued development necessitates improved accuracy and runtime. Dr. Sirovic has also shown interest in generalizing the CNN as a tool for signal and acoustic classification.