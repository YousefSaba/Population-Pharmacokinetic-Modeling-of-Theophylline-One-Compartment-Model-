library(nlmixr2) 
library(ggplot2)


# Step 1: Look at the built-in theophylline data
data(theo_sd)  # single-dose theophylline data
head(theo_sd) 
# Columns: ID, TIME, DV (concentration), AMT (dose), EVID, CMT, WT

# Step 2: Plot the raw data first — always look at your data
ggplot(theo_sd[theo_sd$EVID==0,], aes(TIME, DV, group=ID, color=factor(ID))) +
  geom_line() + geom_point() +
  labs(x="Time (hours)", y="Concentration (mg/L)", 
       title="Theophylline — observed concentration-time data") +
  theme_classic() + theme(legend.position="none")

# Step 3: Define a one-compartment oral model
one_cmt_model <- function() { 
  ini({
    tka  <- 0.45
    tcl  <- -3.2
    tv   <- -1
    
    eta.ka ~ 0.6
    eta.cl ~ 0.3
    eta.v  ~ 0.1
    
    add.sd <- 0.7
  })
  
  model({
    KA <- exp(tka + eta.ka)
    Cl <- exp(tcl + eta.cl)
    Vc <- exp(tv  + eta.v)
    
    linCmt() ~ add(add.sd)
  })
}

# Step 4: Fit the model
fit <- nlmixr2(
  one_cmt_model,
  theo_sd,
  est = "saem",
  control = saemControl(print = 0)
)

print(fit)
plot(fit)

# Step 5: Look at results
print(fit)
plot(fit)   # GOF plots automatically
