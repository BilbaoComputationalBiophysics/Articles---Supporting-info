#!/bin/bash
#SBATCH --partition=biophys 
#SBATCH --account=biophys
#SBATCH --job-name=longhrex 
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --output=%x.out
#SBATCH --error=%x.err

# This script corrects the periodicity of the HREX
# trajectories, and computes the RMSF, SASA, and a
# contact map for the HREX trajectories.
# To run it on a SLURM system, execute:
# sbatch pbc-SS-RMSF-SASA-contacts-HREX.sh

# Modify the following two lines as needed
module load GROMACS/2016.4-foss-2019b-PLUMED-2.4.0

cd /scratch/rafael/CaMRecog/SK227-43/Prod 

for j in {0..14}
do
    cd R${j}    
    echo "20 20" | gmx trjconv -s md.tpr -f md.xtc -o md_mol.xtc -n \
    ../../index.ndx -pbc mol -ur compact \
    -center 
    echo "20" | gmx trjconv -s md.tpr -f md_mol.xtc -o \
    md_mol_whole.xtc -n ../../index.ndx -pbc whole 
    rm md_mol.xtc
    echo "20 20" | gmx trjconv -s md.tpr -f md_mol_whole.xtc -o \
    md_mol_whole_cluster.xtc -n ../../index.ndx \
    -pbc cluster
    rm md_mol_whole.xtc
    echo "20" | gmx trjconv -s md.tpr -f md_mol_whole_cluster.xtc -o \
    firstframe.gro -dump 0 -n ../../index.ndx 
    echo "20 20" | gmx trjconv -f md_mol_whole_cluster.xtc -o \
    md_mol_whole_cluster_rottrans.xtc -s firstframe.gro -n \
    ../../index.ndx -fit rot+trans
    rm md_mol_whole_cluster.xtc
    echo "1" | gmx mindist -f md_mol_whole_cluster_rottrans.xtc -s \
    md.tpr -n ../../index.ndx -od mindist.xvg \
    -pi > mindist.dat
    if [ ${j} == 0 ] 
    then

	# Compute DSSP secondary structure assignment of SK2

	# Change this path as needed
        export DSSP=/dipc/rafael/anaconda3/bin/mkdssp
        echo "21" | gmx do_dssp -f \
        md_mol_whole_cluster_rottrans.xtc -s md.tpr -o ss.xpm -n \
        ../../index.ndx

        # Compute RMSF of SK2 residues 

        echo "21" | gmx rmsf -f md_mol_whole_cluster_rottrans.xtc \
        -s md.tpr -n ../../index.ndx -o rmsf_channel.xvg -xvg none -res 

        # Compute SASA of SK2 residues 

        echo "1" | gmx sasa -f md_mol_whole_cluster_rottrans.xtc \
        -s md.tpr -n ../../index.ndx -or sasaSK2.xvg -xvg none 

	# Compute average distance maps
	echo "1" | gmx mdmat -f md_mol_whole_cluster_rottrans.xtc \
	-s md.tpr -n ../../index.ndx -mean contactMap.xpm

    fi
    cd ..
done

