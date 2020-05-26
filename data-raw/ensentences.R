library(magrittr)
library(enscnt)

## Prepare cleaned dataset `sentences`
ensentences <- readLines("data-raw/en.txt", warn = FALSE) %>% clean_text(.)

usethis::use_data(ensentences, overwrite = TRUE)
