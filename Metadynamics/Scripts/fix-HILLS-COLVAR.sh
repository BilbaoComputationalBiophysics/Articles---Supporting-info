#!/bin/bash

# When restarting a metadynamics run
# using PLUMED, additional lines might
# be inserted in the HILLS or COLVAR 
# files, corresponding to earlier time 
# steps stored in the checkpoint file.
# This script deletes these lines.

# To run it, execute 
# ./fix-HILLS-COLVAR.sh HILLS
# or ./fix-HILLS-COLVAR.sh COLVAR

# The fixed file HILLS_FIXED or
# COLVAR_FIXED are generated.

inp=$1

# Get time interval between lines (dif).
sed -n 1,10p ${inp} | awk '{if (substr($1,1,1)!="#") print $1}' | cut -f 1 -d . > tmp 
f=$(sed -n 1p tmp); s=$(sed -n 2p tmp); dif=$((s-f)) 
rm tmp

# Get blocks of lines starting with #, and the previous
# and next lines.
grep -n "^#" -B 1 -A 1 ${inp} > tmp; echo "--" >> tmp 

# Get numbers of lines limiting those blocks.
lim=($(grep -n "^--$" tmp | cut -f 1 -d :))

# Get pairs of line numbers limiting those blocks
# to iterate over them later.
unset pairlim
for i in $(seq 0 1 $((${#lim[@]}-2)))
do
pairlim=(${pairlim[@]} $(echo $((lim[${i}]+1)),$((${lim[$((i+1))]}-1))))
done

# Loop over blocks, calculating the line intervals
# to be deleted.
unset arg
for i in $(seq 0 1 $((${#pairlim[@]}-1)))
do
p1=$(echo ${pairlim[${i}]} | cut -f 1 -d ,)
p2=$(echo ${pairlim[${i}]} | cut -f 2 -d ,)
jump=$((p2-p1-1))
t1=$(sed -n ${p1}p tmp | awk '{print $2}' | cut -f 1 -d .)
t2=$(sed -n ${p2}p tmp | awk '{print $2}' | cut -f 1 -d .)
l2=$(sed -n ${p2}p tmp | awk '{print $1}' | cut -f 1 -d -)
ll=$((l2-1))
## first line = ll - ( ((t1 + jump * dif) - (t2 - dif)) / dif - 1 ) 
## first line = ll - ( (t1 - t2 + (jump+1)*dif) / dif - 1) 
fl=$((ll-t1/dif+t2/dif-jump))
arg=$(echo "${arg} -e ${fl},${ll}d")
done
rm tmp

# Fix the HILLS or COLVAR file by deleting those lines.
sed ${arg} ${inp} > ${inp}_FIXED
