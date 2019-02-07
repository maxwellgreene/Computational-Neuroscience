library(ggplot2)
library(tidyverse)
library(dplyr)
library(gridExtra)

source("numericalHHsimplified.R")

HHsol <- data.frame(t=out[,"time"],v=out[,"v"],h=0.83-out[,"n"],m=alpha_m(out[,"v"])/(alpha_m(out[,"v"]) + beta_m(out[,"v"])),n=out[,"n"])



ps1 <- HHsol %>%
  ggplot(aes(x = t, y = v)) +
  geom_line(aes(x = t, y = v),lwd=2) +
  labs(x="time [ms]",y = "v [mV]") +
  theme_bw()

ps2 <- HHsol %>%
  gather(Column, Value, -t,-v) %>%
  ggplot(aes(x = t, y = Value, color = Column)) +
  geom_line(aes(x = t, y = Value),lwd=2) +
  labs(x="time [ms]",y = "gate variables") +
  guides(color=guide_legend(title="Gating variable")) + 
  theme_bw()

grid.arrange(ps1, ps2, nrow = 2)

lcData <- data.frame(t=out[,"time"],v=out[,"v"],n=out[,"n"])

ggplot(lcData) + geom_path(aes(x = v, y = n, color = t),lwd=2) + 
  xlim(c(-100,70)) + ylim(c(0,1)) + xlab("Potential v [mV]") + ylab("K Gate Variable n") + 
  theme_bw()
