library(magrittr)
library(enscnt)

## Prepare cleaned dataset `sentences`
en_ne_sentences <- readLines("data-raw/en_ne.txt", warn = FALSE) %>% clean_text(.)

usethis::use_data(en_ne_sentences, overwrite = TRUE)
