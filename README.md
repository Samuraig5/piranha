
# Piranha: A GPU Platform for Secure Computation (on SciCORE)

<p align="center">
    <img src="https://github.com/ucbrise/piranha/blob/main/files/piranha-fish.png?raw=true" alt="cute cuddly PIRANHA >:D courtesy of Vivian Fang @ vivi.sh" width=20% height=20%/>
</p>

Piranha is a C++-based platform for accelerating secure multi-party computation (MPC) protocols on the GPU in a protocol-independent manner. It is designed both for MPC developers, providing a modular structure for easily adding new protocol implementations, and secure application developers, allowing execution on any Piranha-implemented protocols. This repo currently includes a secure ML inference and training application, which you can find in `/nn`.

Piranha is described in more detail in our [USENIX Security '22 paper](https://eprint.iacr.org/2022/892)! If you have questions, please create git issues; for eventual replies, you can also reach out to `jlw@berkeley.edu`.

> [!IMPORTANT]
> As part of the 2023 PET+P lecutre of the University of Basel, this repository has been modified to work with [SciCORE](https://scicore.unibas.ch/). The setup process is diffrent than in the [original repo for Piranha](https://github.com/ucbrise/piranha).

## SETUP AND BUILD

### SETTING UP THE PROJECT
**1. REMOTE INTO SCICORE**
Remote into [SciCORE](https://scicore.unibas.ch/) with your login.

**2. CLONE THE REPOSITORY**
```
git clone https://github.com/Samuraig5/piranha
```

**3. ENTER THE REPO**
```
cd piranha
```

**4. CHECKOUT EXTERNAL MODULES**
```
git submodule update --init --recursive
```

---------------------------------------------------------------------------------------------

### BUILD CUTLASS
**1. LOAD CMAKE**
```
ml load CMake
```

**2. LOAD CUDA**
```
ml load CUDA/12.3.1 
```

**3. BUILD CUTLASS**
```
cd ext/cutlass
mkdir build && cd build
cmake .. -DCUTLASS_NVCC_ARCHS=<YOUR_GPU_ARCH_HERE> -DCMAKE_CUDA_COMPILER_WORKS=1 -DCMAKE_CUDA_COMPILER=<YOUR NVCC PATH HERE>
make -j
```

>**NOTE:**
>
> The nvcc arch for the a100 GPU's I used was '80'. 
>
>The nvcc path does not necessarily need to be specified.
>
>For me this command worked:
>```
>cmake .. -DCUTLASS_NVCC_ARCHS=80 -DCMAKE_CUDA_COMPILER_WORKS=1
>```

**4. RETURN TO THE ROOT PIRANHA FOLDER**
```
cd ../../..
```

---------------------------------------------------------------------------------------------
### BUILD PIRANHA
**1. MAKE PIRANHA**
```
make -j8 PIRANHA_FLAGS="-DFLOAT_PRECISION=<BITS_OF_PRECISION> -D<PROTOCOL_CODE>"
```

The exact form of this command will depend on your usage and the test you want to run. These are the protocol codes:

Protocol Codes:
ONEPC -> one party
TWOPC -> two parties (SecureML)
FOURPC -> four parties (fantastic four)
none -> three parties (Falcon)

and example for such a make command is

```
make -j8 PIRANHA_FLAGS="-DFLOAT_PRECISION=26 -DTWOPC"
```

**2. RUN PIRANHA**
```
./piranha -p <PARTY NUM> -c <CONFIG FILE>
```

Again, the exact form of this command will change from party to party and from test to test.
Loosly speaking, you want to 

Set up a run configuration using config.json as a base. 
Run Piranha on each machine with a party number (0 -> n_parties - 1):


### Running locally

In the SciCORE setting we want to run Piranha on a local machine. An example configuration for 3-party local execution can be found at `files/samples/localhost_config.json` accompanying runfile. You can modify the runfile to change which GPUs Piranha uses for each party using the `CUDA_VISIBLE_DEVICES` environment variable. The script uses GPUs 0-2 by default, but can be changed to run on a single GPU as well. Note that due to contention, hosting several parties on a single GPU will limit the problem sizes you can test and incur some additional overhead.

Start the computation with:

```
./files/samples/localhost_runner.sh
```

## Changes
I had to undertake significant changes to the project inorder to get parts of it to work (huge shout out to the TA's of the PET+P course).
Here I will list the most significant and the resoning for the changes:

**1. Makefile**

The Makefile as such did not work. We had to change so many things in it that I've lost track of every detail. In broad strokes we changed how the GTest library was included, the currently used CUDA library and the path to the nvcc installation as it is not the same as in usual installations. 

**2. Training Data**

The python scripts provided for the download and creation of the MNIST and CIFAR10 datasets did not work in SciCORE. Instead I created the MNIST on a local machine and tranfered the already prepared data to scicore. 
Intresstingly, eventhough the code to CIFAR10 is idendical, my private machine was unable to successfully execute the code as it could not find the directories I created for it, eventhough the file path was correct.

## PROJECT
I've analysed the code and identified several aspects and parameters I'd like to investigate.

### Parameters
**Bold Parameters** are of especially great intrest.

In the config files we can change these parameters:
* (num_parties)
    Should be set to match the specific MPC protocol used
* party_ips
* **network**
    Neural network that should be trained
* custom_epochs(_count)
* custom_itirations(_count)
* custom_batch_size(_count)
* (preload(_path))
    Allows for the preloading of a neural network. Probably won't be used in my project.

In the build command we can further change these parameters
* **Fixed Point Precision**
    Number of bits used for precision
* **Protocol Used**
    MPC protocol used

By adjusting these boolean parameters in the config files we can change what output we want:
* eval_accuracy
* eval_inference_stats
* eval_train_stats (includes time)
* eval_fw_peak_memory
* eval_bw_peak_memory
* eval_epoch_stats

### Project Questions
The following are the questions I'd like to investigate. They allow me to compare my results with the orignial paper while hopefully allowing me to find some of my own insight.

Can we reproduce the results from Figure 5 (Fixed Point Precision - Accuracy graph)?
Does the number of bits used for Fixed Point Precision impact runtime or memory usage?
How does memory usage vary from one NN model - MPC protocol pair to the others?
Can we reporduce the results from Table 2 (Comparing diffrent NN and MPC protocol combinations)?

### Runs
//LIST ALL RUN CONFIG NAMES HERE

### Evaluation 
Each single test should be preformed atleast three times.
All the data produced will be saved to a excel table together with the name of the config file and important parameter settings it was produced under. 
Any graphs will show the median value and show the deviations of other values. This should help us when analysing the data. 

### Analysis
//DO ANALYSIS HERE