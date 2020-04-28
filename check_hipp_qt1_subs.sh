#! /bin/bash

#Check subejcts that have not yet beenn run

fp='/Volumes/group/proc/TIGERanalysis/qT1/data/1_check_alignment'
scpt='/Volumes/group/proc/TIGERanalysis/qT1/scripts'
today=$(date '+%m.%d.%y')

cd $fp
subs=$(ls)

for sub in $subs ; do
  if [  -e  $fp/${sub}/right_caudate.nii.gz ] ; then
    echo 'Subcortical segmentations extracted for' $sub
  else
    echo $sub 'needs to be rerun'
    echo $sub >> $scpt/qt1_unfinishedSubcort_${today}.txt
  fi
done
