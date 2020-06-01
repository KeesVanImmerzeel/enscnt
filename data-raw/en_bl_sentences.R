library(magrittr)
library(enscnt)

## Prepare cleaned dataset `sentences`
en_bl_sentences <- readLines("data-raw/en_bl.txt", warn = FALSE) %>% clean_text(.)

usethis::use_data(en_bl_sentences, overwrite = TRUE)
