<style>
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
}

.small-code pre code {
  font-size: 1em;
}

.footer {
    color: black; background: #E8E8E8;
    position: fixed; top: 90%;
    text-align:center; width:100%;
}

.midcenter {
    position: fixed;
    top: 50%;
    left: 50%;
    width: 400px;
    height: 400px;
}

.footer {
    color: black; background: #E8E8E8;
    position: fixed; top: 50%;
    text-align:left; width:100%;
}
</style>

Predicting Closure of Businesses Based on Rating Behaviour
===
author: Jesus Ramos
date: November 22 2015
<div class="midcenter" style="background-color:transparent; border:0px; box-shadow:none; margin-left:-475px; margin-top:100px;">
<img src="http://vignette2.wikia.nocookie.net/fleck/images/c/c8/Yelp_Logo.png/revision/latest?cb=20110828035920"></img>
</div>

Motivation & Business Question
===
1. <small>Knowing how your business is rated in Yelp as an aggregate is interesting, but unactionable.</small>
2. <small>Going deeper into how ratings and their stars behave through time can grant insights as to the moments when customer care and attention is more important.</small>
3. <small>Failing to preemptively pamper your customers at the right moment in time may create an effect that will ultimately reduce the profitability of the business.</small>
4. <small>Since **service is discrete, but perception of service is continuous**, bad service will have a lasting effect.</small>
5. <small>If accumulated, this effect will be enough to force the shutdown of the business.</small>

### Question
> <small>Can user ratings be used to predict business closure?</small>

Methodology
===
class: small-code
1. <small>Load data from [Yelp](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/yelp_dataset_challenge_academic_dataset.zip) and test if the mean stars for closed business is significantly different from the mean stars for those still alive.</small>
2. <small>Convert ratings from repeated observations in time, to a yearly accumulated per business.</small>
2. <small>Calculate year-to-year changes in rating counts and number of stars.</small>
3. <small>Predict the closure of a business with a statistical learning algorithm.</small>

### Sample of final data

```
  review_count_change_year review_stars_change_year
1                       NA                       NA
2                        0                       -3
3                        2                        2
```

<small>Note we'll only consider **changes** in review counts and stars.</small>

Random Forest Performance
===
class: small-code
<small>The model does a decent job predicting the businesses that will remain open, but a poor job predicting those that have closed, as shown by the confusion matrix for the test set:</small>

```
          Reference
Prediction FALSE  TRUE
     FALSE     1     0
     TRUE   2226 16008
```
<small>Also, the ROC curve shows how poorly specific and sensitive the model is, with an accuracy of 87% and a specificity of 0%.</small>
<img src="dsscapstone-figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

```

Call:
plot.roc.default(x = rfModel$pred$obs[selectedIndices], predictor = rfModel$pred$mtry[selectedIndices])

Data: rfModel$pred$mtry[selectedIndices] in 5198 controls (rfModel$pred$obs[selectedIndices] FALSE) < 37352 cases (rfModel$pred$obs[selectedIndices] TRUE).
Area under the curve: 0.5
```

Results and Conclusion
===
1. <small>The developed model is subpar. This may be due to our heavy treatment to transform review data into discrete yearly observations.</small>
2. <small>The former implies that for businesses that opened in 2008 but received their first review in 2013, the model will have 0s for the first 5 years of operations. These 0s affect the model's performance.</small> 
3. <small>It could also mean that ratings are not a good predictor for a going concern, and that more direct activity indicators, like check-ins, are better suited.</small>
4. <small>Lessons concerning the overuse (and overkill) of machine learning algorithms are clear with these examples.</small>
5. <small>Lessons concerning the long, heavy process of cleaning and processing data are also confirmed, since the bulk of the code for this study is to achieve a data format processable by the chosen algorithm.</small>
