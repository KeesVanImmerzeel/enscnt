#' Sample of English sentences from twitter, blogs and newspapers.
#'
#' @source \url{https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip}
#'
#' For the constructing of this package, a fraction of the source data is randomly selected
#' with the script:
#'
#' 'data-raw/sampling.r'
#'
#' as the original files would be too large to be uploaded on GitHub.
#' The lines in the resulting file in data-raw/en.txt' are cleaned with the function clean_text()
#' (as included in this package) and made available as the dataset "ensentences".
#'
#' To show the first sentence of the dataset:
#' @examples
#' ensentences[1]
"ensentences"

#' Sample of English sentences from twitter.
#'
#' @source \url{https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip}
#'
#' For the constructing of this package, a fraction of the source data is randomly selected
#' with the script:
#'
#' 'data-raw/sampling.r'
#'
#' as the original files would be too large to be uploaded on GitHub.
#' The lines in the resulting file in data-raw/en_tw.txt' are cleaned with the function clean_text()
#' (as included in this package) and made available as the dataset "en_tw_sentences".
#'
#' To show the first sentence of the dataset:
#' @examples
#' en_tw_sentences[1]
"en_tw_sentences"

#' Sample of English sentences from blogs.
#'
#' @source \url{https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip}
#'
#' For the constructing of this package, a fraction of the source data is randomly selected
#' with the script:
#'
#' 'data-raw/sampling.r'
#'
#' as the original files would be too large to be uploaded on GitHub.
#' The lines in the resulting file in data-raw/en_bl.txt' are cleaned with the function clean_text()
#' (as included in this package) and made available as the dataset "en_bl_sentences".
#'
#' To show the first sentence of the dataset:
#' @examples
#' en_bl_sentences[1]
"en_bl_sentences"

#' Sample of English sentences from newspapers.
#'
#' @source \url{https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip}
#'
#' For the constructing of this package, a fraction of the source data is randomly selected
#' with the script:
#'
#' 'data-raw/sampling.r'
#'
#' as the original files would be too large to be uploaded on GitHub.
#' The lines in the resulting file in data-raw/en_ne.txt' are cleaned with the function clean_text()
#' (as included in this package) and made available as the dataset "en_ne_sentences".
#'
#' To show the first sentence of the dataset:
#' @examples
#' en_ne_sentences[1]
"en_ne_sentences"
