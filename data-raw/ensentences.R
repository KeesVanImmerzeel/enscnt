library(magrittr)
library(enscnt)

## Prepare cleaned dataset `sentences`
sentences <- readLines("data-raw/en.txt", warn = FALSE) %>% clean_text(.)

usethis::use_data(sentences, overwrite = TRUE)
