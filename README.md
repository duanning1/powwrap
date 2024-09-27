# Wrapper functions for the `powCD` function in the package `powopt`

## Description

This package contains three functions.

1. `powCD_wrapper`: a wrapper function for the powCD function in the package powopt.
   It takes in a sequence of lambda values and a sequence of q values. 
   It returns an object of class powCD that contains the beta coefficients and the generated sequence of lambda values.
2. `coef.powCD`: returns the beta coefficients from the powCD object.
3. `pred.powCD`: returns the predicted values from the powCD object given a new data set.

## Example code

```r
# examples of using the functions powCD_wrapper, coef.powCD, and predict.powCD

library(devtools)
# install_github("maryclare/powopt")
library(powopt)
# install_github("duanning1/powwrap")
library(powwrap)

x = matrix(rnorm(100), ncol = 10)
y = rnorm(10)
out = powCD_wrapper(x, y, nlambda = 10, nq = 5)
coefficients = coef.powCD(out)
newx = matrix(rnorm(100), ncol = 10)
predictions = predict.powCD(out, newx)
```
