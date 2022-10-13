#!/bin/bash

# This awk line computes the SASA differences between the "one
# turn" and the "two turns" systems.
# The error of these differences is computed as the square
# root of the sum of standard deviations of the individual
# SASA values (propagation of errors).

# To run this, execute:
# ./compute_sasa_diffs.sh

# (Change the file paths as needed).

awk '{if (NR==FNR) {sasa[NR]=$2; std[NR]=$3} 
else print $1,sasa[FNR]-$2,sqrt(std[FNR]**2+$3**2)}' \
 /scratch/rafael/CaMRecog/SK227-43/Prod/Test/R0/sasaSK2.xvg \
 /scratch/rafael/CaMRecog/SK2Prehelix/Prod/Test/R0/sasaSK2.xvg > \
 /scratch/rafael/CaMRecog/SK2Prehelix/Prod/Test/R0/sasaSK2diff.xvg 
