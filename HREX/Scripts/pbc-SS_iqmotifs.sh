#!/bin/bash
#SBATCH --partition=regular 
#SBATCH --job-name=test 
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --output=%x.out
#SBATCH --error=%x.err
#SBATCH --time=60

# This script corrects the periodicity of the HREX
# trajectories of the additional IQ motifs, and 
# computes the time evolution of their secondary
# structure content.

# To run it on a SLURM system, execute:
# sbatch pbc-SS_iqmotifs.sh

# Modify the following two lines as needed
module load GROMACS/2021.3-fosscuda-2020b-PLUMED-2.7.2

cd /scratch/rafael/CaMRecog/AdditionalIQmotifs 

for motif in $(ls)
do

    cd ${motif}

    # Correct PBC

    echo "1 1" | gmx_mpi trjconv -s md.tpr -f md.xtc -o md_mol.xtc \
    -pbc mol -ur compact -center 

    echo "1" | gmx_mpi trjconv -s md.tpr -f md_mol.xtc -o \
    md_mol_whole.xtc -pbc whole 
    rm md_mol.xtc

    echo "1 1" | gmx_mpi trjconv -s md.tpr -f md_mol_whole.xtc -o \
    md_mol_whole_cluster.xtc -pbc cluster
    rm md_mol_whole.xtc

    echo "1" | gmx_mpi trjconv -s md.tpr -f md_mol_whole_cluster.xtc -o \
    firstframe.gro -dump 0 

    echo "1 1" | gmx_mpi trjconv -f md_mol_whole_cluster.xtc -o \
    md_mol_whole_cluster_rottrans.xtc -s firstframe.gro -fit rot+trans
    rm md_mol_whole_cluster.xtc

    echo "1" | gmx_mpi mindist -f md_mol_whole_cluster_rottrans.xtc -s \
    md.tpr -od mindist.xvg \
    -pi > mindist.dat

    # Compute DSSP secondary structure assignment of SK2

    # Change this path as needed
    export DSSP=/dipc/rafael/anaconda3/bin/mkdssp
    echo "1" | gmx_mpi do_dssp -f \
    md_mol_whole_cluster_rottrans.xtc -s md.tpr -o ss.xpm 

    cd ..

done
