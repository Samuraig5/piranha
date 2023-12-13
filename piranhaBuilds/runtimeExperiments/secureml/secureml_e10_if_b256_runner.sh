#!/bin/bash

# Runs Piranha clients locally on 2-4 different GPUs

# WHEN CHANING THE NUMBER OF CLIENTS, CHANGE THE PREFIX OF EACH CONFIG PATH TO THE CORRECT NUMBER

#+--------------------------------------------------------------------------+
#|EXPERIMENT PROTOCOL                                                       |
#|                                                                          |
#|Build Piranha (-DFLOAT_PRECISION=26 -DTWOPC)                              |
#|Run three times for 2 parties                                             |
#|                                                                          |
#|Build Piranha (-DFLOAT_PRECISION=26)                                      |
#|Run three times for 3 parties                                             |
#|                                                                          |
#|Build Piranha (-DFLOAT_PRECISION=26 -DFOURPC)                             |
#|Run three times for 4 parties                                             |
#+--------------------------------------------------------------------------+

## Parameters
# Num. Parties      = 2-4
# NN model          = SecureML
# Custom Epochs     = 10
# Custom Iter.      = false
# Custom Batch s.   = 256

## Output
# Eval Accuracy     = true
# Eval Inf. Stats   = false
# Eval Train Stats  = false
# Eval fw peak mem. = false
# Eval bw peak mem. = false
# Eval Epoch Stats  = true


#CUDA_VISIBLE_DEVICES=3 ./piranha -p 3 -c piranhaBuilds/runtimeExperiments/secureml/4pc_secureml_e10_if_b256_config.json >/dev/null &
#CUDA_VISIBLE_DEVICES=2 ./piranha -p 2 -c piranhaBuilds/runtimeExperiments/secureml/3pc_secureml_e10_if_b256_config.json >/dev/null &
CUDA_VISIBLE_DEVICES=1 ./piranha -p 1 -c piranhaBuilds/runtimeExperiments/secureml/2pc_secureml_e10_if_b256_config.json >/dev/null &
CUDA_VISIBLE_DEVICES=0 ./piranha -p 0 -c piranhaBuilds/runtimeExperiments/secureml/2pc_secureml_e10_if_b256_config.json