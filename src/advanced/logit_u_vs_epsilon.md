# Inverse transform sampling Logit or simulated Logit

This section explains how METROPOLIS2 can simulate a Multinomial Logit model by either using inverse
transform sampling or including the epsilon draws in the utility and selecting the best alternative
deterministicly.

These two options have different implications on the input requirements and the output values.

Input: Inverse transform sampling only requires a `u` and `mu` parameters; simulated Logit requires
epsilon draws for all alternatives.

Output: Inverse transform sampling returns the logsum of the choice as `expected_utility`; simulated
Logit returns the utility of the selected alternative (including the epsilon draw) as
`expected_utility`).

> WARNING. This section is still incomplete.
