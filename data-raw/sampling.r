library(magrittr)
# Prepare a datasets with randomly selected Englisch sentences:
# 'data-raw/en.txt' from twitter, blogs and newspapers;
# 'data-raw/en_tw.txt' from twitter;
# 'data-raw/en_bl.txt' from blogs;
# 'data-raw/en_ne.txt' from newspapers;

# Data is used from the following source:
# https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
# Not all lines ar used in the package since it is too large (>100 MB).
# So, before running this code, make sure the source files (en_US.*) as specified below
# are present. After running the code, remove these files!

#' Write randomly selected lines
#'
#' @param text Text lines to select from (character vector)
#' @param filename Filename of text file to write selected lines to (character)
#' @param perc Fraction of lines to read. 0 < perc <= 1 (numeric)
#' @return (-) Only side effect (file is written)
write_randomly_selected_lines <- function(text, filename, perc = .25) {
      i <- rbinom(n = length(text),
                  size = 1,
                  prob = perc)
      text <- text[i == 1]

      con <- file(filename, open = "wt")
      writeLines(text, con)
      close(con)
}

# Read source files.
tw <- readLines("data-raw/en_US.twitter.txt", warn = FALSE)
bl <-  readLines("data-raw/en_US.blogs.txt", warn = FALSE)
ne <- readLines("data-raw/en_US.news.txt", warn = FALSE)

# Create output files
append(tw, bl) %>% append(., ne) %>% write_randomly_selected_lines("data-raw/en.txt", .25)
tw %>% write_randomly_selected_lines("data-raw/en_tw.txt", .5)
bl %>% write_randomly_selected_lines("data-raw/en_bl.txt", .4)
ne %>% write_randomly_selected_lines("data-raw/en_ne.txt", 1)
