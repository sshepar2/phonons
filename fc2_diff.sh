#!/bin/bash

    ##############################################
   ##############################################
  ## CONVERGENCE OF 2ND ORDER FORCE CONSTANTS ##
 ##############################################
##############################################
#
# The purpose of this script is to match up force
# constants calculated with different q points in
# order to compare overlapping force constant
# matrix elements to see if some sort of
# convergence is met (by simply taking the
# difference).
#
# The script should be run as below
#  >>> fc2_diff.sh 'file1' 'file2'
#
# Where file1 and file2 are the output files
# from d3_q2r.x applied to the dynamical matrices
# (2nd order) produced by the ph.x command (all
# Quantum Espresso)
#
##################################################

#############################################################################
 ## 1) Determing which input file has less force constant matrix elements ##
  #########################################################################

# getting the real space lattice vector number for the first force constant of each file
# a larger sampling number of q points means a larger cell and more real space lattice vectors

num1=$(grep -A 1 '        1        1           1        1' $1 | awk 'FNR == 2 {print $1}')
num2=$(grep -A 1 '        1        1           1        1' $2 | awk 'FNR == 2 {print $1}')

#determining which has less force constants to use as comparison reference

if [ $num1 -gt $num2 ]
then
  small=$2
  large=$1
elif [ $num2 -gt $num1 ]
then
  small=$1
  large=$2
else
  small=$1
  large=$2
fi

# gets line number of first force constant
large_num=$(grep -A 1 '        1        1           1        1' $large | awk 'FNR == 2 {print $1}')
small_num=$(grep -A 1 '        1        1           1        1' $small | awk 'FNR == 2 {print $1}')

fc_line=$(grep -n '        1        1           1        1' $small | grep -Eo '^[^:]+')
line=$(echo $fc_line + 2 | bc)

max_line=$(grep -c '' $small)
fc_num=1

echo "r1 r2 a1 a2 R1 R2 R3 Smaller_Cell Larger_Cell Difference" > diff_$small$large

while [ $line -lt $max_line ] ; do

    for (( i=1; i<=$small_num; i++ )) ; do

        # value of fc in small
        fc_small=$(head -$line $small | tail -1 | awk '{print $4}')

        # value of fc in large
        # get all real space lattice vectors under 1111 in the larger file | select the lattice vector wwe are on in the small file | get actual value from large file
        fc_large=$(grep -A $(echo $large_num + 1 | bc) "$(head -$fc_line $small | tail -1)" $large | grep "$(head -$line $small | tail -1 | head -c12)" | awk '{print $4}')

        # difference (fc_small - fc_large)
        # formatting issue with bc, must remove the "+" 's and replace "E" with "*10^"
        fc_small_form=$(echo "${fc_small//+}")
        fc_large_form=$(echo "${fc_large//+}")
        fc_diff=$(echo "$fc_small_form $fc_large_form" | sed 's/E/*10^/g;s/ / - /' | bc -l)

        # current force constant and lattice vector for printing purposes
        fc_print=$(head -$fc_line $small | tail -1)
        rs_print=$(head -$line $small | tail -1 | head -c12)
        echo "$fc_print $rs_print $fc_small $fc_large $fc_diff" >> diff_$small$large

        #set up for next real space lattice vector in this fc
        line=$(echo $line + 1 | bc)

    done # end for loop

    echo "force constant $fc_num complete..."

    # getting new line number for teh next force constant (using old small_num variable)
    fc_line=$(echo $fc_line + $small_num + 2 | bc)

    # getting new small and large num which are how many real space lattice vectors in the next focre constant
    small_num=$(grep -A 1 "$(head -$fc_line $small | tail -1)" $small | awk 'FNR == 2 {print $1}')
    large_num=$(grep -A 1 "$(head -$fc_line $small | tail -1)" $large | awk 'FNR == 2 {print $1}')

    # setting line to start on the first real space lattice vector of the next force constant, for the next loop.
    line=$(echo $line + 2 | bc)

    # cycle to next fc
    fc_num=$(echo $fc_num + 1 | bc)

done # end while loop

echo "All force constant differences from $small have been calculated"

column -t diff_$small$large > fcdiff.temp && mv fcdiff.temp diff_$small$large

#column -t diff_$small$large
