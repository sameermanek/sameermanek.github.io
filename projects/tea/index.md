---
title: Tea Recommendations
layout: project
---
As part of a class project, I built a tea recommender. The basic goal of this is to allow users/consumers to discover new teas without being locked in to a single brand or store. Imagine [teabox](http://teabox.com) that works across a whole bunch of tea vendors -- local B&M, online, etc. 

While this tea recommender doesn't learn, it uses tf-idf to vectorize tasting notes, cosine similarity scores to find similar and different teas, and finally a basic aggregation algorithm to find the best tea for any tea lover. 

Type in a few teas you like or dislike and get ready to be amazed. 

<iframe id="shinyframe" width="100%" height="1200px" frameborder="0" src="https://sameermanek.shinyapps.io/TeaRecommender/"></iframe>

