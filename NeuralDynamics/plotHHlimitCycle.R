library(ggplot2)
library(tidyverse)
library(dplyr)
library(gridExtra)

source("numericalHH.R")

lcData <- data.frame(t=out[,"time"],v=out[,"v"],n=out[,"n"])

ggplot(lcData) + geom_path(aes(x = v, y = n, color = t),lwd=2) + 
  xlim(c(-100,70)) + ylim(c(0,1)) + xlab("Potential v [mV]") + ylab("K Gate Variable n") + 
  theme_bw()
