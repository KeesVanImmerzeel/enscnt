library(magrittr)
library(enscnt)

## Prepare cleaned dataset `sentences`
en_tw_sentences <- readLines("data-raw/en_tw.txt", warn = FALSE) %>% clean_text(.)

usethis::use_data(en_tw_sentences, overwrite = TRUE)
