# Libraries
library(readr)
library(jsonlite)
library(doParallel)
library(data.table)
library(plyr)
library(dplyr)

# Read-in data
# Register cores
registerDoParallel(cores=2)
# File prefixes
filePrefix <- './yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_'
# File suffixes
sets <- c('business','checkin','review','tip','user')
# Build filenames
filenames <- paste(filePrefix, sets, '.json', sep = '')
# Read them all in one go
rawstrings <- llply(as.list(filenames), function(x) {read_lines(x)})

# Transform business dataset
# See http://mkseo.pe.kr/stats/?p=898
bizdata <- sapply(rawstrings[[1]], function(x) {fromJSON(x)})

