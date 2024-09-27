predict.powCD <- function(out, xnew) {
  # Perform matrix multiplication between new data and the coefficient matrix
  prediction <- xnew %*% out[["coeff"]]

  if (is.null(xnew)) stop("predict.powCD: xnew is NULL!")
  if (is.null(out$coeff)) stop("predict.powCD: Coefficients are NULL!")

  # Return the predictions
  return(prediction)
}
