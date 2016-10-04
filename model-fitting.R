# Here's a (simulated) experiment, with a single subject and 500 categorization trials.
all.data <- read.csv('experiment-data.csv')
source('memory-limited-exemplar-model.R')
rm(sample.data.set)
rm(sample.training.data)

# Use optim() to fit the model to this data.
# Note: In optim() you can tell it to display updates as it goes with:
# optim( ... , control=list(trace=4))

exemplar.memlog.likelihood <- function(parameters){
  sensitivity <- parameters[1]
  decay.rate <- parameters[2]
  exemplar.memory.log.likelihood(all.data, sensitivity, decay.rate)
}

optim(c(1, 1), exemplar.memlog.likelihood, method="Nelder-Mead")

# Now try fitting a restricted version of the model, where we assume there is no decay.
# Fix the decay.rate parameter to 1, and use optim to fit the sensitivity parameter.
# Note that you will need to use method="Brent" in optim() instead of Nelder-Mead. 
# The brent method also requires an upper and lower boundary:
# optim( ..., upper=100, lower=0, method="Brent")

exemplar.memlog.likelihood.fix.decay <- function(sensitivity){
  exemplar.memory.log.likelihood(all.data, sensitivity, 1)
}

optim(1, exemplar.memlog.likelihood.fix.decay, upper= 100, lower= 0, method="Brent")

# What's the log likelihood of both models? (see the $value in the result of optiom(),
# remember this is the negative log likeihood, so multiply by -1.

# model optimized on sensitivity and decay.rate: 345.1454
# model optimized on sensitivity alone with fix decay.rate: 1241.907

# What's the AIC and BIC for both models? Which model should we prefer?
#AIC
AIC.model <- (2*2) - (2*log(345.1454))
AIC.model.fix.decay <- 2 - (2*log(1241.907))

#BIC
BIC.model <- (-2*log(345.1454))+(2*500) 
BIC.model.fix.decay <- (-2*log(1241.907))+ 500 

#the model without fix decay should be favored


#### BONUS...
# If you complete this part I'll refund you a late day. You do not need to do this.

# Use parametric bootstrapping to estimate the uncertainty on the decay.rate parameter.
# Unfortunately the model takes too long to fit to generate a large bootstrapped sample in
# a reasonable time, so use a small sample size of 10-100 depending on how long you are
# willing to let your computer crunch the numbers.

# Steps for parametric bootstrapping:
# Use the best fitting parameters above to generate a new data set (in this case, that means
# a new set of values in the correct column for all.data).
# Fit the model to this new data, record the MLE for decay.rate.
# Repeat many times to get a distribution of decay.rate values.
# Usually you would then summarize with a 95% CI, but for our purposes you can just plot a
# histogram of the distribution.

