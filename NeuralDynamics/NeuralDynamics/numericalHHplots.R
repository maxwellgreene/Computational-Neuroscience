library(ggplot2)
library(tidyverse)
library(dplyr)
library(gridExtra)

source("numericalHH.R")

HHsol <- data.frame(t=out[,"time"],v=out[,"v"],h=out[,"h"],m=out[,"m"],n=out[,"n"])



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

grid.arrange(p1, p2, nrow = 2)

p3 <- HHsol %>%
  ggplot(aes(x=t,y=h+n)) + ylim(c(0,1)) + 
  geom_line(aes(x=t,y=h+n),lwd=2) + 
  geom_hline(yintercept = 0.83,color="red",lwd=2) +
  labs(x="time [ms]",y = "h+n") +
  theme_bw()

