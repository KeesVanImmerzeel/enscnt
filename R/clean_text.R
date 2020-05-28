#' Transform text with non-text characters to 'clean' text
#'
#' Remove non-text characters. Numbers are also removed.
#'
#' @param x (character) Text to clean.
#'
#' @return (character) Cleaned text.
#'
#' @importFrom textclean replace_word_elongation
#' @importFrom magrittr %>%
#' @importFrom stringi stri_remove_empty
#'
#' @export
clean_text <- function(x) {
      text <- x %>%
            textclean::replace_word_elongation() %>% # Replace elongation words
            gsub("[^A-Za-z ]", "", .) %>% # Remove all characters that are not letters or space.
            gsub("\\s+", " ", .) %>% # Remove multiple white spaces
            trimws() %>% # Trim trailing and leading white space
            tolower() %>%  # Convert to lowercase
            stringi::stri_remove_empty() # Remove empty lines
      return(text)
}


