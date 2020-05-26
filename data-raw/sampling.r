library(magrittr)
# Prepare a dataset 'data-raw/en.txt' of Englisch sentences drawn from twitter, blogs and newspapers.

# Data is used from the following source
# But actually not included in the package since it is too large.
# https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
# So, before running this code, make sure the following files are present
# in the folder data-raw.
tw <- readLines("data-raw/en_US.twitter.txt", warn = FALSE)
bl <-  readLines("data-raw/en_US.blogs.txt", warn = FALSE)
ne <- readLines("data-raw/en_US.news.txt", warn = FALSE)
sentences <- append(tw,bl) %>% append(.,ne)

# Select 25% of the lines and write the selecte lines to 'data-raw/en.txt'.
i <- rbinom(n = length(sentences),
            size = 1,
            prob = .25)
sentences <- sentences[i == 1]

con <- file("data-raw/en.txt", open="wt")
writeLines(sentences, con)
close(con)
