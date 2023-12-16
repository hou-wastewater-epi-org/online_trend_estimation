KFAS_state_space_spline <- function(ts_obs, name, ts.missing, ts_dates, init_par){
  
## Specify model structure
A = matrix(c(1,0),1)
Phi = matrix(c(2,1,-1,0),2)
mu1 = matrix(0,2) 
P1 = diag(1,2)
v = matrix(NA) 
R = matrix(c(1,0),2,1)
w = matrix(NA) 

#function for updating the model
update_model <- function(pars, model) {
  model["H"][1] <- pars[1]
  model["Q"][1] <- pars[2]
  model
}

#check that variances are non-negative
check_model <- function(model) {
  (model["H"] > 0 && min(model["Q"]) > 0)
}

# Specify the model
mod <- KFAS::SSModel(ts_obs ~ -1 +
                 SSMcustom(Z = A, T = Phi, R = R, Q = w, a1 = mu1, P1 = P1), H = v)

# Fit the model
fit_mod <- KFAS::fitSSM(mod, inits = init_par, method = "BFGS",
                  updatefn = update_model, checkfn = check_model, hessian=TRUE,
                  control=list(trace=FALSE,REPORT=1))

## Format for output
ts_len <- length(ts_obs)
smoothers <- data.frame(est = KFAS::KFS(fit_mod$model)$alphahat[,1],
                  lwr = KFAS::KFS(fit_mod$model)$alphahat[,1]- 1.96*sqrt(KFAS::KFS(fit_mod$model)$V[1,1,]),
                  upr = KFAS::KFS(fit_mod$model)$alphahat[,1]+ 1.96*sqrt(KFAS::KFS(fit_mod$model)$V[1,1,]),
                  ts_missing = ts.missing,
                  name = rep(name[1], times = ts_len),
                  fit = rep("smoother", times = ts_len),
                  date = ts_dates,
                  sigv = rep(fit_mod$optim.out$par[1], times = ts_len),
                  sigw = rep(fit_mod$optim.out$par[2], times = ts_len), 
                  obs = ts_obs, 
                  resid = rstandard(KFAS::KFS(fit_mod$model), type = "recursive"),
                  conv = fit_mod$optim.out$convergence)

filters <- data.frame(est = KFAS::KFS(fit_mod$model)$att[,1],
           lwr = KFAS::KFS(fit_mod$model)$att[,1]- 1.96*sqrt(KFAS::KFS(fit_mod$model)$Ptt[1,1,]),
           upr = KFAS::KFS(fit_mod$model)$att[,1]+ 1.96*sqrt(KFAS::KFS(fit_mod$model)$Ptt[1,1,]),
           ts_missing = ts.missing,
           name = rep(name[1], times = ts_len),
           fit = rep("filter", times = ts_len),
           date = ts_dates,
           sigv = rep(fit_mod$optim.out$par[1], times = ts_len),
           sigw = rep(fit_mod$optim.out$par[2], times = ts_len), 
           obs = ts_obs,
           resid = rstandard(KFS(fit_mod$model), type = "recursive"),
           conv = fit_mod$optim.out$convergence)
## combine it all for output.
kfas_fits_out <- dplyr::bind_rows(smoothers,filters)
return(kfas_fits_out)
}