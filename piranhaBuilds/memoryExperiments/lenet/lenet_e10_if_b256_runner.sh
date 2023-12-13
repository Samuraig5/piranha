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
#|--------------------------------------------------------------------------|
#|Build Piranha (-DFLOAT_PRECISION=12 -DTWOPC)                              |
#|Run three times for 2 parties                                             |
#|                                                                          |
#|Build Piranha (-DFLOAT_PRECISION=12)                                      |
#|Run three times for 3 parties                                             |
#|                                                                          |
#|Build Piranha (-DFLOAT_PRECISION=12 -DFOURPC)                             |
#|Run three times for 4 parties                                             |
#|--------------------------------------------------------------------------|
#|Build Piranha with (-DFLOAT_PRECISION=12 -DFOURPC)                        |
#|Run three times for 2 parties                                             |
#|Reuild Piranha with -DFLOAT_PRECISION = DFLOAT_PRECISION + 2              |
#|      Until -DFLOAT_PRECISION=26                                          |
#+--------------------------------------------------------------------------+

## Parameters
# Num. Parties      = 2-4
# NN model          = LeNet
# Custom Epochs     = 10
# Custom Iter.      = false
# Custom Batch s.   = 256

## Output
# Eval Accuracy     = true
# Eval Inf. Stats   = false
# Eval Train Stats  = false
# Eval fw peak mem. = true
# Eval bw peak mem. = true
# Eval Epoch Stats  = false


#CUDA_VISIBLE_DEVICES=3 ./piranha -p 3 -c piranhaBuilds/memoryExperiments/lenet/4pc_lenet_e10_if_b256_config.json >/dev/null &
#CUDA_VISIBLE_DEVICES=2 ./piranha -p 2 -c piranhaBuilds/memoryExperiments/lenet/3pc_lenet_e10_if_b256_config.json >/dev/null &
CUDA_VISIBLE_DEVICES=1 ./piranha -p 1 -c piranhaBuilds/memoryExperiments/lenet/2pc_lenet_e10_if_b256_config.json >/dev/null &
CUDA_VISIBLE_DEVICES=0 ./piranha -p 0 -c piranhaBuilds/memoryExperiments/lenet/2pc_lenet_e10_if_b256_config.json