# We need number of tuning values of q, ''nq''. The default of ''nq'' should be 1!
powCD_wrapper <- function(x, y, q = 1, nlambda, nq = 1) {
  # Standardize the matrix x
  x_standardized <- apply(x, 2, function(z) {(z)/(sqrt(mean(z^2) - mean(z)^2))})

  # Calculate <x_j, y> for each j on standardized x
  x_y_dot_standardized <- colSums(x_standardized * y)

  # Find the maximum absolute value of <x_j, y>
  max_abs_x_y_dot_standardized <- max(abs(x_y_dot_standardized))

  # Set up the q sequence if nq > 1, otherwise use the single value of q
  q_seq <- if (nq > 1) seq(0.1, 1, length.out = nq) else q

  # Initialize the coefficient matrix to hold all values of beta.pow for different q
  p <- ncol(x)
  total_cols <- nlambda * length(q_seq)
  beta.pow_all <- matrix(0, p, total_cols)

  # Initialize the column names for the final beta.pow_all matrix
  col_names <- character(total_cols)

  # Initialize column counter for beta.pow_all
  col_counter <- 1

  # Small value epsilon for lambda_min
  epsilon <- 0.00001

  # Loop over each q in the q sequence
  for (q_val in q_seq) {
    # Calculate lambda_max for the current q
    n <- nrow(x)
    lambda_max_standardized <- (1/n) * (max_abs_x_y_dot_standardized / (2 - q_val))^(2 - q_val) * (2 - 2 * q_val)^(1 - q_val)

    # Calculate lambda_min
    lambda_min <- epsilon * lambda_max_standardized

    # Generate the sequence of lambda values on a log scale
    lambda_seq_manual <- exp(seq(log(lambda_max_standardized),
                                 log(lambda_min), length.out = nlambda))

    # Calculate the coefficients for each lambda and store them in beta.pow
    beta.pow <- matrix(0, p, nlambda)

    # Calculate the coefficients using the powCD function for each lambda
    beta.pow[, 1] <- powCD(X = x_standardized, y = y,
                           sigma.sq = n, lambda = lambda_seq_manual[1],
                           q = q_val, rand.restart = 0)

    for (i in 2:nlambda) {
      beta.pow[, i] <- powCD(X = x_standardized, y = y,
                             sigma.sq = n, lambda = lambda_seq_manual[i], q = q_val,
                             rand.restart = 0, start = beta.pow[, i-1])
    }

    # Add the results to the main beta.pow_all matrix and name the columns
    beta.pow_all[, col_counter:(col_counter + nlambda - 1)] <- beta.pow

    # Create column names for this range of lambda values
    for (i in 1:nlambda) {
      col_names[col_counter] <- paste0("lambda = ", round(lambda_seq_manual[i], 4),
                                       ", q = ", round(q_val, 2))
      col_counter <- col_counter + 1
    }
  }

  # Set the column names of the beta.pow_all matrix
  colnames(beta.pow_all) <- col_names

  # Create the output object (same as before, but now with all betas for different q's)
  obj <- list("coeff" = beta.pow_all, "lambda_seq" = lambda_seq_manual)

  # Assign class
  class(obj) <- "powCD"

  # Return the object
  return(obj)
}
