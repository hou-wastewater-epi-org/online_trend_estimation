KFAS_rolling_estimation <- function(init_vals_roll, 
                               ts_obs_roll,  
                               ts_name_roll,
                               dates_roll,
                               init.par_roll,
                               ts.missing_roll){
  
  ## perform initial fit on "burnin" of first init_vals_roll time points 
  fits_rolling<- KFAS_state_space_spline(ts_obs = ts_obs_roll[1:init_vals_roll],
                                    name = ts_name_roll,                                     
                                    ts.missing = ts.missing_roll[1:init_vals_roll], 
                                    ts_dates = dates_roll[1:init_vals_roll], 
                                    init_par = init.par_roll)

  
  # just keep estimates for dates in burnins
  # smoother need not be kept
  fits_rolling <- dplyr::filter(fits_rolling, 
                         date == dates_roll[1:init_vals_roll], 
                         fit == "filter")
  
  
  # use variance estimates from burnin fit to initialize model for next time point
  next.par <- c(fits_rolling$sigv[init_vals_roll], fits_rolling$sigw[init_vals_roll])
  
  ## perform rolling estimation for each time point
  for(i in (init_vals_roll +1):length(ts_obs_roll)){
    # just looking to current time point
    ts_partial <- ts_obs_roll[1:i]

    # fit the model for the next time point
    ith_fit <- KFAS_state_space_spline(ts_obs = ts_partial,
                                      name = ts_name_roll, 
                                      ts.missing = ts.missing_roll[1:i], 
                                      ts_dates = dates_roll[1:i], 
                                      init_par = next.par)
    # save results of model fit
    if(exists("ith_fit")){
      fits_rolling <- rbind(fits_rolling, dplyr::filter(ith_fit, date == dates_roll[i], fit == "filter"))
      # get updated variance estimates for observation and state
      next.par <- c(ith_fit$sigv[nrow(ith_fit)], ith_fit$sigw[nrow(ith_fit)])
      ## compute smoother at final time point
      if(i == length(ts_obs_roll)){
        fits_rolling <- rbind(fits_rolling, dplyr::filter(ith_fit, fit == "smoother"))
      }
      rm(ith_fit)
    }else{ ## I don't know how to error handling, feel free to do a pull request 
      print(rep("FAIL", times = 100))
    }
  }
  ## give the user an update once each series' estimation is complete
  print(paste("Model fit complete: ", ts_name_roll[1])) 
  return(fits_rolling)
  
}