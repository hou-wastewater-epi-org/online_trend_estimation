## creates chart for the series you input, make sure to remove burnin period.
## region 1 is the lift station
## region 2 is the WWTP
ww_ewma <- function(region1, region2, title.char, ylab.label="Standardized Difference in Series", events = NULL){
  
  
  ## observed series may have missing values. Use the estimated value from the WWTP state space model as imputed value.
  region1[region1$ts_missing, "obs"] <- dplyr::left_join(region1[region1$ts_missing,], region2, by = "date") %>% dplyr::pull(est.y)
  
  
  # if you have enough data to model region1 you can fill in with the estimated filter
  #region1[region1$ts_missing, "obs"] <- region1 %>% dplyr::filter(ts_missing) %>% dplyr::mutate(obs = est) %>% pull(obs)
  
 
  series1 <- region1 %>% dplyr::pull(obs)
  series2 <- region2 %>% dplyr::pull(est)
  
  # compute the difference
  diff <- series1 - series2
  
  var1 <- region1 %>% 
    dplyr::mutate(var_est = ((upr-est)/2)^2) %>% 
    dplyr::select(var_est)
  var2 <- region2 %>%
    dplyr::mutate(var_est = ((upr-est)/2)^2) %>% 
    dplyr::select(var_est)
  
  
  series1_missing <- region1 %>% dplyr::select(ts_missing)
  series2_missing <- region2 %>% dplyr::select(ts_missing)
  
  
  vals_missing <- (series1_missing + series2_missing) > 0
 
  
  # use correlation and variances to compute the covariance
  cor_estimate <- cor(series1, series2)
  cov_estimate <- cov_est <- as.numeric(cor_estimate)*sqrt(var1)*sqrt(var2)
  
  # create estimate of variance of the difference series using approximation
  var_est <- var1 + var2 -2*cov_estimate
  
  # create standardized difference series
  standardized_diff <- diff/sqrt(var_est)
  
  # compute lag 1 autocorrelation of standardized difference series
  lag1_est <- acf(standardized_diff, plot=F, na.action = na.pass)$acf[2] ## we could do something fancier
  
  # use qcc package to make ewma plot
  out <- qcc::ewma(standardized_diff, center = 0, sd = 1, 
                   lambda = lag1_est, nsigmas = 3, sizes = 1, plot = F)
  
  ## put NAs where we had missing values for either series
  #out$x[vals_missing] <-NA
  out$y[vals_missing] <- NA
  out$data[vals_missing,1]<- NA
  
  # create plot
  dat <- data.frame(x = region1$date, 
                    ewma = out$y, 
                    y = out$data[,1], 
                    col = out$x %in% out$violations, 
                    lwr = out$limits[20,1],
                    upr = out$limits[20,2])
  obs_dat <- data.frame(x = dat$x, y = out$data[,1], col = "black")
  p <-ggplot(dat, aes(x = x, y = ewma)) + 
    geom_vline(xintercept = events, 
               col = "darkgrey", 
               lwd = 1)+
    geom_line()+
    geom_point(aes(col = dat$col), size = 3) +
    scale_color_manual(values = c(1,2), label = c("No", "Yes"), name = "Separation?") +
    new_scale_color() +
    geom_point(data = obs_dat, aes(x = x, y = y, col =col), shape = 3) +
    scale_color_manual(values = "black", label = "Observed \nStandardized \nDifference", name = "") +
    geom_hline(aes(yintercept = out$limits[20,1]), lty = 2) + 
    geom_hline(aes(yintercept = out$limits[20,2]), lty = 2) +
    geom_hline(aes(yintercept = 0), lty = 1) + 
    ggtitle(paste(title.char))+
    xlab("Date") + ylab(ylab.label) +
    theme_minimal()

  return(p)
}
       