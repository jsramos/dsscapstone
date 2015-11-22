<style>
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
}

.small-code pre code {
  font-size: 15px;
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
transition: rotate
<div class="midcenter" style="background-color:transparent; border:0px; box-shadow:none; margin-left:-475px; margin-top:100px;">
<img src="http://vignette2.wikia.nocookie.net/fleck/images/c/c8/Yelp_Logo.png/revision/latest?cb=20110828035920"></img>
</div>

Motivation & Business Question
===
1. Knowing how your business is rated in Yelp as an aggregate is interesting, but unactionable.
2. Going deeper into how ratings and their stars behave through time can grant insights as to the moments when customer care and attention is more important.
3. Failing to preemptively pamper your customers at the right moment in time may create an effect that will ultimately reduce the profitability of the business.
4. Since 'service is discrete, but perception of service is continuous', bad service will have a lasting effect.
5. If accumulated, this effect will be enough to force the shutdown of the business.

## Question
> Can user ratings be used to predict business closure?

Methodology
===
1. Load data from [Yelp](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/yelp_dataset_challenge_academic_dataset.zip) and test if the mean stars for closed business is significantly different from the mean stars for those still alive.
2. Convert ratings from repeated observations in time, to a yearly accumulated per business.
2. Calculate year-to-year changes in rating counts and number of stars.
3. Predict the closure of a business with a statistical learning algorithm.

Results & Conclusion 
===
left: 60%
class: small-code
Siviri
<img src="dsscapstone-figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto;" />
***
<font size="5">We can see from the plot that...</font>

Random Forest
===
