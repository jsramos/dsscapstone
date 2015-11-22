# Clean environment
rm(list = ls())

# Libraries
library(readr)
library(jsonlite)
library(doParallel)
library(plyr)
library(dplyr)

# Read-in data. Make sure you've downloaded it from
# https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/yelp_dataset_challenge_academic_dataset.zip
# Register cores for parallel processing
registerDoParallel(cores=3)
# File prefixes
filePrefix <- './yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_'
# File suffixes
sets <- c('business','checkin','review','tip','user')
# Build filenames
filenames <- paste(filePrefix, sets, '.json', sep = '')

# Transform all datasets
# At this stage we only have an array of strings instead of a JSON array.
# To transform a character array to a JSON array, we need to
# 1. concatenate all elements in the char array separated by a comma
# 2. enclose everything in square brackets [] so that JSON converters know this is an anonymous array.

# Transform biz dataset
bizdata <- fromJSON(sprintf("[%s]", paste(read_lines(filenames[1]), collapse = ',')), # separates array, insert commas and put everything in []
              flatten = T, 
              simplifyVector = T,
              simplifyDataFrame = T)

# Remove whitespaces from column names
# Replace . with _
names(bizdata) <- gsub(' ', '', gsub('\\.', '_', gsub('-', '_', names(bizdata), perl=T), perl=T), perl=T)

# Transform attributes.Accepts Credit Cards from logical list with NULLs to a logical with NAs.
bizdata <- mutate(bizdata, 
       attributes_AcceptsCreditCards = 
           as.logical(as.character(attributes_AcceptsCreditCards)))

# Remove 'full_address' and 'neighborhoods' columns because we already have latitude, longitude, city and state. 
bizdata <- select(bizdata, c(-full_address, -neighborhoods, -type))

# We will not use check-in data because it is of no interest to our research
checkindata <- fromJSON(sprintf("[%s]", paste(read_lines(filenames[2]), collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)
# Remove whitespaces from column names
# Replace . with _
names(checkindata) <- gsub(' ', '', gsub('\\.', '_', gsub('-', '_', names(checkindata), perl=T), perl=T), perl=T)

# Remove 'type' because it doesn't add to the variance
checkindata <- select(checkindata, c(-type))

# Transform review dataset
reviewdata <- fromJSON(sprintf("[%s]", paste(read_lines(filenames[3]), collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)
# Remove whitespaces from column names
# Replace . with _
names(reviewdata) <- gsub(' ', '', gsub('\\.', '_', gsub('-', '_', names(reviewdata), perl=T), perl=T), perl=T)

# We will remove 'type' column because it doesn't have variance, and the 'text' column because
# we will not perform any sort of text mining or text-based sentiment analysis
reviewdata <- select(reviewdata, c(-type, -text))

# Transform date variable from character to date
reviewdata <- mutate(reviewdata, date=as.POSIXct(date))

# We will not load or transform the tip dataset because we deem it of no interest to our research
#tipdata <- fromJSON(sprintf("[%s]", paste(tipstrings, collapse = ',')), # separates array, insert commas and put everything in []
#                    flatten = T, 
#                    simplifyVector = T,
#                    simplifyDataFrame = T)
# Remove whitespaces from column names
# Replace . with _
#names(tipdata) <- gsub(' ', '', gsub('\\.', '_', gsub('-', '_', names(tipdata), perl=T), perl=T), perl=T)

# Remove type column because it doesn't add to the variance, and 'text' because we will not be doing
# sentiment analysis or text mining
#tipdata <- select(tipdata, c(-type, -text))

# Transform date variable from character to date
#tipdata <- mutate(tipdata, date=as.POSIXct(date))

# Transform user dataset
usrdata <- fromJSON(sprintf("[%s]", paste(read_lines(filenames[5]), collapse = ',')), # separates array, insert commas and put everything in []
                    flatten = T, 
                    simplifyVector = T,
                    simplifyDataFrame = T)
# Remove whitespaces from column names
# Replace . with _
names(usrdata) <- gsub(' ', '', gsub('\\.', '_', gsub('-', '_', names(usrdata), perl=T), perl=T), perl=T)

# Remove 'elite' column because 1) we don't have a way to relate the elite status to number of reviews given,
# fans, friends or specific weight in network, and 2) since we're aiming to model change in ratings as
# stock returns, assigning a preference to a market participant (user) introduces inefficiencies in our
# rudimentary valuation model
usrdata <- select(usrdata, c(-elite, -type))

# Adding 01 to parse the 'yelping_since' column as Date
usrdata <- mutate(usrdata, yelping_since=as.POSIXct(paste(yelping_since, '-01', sep = '')))

# Save the businesses JSON strings as an RDS file
saveRDS(bizdata, file=paste(sets[1], 'data.RDS', sep=''))
# Save the check-in JSON strings as an RDS file
saveRDS(checkindata, file=paste(sets[2], 'data.RDS', sep=''))
# Save the review JSON strings as an RDS file
saveRDS(reviewdata, file=paste(sets[3], 'data.RDS', sep=''))
# Save the tips JSON strings as an RDS file
#saveRDS(tipdata, file=paste(sets[4], 'data.RDS', sep=''))
# Save the businesses JSON strings as an RDS file
saveRDS(usrdata, file=paste(sets[5], 'data.RDS', sep=''))
