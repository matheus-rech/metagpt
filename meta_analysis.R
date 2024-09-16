source("data_validation.R")
source("error_handling.R")

library(meta)
library(metafor)
library(netmeta)

perform_meta_analysis <- function(data, effect_size = "SMD", method = "REML", reference = NULL) {
  tryCatch({
    # Handle both long and wide data formats
    data_wide <- entry.df(data = data, CONBI = ifelse(effect_size %in% c("MD", "SMD"), "Continuous", "Binary"))
    
    # Convert to contrast form if necessary
    if (effect_size %in% c("OR", "RR", "RD")) {
      data_contrast <- contrastform.df(data_wide, outcome = effect_size, CONBI = "Binary")
    } else {
      data_contrast <- contrastform.df(data_wide, outcome = effect_size, CONBI = "Continuous")
    }
    
    # Perform meta-analysis
    res <- rma(yi = data_contrast$TE, vi = data_contrast$seTE^2, method = method, measure = effect_size)
    
    # Create forest plot
    forest_plot <- forest.df(res, reference = reference)
    
    # Create funnel plot
    funnel_plot <- funnel(res)
    
    # Create summary table
    summary_table <- bugsnet_sumtb(data = data_wide, metaoutcome = ifelse(effect_size %in% c("MD", "SMD"), "Continuous", "Binary"))
    
    return(list(
      model = res,
      estimate = res$b,
      se = res$se,
      zval = res$zval,
      pval = res$pval,
      ci.lb = res$ci.lb,
      ci.ub = res$ci.ub,
      I2 = res$I2,
      H2 = res$H2,
      QE = res$QE,
      QEp = res$QEp,
      k = res$k,
      measure = res$measure,
      forest_plot = forest_plot,
      funnel_plot = funnel_plot,
      summary_table = summary_table
    ))
  }, error = function(e) {
    handle_error(e)
  })
}