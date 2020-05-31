#' Transform text with non-text characters to 'clean' text
#'
#' Remove non-text characters. Numbers are also removed.
#'
#' @param x Text to clean (character).
#'
#' @return Cleaned text (character)
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
            stringi::stri_remove_empty_na() # Remove empty lines
      return(text)
}

#' Count words in cleaned character vector.
#'
#' @param text Previously cleaned text (with \code{enscnt::clean_text()})
#'             (character vector)
#' @return Number of words (integer)
#' @importFrom stringi stri_stats_latex
#' @export
word_count <- function(text) {
      i <- sapply(text, stringi::stri_stats_latex, USE.NAMES = FALSE)
      res <- i["Words", ]
      names(res) <- NULL
      return(res)
}

#' Create a dataframe of n-grams, and their frequency and proportion.
#'
#' Generate a dataframe of n-grams, and their frequency and proportion
#' Apply on 'cleaned' text only.
#'
#' @inheritParams word_count
#' @param n value of 'n' in n-gram (integer)
#' @return dataframe of n-grams (dataframe)
#' @importFrom ngram ngram
#' @importFrom ngram get.phrasetable
#' @export
ngrams_table <- function(text, n = 2) {
      i <- (word_count(text) >= n)
      text <- text[i == TRUE]
      ngram_table <- text %>% ngram::ngram(n) %>%
         ngram::get.phrasetable()
      ngram_table$ngrams <- trimws(ngram_table$ngrams)
      return(ngram_table)
}

#' Sample "aFraction" of cleaned text.
#'
#' Sample "aFraction" of cleaned text.
#' Apply on 'cleaned' text only.
#'
#' @inheritParams word_count
#' @param aFraction Fraction of lines in text to be used \code{0 < aFraction < 1} (numeric)
#' @return Cleaned text (character vector)
#' @importFrom stats rbinom
#' @export
sampleNlines <- function (text, aFraction = 0.1) {
      nrLines <- length(text)
      i <- stats::rbinom(n = nrLines,
                         size = 1,
                         prob = aFraction)
      return(text[i == 1])
}

#' Plot n-gram (output from \code{ngram::ngram})
#'
#' @inheritParams ngrams_table
#' @param ngr ngram (output from \code{ngram::ngram})
#' @param title Plot title (character)
#' @param m most frequent ngrams (integer)
#' @return (-) Only side-effect is produces (a plot)
#' @importFrom graphics barplot
#' @export
plot_ngrams <- function(ngr,
                        title = "",
                        n = 2,
                        m = 5) {
      if (title == "") {
            title <- paste0("Most Frequent ", toString(n), "-gram")
      }

      barplot(
            ngr$freq[1:m],
            names.arg = ngr$ngrams[1:m],
            main = title,
            ylab = "Frequency"
      )
}
