install.packages(c("devtools", "knitr", "corpcor", "ggplot2", "survival", "rms"))

source("http://bioconductor.org/biocLite.R")
biocLite(c("Biobase", "impute"))

source("http://depot.sagebase.org/CRAN.R")
pkgInstall("synapseClient")

require(devtools)
install_github("rGithubClient", "brian-bot", ref="rGithubClient-0.7")
install_github("cafr", "weiyi-bitw", ref="master") ## ADD TAG INFORMATION
install_github("predictiveModeling", "Sage-Bionetworks", ref="master") ## ADD TAG INFORMATION
install_github("BCC", "Sage-Bionetworks", ref="master") ## ADD TAG INFORMATION
install_github("DreamBox7", "weiyi-bitw", ref="master") ## ADD TAG INFORMATION
