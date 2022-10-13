# This script corrects the replica_index.xvg and
# replica_temp.xvg files, so that they contain the
# time (in ps) in the first column.
# It assumes that exchanges were attempted every 
# 50 ps and frames were saved every 100 ps 
# (as in our simulations).
# To run this, execute ./correct_replica_index_temp.sh 
# in the directory where replica_index.xvg and
# replica_temp.xvg are located.

for i in index temp
do
 awk '{if (NR%2==0) print $1+49,$0; else print $1,$0}' \
 replica_${i}.xvg > replica_${i}_f.xvg 
 awk '{$2=""; print $0}' replica_${i}_f.xvg > replica_${i}.xvg 
 rm replica_${i}_f.xvg
done
