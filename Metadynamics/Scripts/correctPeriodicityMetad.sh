#!/bin/bash
#SBATCH --partition=regular 
#SBATCH --job-name=longLMetad-2t 
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --output=%x.out
#SBATCH --error=%x.err
#SBATCH --time=100 

# This script corrects the periodicity of the metadynamics
# trajectories.

# To execute it on a SLURM system, simply run 
# sbatch correctPeriodicityMetad.sh in the directory where 
# the Gromacs output files are located. 

# Be sure the "index.ndx" file is on the current directory.

# Modify the following line as needed.
module load GROMACS/2021.3-fosscuda-2020b-PLUMED-2.7.2

echo "20 20" | gmx_mpi trjconv -s md.tpr -f md.xtc -o md_mol.xtc -n \
index.ndx -pbc mol -ur compact \
-center 
echo "20" | gmx_mpi trjconv -s md.tpr -f md_mol.xtc -o \
md_mol_whole.xtc -n index.ndx -pbc whole 
rm md_mol.xtc
echo "20 20" | gmx_mpi trjconv -s md.tpr -f md_mol_whole.xtc -o \
md_mol_whole_cluster.xtc -n index.ndx \
-pbc cluster
rm md_mol_whole.xtc
echo "20" | gmx_mpi trjconv -s md.tpr -f md_mol_whole_cluster.xtc -o \
firstframe.gro -dump 0 -n index.ndx 
echo "20 20" | gmx_mpi trjconv -f md_mol_whole_cluster.xtc -o \
md_mol_whole_cluster_rottrans.xtc -s firstframe.gro -n \
index.ndx -fit rot+trans
rm md_mol_whole_cluster.xtc
