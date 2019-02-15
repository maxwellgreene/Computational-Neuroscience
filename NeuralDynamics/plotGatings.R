source("gatingVariables.R")

library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

v <- seq(-100,50,by=0.5) + 0.001

ah <- alpha_h(v)
am <- alpha_m(v)
an <- alpha_n(v)

bh <- beta_h(v)
bm <- beta_m(v)
bn <- beta_n(v)

asNbs <- data.frame(v=v,ah=ah,am=am,an=an,bh=bh,bm=bm,bn=bn)

asNbs %>%
  gather(Column, Value, -v) %>%
  ggplot(aes(x = v, y = Value, color = Column)) +
  geom_line(aes(x = v, y = Value),lwd=2) +
  labs(x="v [mV]",y = "alphas and betas") +
  guides(color=guide_legend(title="alpha and beta functions")) + 
  theme_bw()

h_inf <- ah/(ah + bh)
m_inf <- am/(am + bm)
n_inf <- an/(an + bn)

th <- 1/(ah + bh)
tm <- 1/(am + bm)
tn <- 1/(an + bn)

gatings <- data.frame(v=v,h_inf=h_inf,m_inf=m_inf,n_inf=n_inf,th=th,tm=tm,tn=tn)


p1 <- gatings %>%
  gather(Column, Value, -v,-th,-tm,-tn) %>%
  ggplot(aes(x = v, y = Value, color = Column)) +
  geom_line(aes(x = v, y = Value),lwd=2) +
  labs(x="v [mV]",y = "x_inf") +
  guides(color=guide_legend(title="Max gating")) + 
  theme_bw()


p2 <- gatings %>%
  gather(Column, Value, -v,-h_inf,-m_inf,-n_inf) %>%
  ggplot(aes(x = v, y = Value, color = Column)) +
  geom_line(aes(x = v, y = Value),lwd=2) +
  labs(x="v [mV]",y = "t_x [ms]") +
  guides(color=guide_legend(title="Time constant")) + 
  theme_bw()

grid.arrange(p1, p2, nrow = 1)


