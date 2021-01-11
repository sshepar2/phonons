#!/bin/bash

#######################################################################
# Run script in directory with directories generated by VASP-setup.sh
# $ ./phono3py.sh $1
# where $1 is the number of directories generated by VASP-setup.sh
# 
# This script moves the vasprun.xml file from each directory #####
# to a newly created directory disp-##### without leading zeros.
# This is just for the syntax used by phonopy/phono3py when entering
# the directory names to calculate force constants.
#######################################################################


echo "making $1 directories for vasprun.xml files for phono3py post-processing"
for i in $(seq 1 $1) ; do
length=$(echo ${#i})
if [ $length -eq 1 ]
then
    prefix="0000"
    prefix="$prefix$i"
    disp="disp-$i"
    mkdir $disp
    mv $prefix/vasprun.xml $disp/
elif [ $length -eq 2 ]
then
    prefix="000"
    prefix="$prefix$i"
    disp="disp-$i"
    mkdir $disp
    mv $prefix/vasprun.xml $disp/
elif [ $length -eq 3 ]
then
    prefix="00"
    prefix="$prefix$i"
    disp="disp-$i"
    mkdir $disp
    mv $prefix/vasprun.xml $disp/
else
    echo "good luck with all that"
fi
done

echo "phono3py directory preparation complete"
