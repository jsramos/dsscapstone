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
# Save the businesses JSON strings as an RDS file
saveRDS(rawstrings[[1]], file=paste(sets[1], 'strings.RDS', sep=''))
# Save the check-in JSON strings as an RDS file
saveRDS(rawstrings[[2]], file=paste(sets[2], 'strings.RDS', sep=''))
# Save the review JSON strings as an RDS file
saveRDS(rawstrings[[3]], file=paste(sets[3], 'strings.RDS', sep=''))
# Save the tips JSON strings as an RDS file
saveRDS(rawstrings[[4]], file=paste(sets[4], 'strings.RDS', sep=''))
# Save the businesses JSON strings as an RDS file
saveRDS(rawstrings[[5]], file=paste(sets[5], 'strings.RDS', sep=''))
# Load this RDS to remove dependency on physical files being present
bizstrings <- readRDS('./businessstrings.RDS')
# See if they are identical
if (!identical(rawstrings[[1]], bizstrings)) {
     stop('Error loading RDS.')   
}

# Transform business dataset
# See http://mkseo.pe.kr/stats/?p=898
# bizdata <- sapply(rawstrings[[1]], function(x) {fromJSON(x)})

