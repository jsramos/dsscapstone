# Libraries
library(readr)
library(jsonlite)
library(doParallel)
library(data.table)
library(plyr)
library(dplyr)

# Read-in data. Make sure you've downloaded it from
# https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/yelp_dataset_challenge_academic_dataset.zip
# Register cores for parallel processing
registerDoParallel(cores=2)
# File prefixes
filePrefix <- './yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_'
# File suffixes
sets <- c('business','checkin','review','tip','user')
# Build filenames
filenames <- paste(filePrefix, sets, '.json', sep = '')
# Read businesses
bizstrings <- read_lines(filenames[1])
# Read checkin
checkinstrings <- read_lines(filenames[2])
# Read reviews
reviewstrings <- read_lines(filenames[3])
# Read tips
tipstrings <- read_lines(filenames[4])
# Read users
userstrings <- read_lines(filenames[5])

# Transform all datasets
# At this stage we only have an array of strings instead of a JSON array.
# To transform a character array to a JSON array, we need to
# 1. concatenate all elements in the char array separated by a comma
# 2. enclose everything in square brackets [] so that JSON converters know this is an anonymous array.

# Transform biz dataset
bizdata <- fromJSON(sprintf("[%s]", paste(bizstrings, collapse = ',')), # separates array, insert commas and put everything in []
              flatten = T, 
              simplifyVector = T,
              simplifyDataFrame = T)

# Remove whitespaces from column names
# Replace . with _
names(bizdata) <- gsub(' ', '', gsub('\\.', '_', names(bizdata), perl=T), perl=T)

# Transform attributes.Accepts Credit Cards from logical list with NULLs to a logical with NAs.
mutate(bizdata, 
       attributes.AcceptsCreditCards = 
           as.logical(as.character(attributes.AcceptsCreditCards)))

# Transform biz dataset
checkindata <- fromJSON(sprintf("[%s]", paste(checkinstrings, collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)

# Transform biz dataset
reviewdata <- fromJSON(sprintf("[%s]", paste(reviewstrings, collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)

# Transform biz dataset
tipdata <- fromJSON(sprintf("[%s]", paste(tipstrings, collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)

# Transform biz dataset
userdata <- fromJSON(sprintf("[%s]", paste(userstrings, collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)



# Save the businesses JSON strings as an RDS file
saveRDS(bizdata, file=paste(sets[1], 'data.RDS', sep=''))
# Save the check-in JSON strings as an RDS file
saveRDS(checkindata, file=paste(sets[2], 'data.RDS', sep=''))
# Save the review JSON strings as an RDS file
saveRDS(reviewdata, file=paste(sets[3], 'data.RDS', sep=''))
# Save the tips JSON strings as an RDS file
saveRDS(tipdata, file=paste(sets[4], 'data.RDS', sep=''))
# Save the businesses JSON strings as an RDS file
saveRDS(userdata, file=paste(sets[5], 'data.RDS', sep=''))
