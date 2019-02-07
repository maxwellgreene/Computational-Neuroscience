library(deSolve)

source("gatingVariables.R")

# parameters
parameters <- c(C=1,gk=36,gna=120,gl=0.3,vk=-82,vna=45,vl=-59,iext=10)

# initial conditions
v0 <- -50
m0 <- alpha_m(v0)/(alpha_m(v0)+beta_m(v0));

yini <- c(v=v0, h=1, m=m0, n=0.4)


t_initial <- 0
t_final <- 50
times <- seq(from = t_initial, to = t_final, by = 0.08)


# define function to be in the format that `ode` uses
HH <- function (t, y, parms) {
    # variables
    v <- y[1]
    h <- y[2]
    m <- y[3]
    n <- y[4]
    # parameters
    C <- parms[1]; gk <- parms[2]; gna <- parms[3]
    gl <- parms[4]; vk <- parms[5]; vna <- parms[6]
    vl <- parms[7]; iext <- parms[8]
    # functional forms
    h_inf <- alpha_h(v)/(alpha_h(v) + beta_h(v))
    m_inf <- alpha_m(v)/(alpha_m(v) + beta_m(v))
    n_inf <- alpha_n(v)/(alpha_n(v) + beta_n(v))
    
    tau_h <- 1/(alpha_h(v) + beta_h(v))
    tau_m <- 1/(alpha_m(v) + beta_m(v))
    tau_n <- 1/(alpha_n(v) + beta_n(v))
  
    dv <- (gna*m^3*h*(vna - v) + gk*n^4*(vk - v) + gl*(vl - v) + iext)/C
    dh <- (h_inf - h)/tau_h
    dm <- (m_inf - m)/tau_m
    dn <- (n_inf - n)/tau_n
    return(list(c(dv, dh, dm, dn) ) )
}

out <- ode(y = yini, times = times, func = HH,
           parms = parameters,method = "ode45")
