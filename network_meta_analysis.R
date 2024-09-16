source("data_validation.R")
source("error_handling.R")

library(netmeta)

perform_network_meta_analysis <- function(data) {
  tryCatch({
    validate_network_meta_analysis_data(data)
    
    net <- netmeta(TE = data$TE, seTE = data$seTE, treat1 = data$treat1, treat2 = data$treat2, studlab = data$studlab)
    
    net_structure <- network.structure(data)
    
    net_graph <- netgraph(net, plastic = FALSE, col = "blue")
    
    forest_plot <- forest.df(net)
    
    return(list(
      model = net,
      treatments = net$trts,
      n_studies = net$k,
      n_comparisons = net$m,
      tau2 = net$tau2,
      I2 = net$I2,
      Q = net$Q,
      df_Q = net$df.Q,
      p_Q = net$pval.Q,
      random_effects = net$TE.random,
      fixed_effects = net$TE.fixed,
      p_values = net$pval.random,
      net_graph = net_graph,
      net_structure = net_structure,
      forest_plot = forest_plot
    ))
  }, error = function(e) {
    handle_error(e)
  })
}

check_consistency <- function(net) {
  tryCatch({
    consistency <- netsplit(net)
    return(consistency)
  }, error = function(e) {
    handle_error(e)
  })
}

rank_treatments <- function(net) {
  tryCatch({
    ranking <- netrank(net)
    return(ranking)
  }, error = function(e) {
    handle_error(e)
  })
}