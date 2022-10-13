#!/bin/bash

# This awk line extracts the contacts corresponding to W431 or L427 
# from contactMap.dat (generated with reformatXPMContactsFile.sh) 
# To execute this, run ./extract-W431-W427-contacts.sh 
# (with contactMap.dat in the current directory).

# If the V426 instead of the L427 contacts are desired,
# replace "($1==8)" with "($1==7)" in the awk line.

awk '{if ($1==8) print 1,$2,$3; else if ($1==12) print 2,$2,$3}' \
contactMap.dat > contactMap_431-427.dat 
