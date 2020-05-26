
# Package enscnt

<!-- badges: start -->
<!-- badges: end -->

Dataset of Englisch sentences drawn from twitter, blogs and newspapers.

Data source:

[https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip]

Data is randomly selected (25%) with the script `sampling.r` in the
folder `/data-raw` (included in this package). 

The sentences are cleaned with the function `clean_text()` which is also exported by this package. 

## Installation

Install this package in R:

```R
devtools::install_github("KeesVanImmerzeel/enscnt")
```

Load the installed package in R with:

`library("enscnt")`

## Help
Get help information about the dataset:

`?ensentences`

Get help information about the funcions:

`?clean_text` 

