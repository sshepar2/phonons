#!/bin/bash

########################################################################################
# Run this script in the same directory as the directories created using VASP-setup.sh
# $ ./chech.sh $1
# where $1 is the number of directories to check starting from 00001.
# 
# This script looks at lines in the various VASP output files to determine is the job
# has successfully completed. It also summarizes this and other information into a
# file called 'check.out'.
########################################################################################

echo "checking $1 directories"
echo "DIRNAME NELM EDIFF CHECK_1 CHECK_2 STEPS TIME(HR)" > check.out
anelm_count=0
aediff_count=0
acomp1_count=0
acomp2_count=0
esteps_count=0
step_list=()
time_count=0
time_list=()

for i in $(seq 1 $1) ; do
length=$(echo ${#i})
if [ $length -eq 1 ]
then
    prefix="0000"
    prefix="$prefix$i"
    cd $prefix
    nelm=$(grep NELM INCAR | awk -F= '{print $2}' | awk '{print $1, ""}' | head -1)
    esteps=$(tail -2 OSZICAR | head -1 | awk '{print $2, ""}')
    if [ $nelm -eq $esteps ]
    then
        anelm="NO"
    else
        anelm="YES"
        anelm_count=$(echo $anelm_count+1 | bc)
    fi
    ediff=$(grep "aborting loop because EDIFF is reached" OUTCAR | awk '{print $2, ""}')
    if [ $ediff == "aborting" ]
    then
        aediff="YES"
        aediff_count=$(echo $aediff_count+1 | bc)
    else
        aediff="NO"
    fi
    compcheck1=$(tail -1 OSZICAR | awk '{print $1, ""}')
    compcheck2=$(tail -10 OUTCAR | head -1 | awk '{print $1, ""}')
    if [ $compcheck1 == "1" ]
    then
        acomp1="YES"
        acomp1_count=$(echo $acomp1_count+1 | bc)
    else
        acomp1="NO"
    fi
    if [ $compcheck2 == "User" ]
    then
        acomp2="YES"
        acomp2_count=$(echo $acomp2_count+1 | bc)
        time_s=$(grep "Total CPU time used" OUTCAR | awk '{print $6}')
        time_hr=$(echo "scale=3;$time_s/3600" | bc)
        time_count=$(echo "scale=3;$time_count+$time_hr" | bc)
        time_list+=($time_hr)
        esteps_count=$(echo $esteps_count+$esteps | bc)
        step_list+=($esteps)
    else
        acomp2="NO"
        esteps=""
        time_hr=""
    fi
    cd ../
    echo "$prefix $anelm $aediff $acomp1 $acomp2 $esteps $time_hr" >> check.out
elif [ $length -eq 2 ]
then
    prefix="000"
    prefix="$prefix$i"
    cd $prefix
    nelm=$(grep NELM INCAR | awk -F= '{print $2}' | awk '{print $1, ""}' | head -1)
    esteps=$(tail -2 OSZICAR | head -1 | awk '{print $2, ""}')
    if [ $nelm -eq $esteps ]
    then
        anelm="NO"
    else
        anelm="YES"
        anelm_count=$(echo $anelm_count+1 | bc)
    fi
    ediff=$(grep "aborting loop because EDIFF is reached" OUTCAR | awk '{print $2, ""}')
    if [ $ediff == "aborting" ]
    then
        aediff="YES"
        aediff_count=$(echo $anelm_count+1 | bc)
    else
        aediff="NO"
    fi
    compcheck1=$(tail -1 OSZICAR | awk '{print $1, ""}')
    compcheck2=$(tail -10 OUTCAR | head -1 | awk '{print $1, ""}')
    if [ $compcheck1 == "1" ]
    then
        acomp1="YES"
        acomp1_count=$(echo $acomp1_count+1 | bc)
    else
        acomp1="NO"
    fi
    if [ $compcheck2 == "User" ]
    then
        acomp2="YES"
        acomp2_count=$(echo $acomp2_count+1 | bc)
        time_s=$(grep "Total CPU time used" OUTCAR | awk '{print $6}')
        time_hr=$(echo "scale=3;$time_s/3600" | bc)
        time_count=$(echo "scale=3;$time_count+$time_hr" | bc)
        time_list+=($time_hr)
        esteps_count=$(echo $esteps_count+$esteps | bc)
        step_list+=($esteps)
    else
        acomp2="NO"
        esteps=""
        time_hr=""
    fi
    cd ../
    echo "$prefix $anelm $aediff $acomp1 $acomp2 $esteps $time_hr" >> check.out
elif [ $length -eq 3 ]
then
    prefix="00"
    prefix="$prefix$i"
    cd $prefix
    nelm=$(grep NELM INCAR | awk -F= '{print $2}' | awk '{print $1, ""}' | head -1)
    esteps=$(tail -2 OSZICAR | head -1 | awk '{print $2, ""}')
    if [ $nelm -eq $esteps ]
    then
        anelm="NO"
    else
        anelm="YES"
        anelm_count=$(echo $anelm_count+1 | bc)
    fi
    ediff=$(grep "aborting loop because EDIFF is reached" OUTCAR | awk '{print $2, ""}')
    if [ $ediff == "aborting" ]
    then
        aediff="YES"
        aediff_count=$(echo $aediff_count+1 | bc)
    else
        aediff="NO"
    fi
    compcheck1=$(tail -1 OSZICAR | awk '{print $1, ""}')
    compcheck2=$(tail -10 OUTCAR | head -1 | awk '{print $1, ""}')
    if [ $compcheck1 == "1" ]
    then
        acomp1="YES"
        acomp1_count=$(echo $acomp1_count+1 | bc)
    else
        acomp1="NO"
    fi
    if [ $compcheck2 == "User" ]
    then
        acomp2="YES"
        acomp2_count=$(echo $acomp2_count+1 | bc)
        time_s=$(grep "Total CPU time used" OUTCAR | awk '{print $6}')
        time_hr=$(echo "scale=3;$time_s/3600" | bc)
        time_count=$(echo "scale=3;$time_count+$time_hr" | bc)
        time_list+=($time_hr)
        esteps_count=$(echo $esteps_count+$esteps | bc)
        step_list+=($esteps)
    else
        acomp2="NO"
        esteps=""
        time_hr=""
    fi
    cd ../
    echo "$prefix $anelm $aediff $acomp1 $acomp2 $esteps $time_hr" >> check.out
else
    echo "good luck with all that"
fi
done

#checking how many completed all tests successfully

completed=$anelm_count

if [ $anelm_count -gt $aediff_count ]
then
completed=$aediff_count
fi

if [ $aediff_count -gt $acomp1_count ]
then
completed=$acomp1_count
fi

if [ $acomp1_count -gt $acomp2_count ]
then
completed=$acomp2_count
fi

#calculating average electronic steps and time per completed job
esteps_ave=$(echo "scale=3;$esteps_count/$completed" | bc)
time_ave=$(echo "scale=3;$time_count/$completed" | bc)

#calculating st. dev in time and esteps

comp=$(echo $completed-1 | bc)
step_sq_tot=0
time_sq_tot=0

for j in $(seq 0 $comp) ; do
step_diff=$(echo "scale=3;${step_list[$j]}-$esteps_ave" | bc)
time_diff=$(echo "sacle=3;${time_list[$j]}-$time_ave" | bc)
step_sq=$(echo "scale=3;$step_diff^2" | bc)
time_sq=$(echo "scale=3;$time_diff^2" | bc)
step_sq_tot=$(echo "scale=3;$step_sq_tot+$step_sq" | bc)
time_sq_tot=$(echo "scale=3;$time_sq_tot+$time_sq" | bc)
done

step_div=$(echo "scale=3;$step_sq_tot/$comp" | bc)
time_div=$(echo "scale=3;$time_sq_tot/$comp" | bc)
step_std=$(echo "scale=3;sqrt($step_div)" | bc)
time_std=$(echo "scale=3;sqrt($time_div)" | bc)

echo "Tot/Ave $anelm_count $aediff_count $acomp1_count $acomp2_count $esteps_ave $time_ave" >> check.out

column -t check.out > check.temp && mv check.temp check.out

#percent complete
perc=$(echo "scale=2;100*$completed/$1" | bc)


echo "" >> check.out
echo "Ave. elec. steps:  $esteps_ave           Spread: $step_std" >> check.out
echo "Ave. time (hrs):   $time_ave            Spread: $time_std" >> check.out
echo "Percent completed: $perc %" >> check.out

echo "finished checking $1 directories, see check.out"
echo "$completed out of $1 jobs completed successfully without errors"
echo "Ave. elec. Steps:  $esteps_ave           Spread: $step_std"
echo "Ave. time (hrs):   $time_ave            Spread: $time_std"
echo "Percent completed: $perc %"
