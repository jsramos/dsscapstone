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
# Read them all in one go
rawstrings <- llply(as.list(filenames), function(x) {read_lines(x)})
# Save this file as an RDS
saveRDS(rawstrings, file='rawstrings.RDS')
# Load this RDS to remove dependency on physical files being present
newstrings <- readRDS('./rawstrings.RDS')
# See if they are identical
if (!identical(rawstrings, newstrings)) {
     stop('Error loading RDS.')   
}

# Transform business dataset
# See http://mkseo.pe.kr/stats/?p=898
# bizdata <- sapply(rawstrings[[1]], function(x) {fromJSON(x)})

