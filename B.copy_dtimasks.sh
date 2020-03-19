#! /bin/bash

#Usage: ./run_T1fit_TIGER.sh
#A pipenv with python 2.7 and nipype package installed is used to run this script

fp=/Volumes/group/proc/TIGERanalysis/qT1/subjDir
adir=/Volumes/iang/TIGER_data/TIGER_DTI_Analysis/TIGER-T1/matproc
bdir=/Volumes/iang/TIGER_data/TIGER_DTI_Analysis/TIGER-T2/matproc
edir=/Volumes/iang/ELS_data/ELS_DTI_Analysis/ELS_T3/matproc

cd $fp
subs=$(ls)

for sub in $subs; do
  for roi in Left_Uncinate.nii.gz Right_Uncinate.nii.gz Right_Cingulum_Cingulate.nii.gz Left_Cingulum_Cingulate.nii.gz; do
    if [ -e $fp/${sub}/$roi ] ; then
      echo 'Already copied '$roi' for' $sub
    elif [ -e $adir/$sub/dti60trilin/ROIs/$roi ] ; then
      echo 'Copying' $roi 'for' $sub
      cp $adir/$sub/dti60trilin/ROIs/$roi $fp/${sub}/$roi
    elif [ -e $bdir/$sub/dti60trilin/ROIs/$roi ] ; then
      echo 'Copying' $roi 'for' $sub
      cp $bdir/$sub/dti60trilin/ROIs/$roi $fp/${sub}/$roi
    elif [ -e $edir/els$sub/dti60trilin/ROIs/$roi ] ; then
      echo 'Copying' $roi 'for' $sub
      cp $edir/els$sub/dti60trilin/ROIs/$roi $fp/${sub}/$roi
    else
      echo 'Could not find '$roi' for' $sub
      echo ${roi}': '${sub} >> '/Volumes/group/proc/TIGERanalysis/qT1/scripts/NeedsDtiMasks.txt'
    fi
  done
done
