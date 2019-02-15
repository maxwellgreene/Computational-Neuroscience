library(ggplot2)
library(tidyverse)
library(dplyr)
library(gridExtra)

source("twoDhhHopf.R")

# vary I from about 5 (crit = 5.2) through 7.5 (crit = 7.2)

Ival <- 5.5

out1 <- twoDhhBif(I=Ival)

lcData1 <- data.frame(t=out1[,"time"],v=out1[,"v"],n=out1[,"n"])

out2 <- twoDhhBif(I=Ival,v0=-65,n0=0.36)

lcData2 <- data.frame(t=out2[,"time"],v=out2[,"v"],n=out2[,"n"])

out3 <- twoDhhBif(I=Ival,v0=-65,n0=0.4)

lcData3 <- data.frame(t=out3[,"time"],v=out3[,"v"],n=out3[,"n"])

out4 <- twoDhhBif(I=Ival,v0=-25,n0=0.5)

lcData4 <- data.frame(t=out4[,"time"],v=out4[,"v"],n=out4[,"n"])



ggplot( ) + geom_path(data=lcData1,aes(x = v, y = n, color = t),lwd=1) + 
  geom_path(data=lcData2,aes(x = v, y = n, color = t),lwd=1) + 
  geom_path(data=lcData3,aes(x = v, y = n, color = t),lwd=1) + 
  geom_path(data=lcData4,aes(x = v, y = n, color = t),lwd=1) + 
  xlim(c(-100,50)) + ylim(c(0,1)) + xlab("Potential v [mV]") + ylab("K Gate Variable n") + 
  theme_bw()
