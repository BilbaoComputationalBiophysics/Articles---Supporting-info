#!/bin/bash
#SBATCH --partition=regular 
#SBATCH --job-name=test3 
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --output=%x.out
#SBATCH --error=%x.err
#SBATCH --time=10

# This script extracts the frames where SK2 is fully
# helical in the "two turns" system with W431 pointing inward,
# ang generates a contact map of this subtrajectory
# of fully helical frames.

# To run it on a SLURM system, execute:
# sbatch extract-helical-frames-contacts.sh

# Be sure "frames.ndx" (generated with the 
# list-helical-frames.sh script) is in the current directory.

# Modify the following two lines as needed.
module load GROMACS/2016.4-foss-2019b-PLUMED-2.4.0

cd /scratch/rafael/CaMRecog/TwoTurnsTRPInward/Prod/Test/R0 

# Filter helical frames from md_mol_whole_cluster_rottrans.xtc
echo "20" | gmx trjconv -s md.tpr -f md_mol_whole_cluster_rottrans.xtc \
-n ../../../index.ndx -fr frames.ndx -o md_mol_whole_cluster_rottrans_helical.xtc 

# Generate an average contact map of this subtrajectory
echo "1" | gmx mdmat -f md_mol_whole_cluster_rottrans_helical.xtc -s md.tpr \
-n ../../../index.ndx -mean contactMapHelical.xpm 
