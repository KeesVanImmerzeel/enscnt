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
#' @param ng value of 'n' in n-gram (integer)
#' @return dataframe of n-grams (dataframe)
#' @importFrom ngram ngram
#' @importFrom ngram get.phrasetable
#' @examples
#' ngrams_table(en_ne_sentences[1:10])
#' @export
ngrams_table <- function(text, ng = 2) {
      i <- (word_count(text) >= ng)
      text <- text[i == TRUE]
      ngram_table <- text %>% ngram::ngram(ng) %>%
         ngram::get.phrasetable()
      ngram_table$ngrams <- trimws(ngram_table$ngrams)
      ngram_table$ng <- ng
      return(ngram_table)
}

#' Create a list of all n-gram tables 1..ng (wih their frequency and proportion).
#'
#' @inheritParams ngrams_table
#' @param x list of all n-gram tables (data frames)
#' @examples
#' nGF <- ngrams_tables(en_bl_sentences[1:100], ng=4)
#' @export
ngrams_tables <-
   function(text,
            ng = 3,
            x = NULL) {
      if (ng == 0) {
         return(x)
      }
      else {
         x <-
            do.call("rbind",
                    list(ngrams_table(text, ng),
                         ngrams_tables(text, ng - 1, x)))
         return(x)
      }
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
#' @examples
#' plot_ngrams(ngrams_table(en_ne_sentences[1:10]))
#' @export
plot_ngrams <- function(ngr,
                        title = "",
                        ng = 2,
                        m = 5) {
      if (title == "") {
            title <- paste0("Most Frequent ", toString(ng), "-gram")
      }
      graphics::barplot(
            ngr$freq[1:m],
            names.arg = ngr$ngrams[1:m],
            main = title,
            ylab = "Frequency"
      )
}

RemoveFirstWord <- function(txt) {
   txt %<>% trimws(.)
   if (stringi::stri_count(txt, regex = "\\p{L}+") > 1) {
      #Only one word
      i <- unlist(gregexpr(pattern = ' ', txt))[1]
      substr(txt, i + 1, nchar(txt))
   } else
      return("")
}

#' Estimate the probabilities of observed and unobserved n-grams that start with prefix "pfx".
#'
#' It accomplishes this estimation by backing off through progressively shorter history models
#' under certain conditions. Reference: \href{https://en.wikipedia.org/wiki/Katz%27s_back-off_model}{Katz's back-off model}.
#'
#'By doing so, the model with the most reliable information about a given history is used
#'to provide the better results in predicting the next word.
#' @param pfx prefix ('cleaned' text only, character)
#' @param nGF List of all n-gram tables 1..ng wih their frequency and proportion
#'            as created by the function ngrams_tables (list)
#' @param discnt Discount factor 0 < discnt < 1 (numeric)
#' @return data.frame of 6 variables:
#'   ngrams: unique n-grams (character)
#'   freq: frequency of n-grams (integer)
#'   prop: proportion of n-grams (numeric)
#'   ng: value of 'n' in n-gram (integer)
#'   prob: probability of n-gram (numeric)
#' @importFrom magrittr %<>%
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#' @importFrom dplyr anti_join
#' @examples
#' nGF <- ngrams_tables(en_bl_sentences[1:100], ng=4)
#' nGF_prob <- set_prob_of_ngrams(pfx="love spending", nGF, discnt=0.75)
#' @export
set_prob_of_ngrams <- function(pfx, nGF, discnt = 0.5) {
   pMass         <- 1
   # Probability mass to assign to ngrams (n=1..n)
   pMassAssigned <- 0
   # Total assigned probability mass
   pMassN <- numeric() # Total probability mass assigned to ngrams of order n

   ng <- word_count(pfx) + 1
   n <- ng
   nGF$prob <- 0
   nGF %<>% dplyr::mutate(id = row_number()) # Add row numbers
   while (n >= 1) { # backing off through progressively shorter history models
      sub_df <- nGF %>% dplyr::filter(ng == n)
      if (n > 1) {
         j <- grep(paste0("^", pfx, " "), sub_df$ngrams) # matching indices
         sub_df <- (sub_df[j,]) # sub_df with matched text only
      }
      sumfreq <- sum(sub_df$freq) #sum of frequencies
      if (sumfreq > 0) { #one or more matches
         if (n == 1) {
            discnt <- 0
         }
         nGF %<>% dplyr::anti_join(sub_df,by="id") # Remove records that will be updated
         sub_df %<>% dplyr::mutate(prob = pMass * (freq - discnt) / sumfreq) # calculate probability

         pMassN <- append(pMassN,sum(sub_df$prob[]))

         pMassAssigned %<>% sum(., tail(pMassN,1))
         pMass <- 1 - pMassAssigned
         nGF <-
            do.call(rbind, list(nGF, sub_df)) ## Add updated records to nGF
      }
      pfx <- RemoveFirstWord(pfx)
      n <- n - 1
   }
   nGF %<>% dplyr::arrange(., desc(prob))
   nGF$id <- NULL

   return(nGF)
}



