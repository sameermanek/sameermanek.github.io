---
title: Random Correlations
layout: project
---
I've noticed that people frequently misusing data to find correlations between seemingly unrelated data sets and inferring a relationship. While they'll generally volunteer that they haven't proven causality, they frequently claim that there *must be* some relationship for the p value to be so low. 

I built a toy to try and show the error in this. Essentially, you can take almost any real life data and infer a relationship. Here I took a number of data sets from [Quandl](quandl.com) to show that there are relationships with very low p-values just by chance.

Wait for it to load, then hit the "Another Relationship!" button

<iframe width="760" height="1200" frameborder="0" src="https://sameermanek.shinyapps.io/Correlations/"></iframe>
 
The causes of these 'relationships' vary, but a few key factors that I think are generally worth checking. These don't invalidate the slope or intercept, but they may call the test statistics into question (e.g., p value). 

* Are the errors normally distributed?
* What if I detrend the data?
* Are the errors autocorrelated?
* Do the errors have constant variance?
* Are there any points with a lot of leverage?
* How many relationships did I test before finding this? Do I need to apply a multiple testing correction?