#!/bin/bash
#SBATCH --partition=regular 
#SBATCH --job-name=AnLMetad-2t 
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --output=%x.out
#SBATCH --error=%x.err
#SBATCH --time=20

# This script generates the free energy surfaces
# as a function of the angle between CaM, W431
# Calpha and W431 aromatic ring.

# To run it on a SLURM system, execute 
# sbatch genFESMetad.sh

# Make sure HILLS_FIXED is in the current 
# directory.

# Modify the following line as needed.
module load GROMACS/2021.3-fosscuda-2020b-PLUMED-2.7.2 

# Calculate the (final) free energy surface as a function of 
# the biased CV (fes.dat)
plumed sum_hills --hills HILLS_FIXED

# Calculate free energy surfaces every "stride" deposited 
# kernels (in this case, 50000 kernels = 50 ns) 
plumed sum_hills --hills HILLS_FIXED --stride 50000 --mintozero
