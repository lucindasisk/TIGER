#! /bin/bash

#Usage: ./run_T1fit_TIGER.sh
#A pipenv with python 2.7 and nipype package installed is used to run this script

fp=/Volumes/group/proc/TIGERanalysis/qT1/subjDir
adir=/Volumes/iang/TIGER_data/TIGER_DTI_Analysis/TIGER-T1/matproc
bdir=/Volumes/iang/TIGER_data/TIGER_DTI_Analysis/TIGER-T2/matproc
edir=/Volumes/iang/ELS_data/ELS_DTI_Analysis/ELS_T3/matproc
cdir=/Volumes/group/proc/ELSanalysis/DTIAnalysis/ELS_T3/matproc
ddir=/Volumes/iang/ELS_data/ELS_DTI_Analysis/ELS_T4/matproc

cd $fp
subs=$(ls)

for sub in 112-T4 164-T3 176-T3 188-T3 307-T3 066-T3 072-T4 ; do
  mkdir $fp/$sub
  for roi in Callosum_Forceps_Major.nii.gz Callosum_Forceps_Minor.nii.gz Right_Uncinate.nii.gz Left_Uncinate.nii.gz\
  Left_Cingulum_Cingulate.nii.gz Right_Cingulum_Cingulate.nii.gz ; do
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
    elif [ -e $cdir/els$sub/dti60trilin/ROIs/$roi ] ; then
      echo 'Copying' $roi 'for' $sub
      cp $cdir/els$sub/dti60trilin/ROIs/$roi $fp/${sub}/$roi
    elif [ -e $ddir/els$sub/dti60trilin/ROIs/$roi ] ; then
      echo 'Copying' $roi 'for' $sub
      cp $ddir/els$sub/dti60trilin/ROIs/$roi $fp/${sub}/$roi
    else
      echo 'Could not find '$roi' for' $sub
      echo ${roi}': '${sub} >> '/Volumes/group/proc/TIGERanalysis/qT1/scripts/NeedsDtiMasks.txt'
    fi
  done
done
