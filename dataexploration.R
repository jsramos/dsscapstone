# Clean environment
rm(list = ls())

# Libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)

# Read-in binary data
bizdata <- readRDS("./businessdata.RDS")
reviewdata <- readRDS("./reviewdata.RDS")

# Make sure there are no 0s in 'open' variable
sum(is.na(bizdata$open))

# Mean stars for open and closed business
open <- filter(bizdata, open == T)$stars
closed <- filter(bizdata, open == F)$stars

# Exploring the distribution of star ratings for business by var 'open'
m <- ggplot(bizdata, aes(x = stars, fill = open)) + 
        geom_histogram(aes(y = ..density..), binwidth = 0.5, alpha = 0.5) +
        geom_vline(color = '#F8766D', xintercept = mean(closed), 
                   linetype = 'longdash', size = 1) +
        geom_vline(color = '#00BFC4', xintercept = mean(open), 
                   linetype = 'longdash', size = 1) +
        labs(title = 'Distributions and means for open and closed businesses')
m

# Welch T test for stars for open and closed businesses
hyptest <- t.test(open, closed, var.equal = F)

# p-value of the test
hyptest$p.value

# Confidence interval of the test
hyptest$conf.int

# We have asserted that the mean rating for currently active businesses is
# different from those that have shutdown
# Now we'll build a dataframe with only the data we're interested in.
finalbizdata <- select(bizdata, business_id, open, state, categories)

# Create a column with year of review only and fix types for other columns.
reviewdata <- mutate(reviewdata, year = year(date))
reviewdata <- mutate(reviewdata, stars = as.numeric(stars))


# Create an identifier that is local to the business_id, 
# but sequential to the year.
reviewdata <- reviewdata %>% group_by(business_id) %>% 
        mutate(year_seq = dense_rank(year))

# Drop columns not related to the business.
reviewdata <- select(reviewdata, c(-user_id, -review_id, -votes_funny, 
                                   -votes_useful, -votes_cool))

# Create column with review count by year for each business.
reviewdata <- mutate(reviewdata, review_count_year = 
                             as.numeric(ave(business_id, year, 
                                            business_id, FUN = length)))

# Create column with mean stars per year for each business.
reviewdata <- mutate(reviewdata, review_stars_year = 
                           round(ave(stars, business_id, year, FUN = mean), 2))

# We can now remove 'stars' and 'date' column because we've sampled the data
# down to yearly observations, regardless of the actual year in the review
# date.
finalreviewdata <- reviewdata %>% 
        group_by(business_id, year, year_seq) %>%
        filter(row_number() == 1)

# We ungroup the set and remove year, since we're already accounting for it
# with 'year_seq'.
finalreviewdata <- finalreviewdata %>% ungroup() %>% select(-year)

# We regroup based on 'business_id' in order to calculate the change with lag
# for stars and review count.
change <- function(x) {x - lag(x)}
finalreviewdata <- finalreviewdata %>% group_by(business_id) %>% 
        mutate_each(funs(change), 
                    c(review_count_change_year = review_count_year, 
                      review_stars_change_year = review_stars_year))

# We now transform the data in wide format.
finalreviewdata <- finalreviewdata %>% 
        gather(type, value, starts_with("review")) %>% 
        unite(type_year, type, year_seq, sep = "") %>% 
        spread(type_year, value, drop = F, fill = 0)

# And joint it with finalbizdata.
# There are 61184 observations on businesses, but ratings for only 60785 of
# them, so there are 399 that are unaccounted for.
# So as not to obtain spurious predictions, these 399 records will be removed
# from the main dataset and will not feature again in the study.
finalbizdata <- inner_join(finalbizdata, finalreviewdata, by = c('business_id' = 'business_id'))

# Save RDS
saveRDS(finalbizdata, 'processeddata.RDS')