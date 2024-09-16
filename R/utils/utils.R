convert_to_yi_vi <- function(data, measure = "SMD") {
  # Implementation depends on the input format
  # This is just a placeholder
  escalc(measure = measure, n1i = data$n1, n2i = data$n2, 
         m1i = data$m1, m2i = data$m2, sd1i = data$sd1, sd2i = data$sd2)
}