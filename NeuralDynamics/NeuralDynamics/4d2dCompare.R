library(ggplot2)
library(tidyverse)
library(dplyr)
library(gridExtra)

source("numericalHH.R")
HHsol <- data.frame(t=out[,"time"],v=out[,"v"],h=out[,"h"],m=out[,"m"],n=out[,"n"])
lcData <- data.frame(t=out[,"time"],v=out[,"v"],n=out[,"n"])

source("numericalHHsimplified.R")
HHsimpSol <- data.frame(t=out[,"time"],v=out[,"v"],h=0.83-out[,"n"],m=alpha_m(out[,"v"])/(alpha_m(out[,"v"]) + beta_m(out[,"v"])),n=out[,"n"])
lcDataSimp <- data.frame(t=out[,"time"],v=out[,"v"],n=out[,"n"])

p1 <- HHsol %>%
  ggplot(aes(x = t, y = v)) +
  geom_line(aes(x = t, y = v),lwd=2) +
  labs(x="time [ms]",y = "v [mV]") +
  theme_bw()

p2 <- HHsol %>%
  gather(Column, Value, -t,-v) %>%
  ggplot(aes(x = t, y = Value, color = Column)) +
  geom_line(aes(x = t, y = Value),lwd=2) +
  labs(x="time [ms]",y = "gate variables") +
  guides(color=guide_legend(title="Gating variable")) + 
  theme_bw()

ps1 <- HHsimpSol %>%
  ggplot(aes(x = t, y = v)) +
  geom_line(aes(x = t, y = v),lwd=2) +
  labs(x="time [ms]",y = "v [mV]") +
  theme_bw()

ps2 <- HHsimpSol %>%
  gather(Column, Value, -t,-v) %>%
  ggplot(aes(x = t, y = Value, color = Column)) +
  geom_line(aes(x = t, y = Value),lwd=2) +
  labs(x="time [ms]",y = "gate variables") +
  guides(color=guide_legend(title="Gating variable")) + 
  theme_bw()

grid.arrange(p1, p2, ps1, ps2, nrow = 2)


lc1 <- lcData %>% ggplot() + geom_path(aes(x = v, y = n, color = t),lwd=2) + 
  xlim(c(-100,70)) + ylim(c(0,1)) + xlab("Potential v [mV]") + ylab("K Gate Variable n") + 
  theme_bw()

lc2 <- lcDataSimp %>% ggplot() + geom_path(aes(x = v, y = n, color = t),lwd=2) + 
  xlim(c(-100,70)) + ylim(c(0,1)) + xlab("Potential v [mV]") + ylab("K Gate Variable n") + 
  theme_bw()

grid.arrange(lc1, lc2, nrow = 1)
