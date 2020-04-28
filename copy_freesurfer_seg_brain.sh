#! /bin/bash

fp='/Volumes/group/proc/TIGERanalysis/qT1/subjDir'
fsdir='/Volumes/group/proc/TIGERanalysis/TIGER_FreeSurfer/TIGER_FS_subjDir'
scpt='/Volumes/group/proc/TIGERanalysis/qT1/scripts'
today=$(date '+%m.%d.%y')

cd $fp
subs=$(ls)

for sub in $subs ; do
  #Check if parcellation exists; convert and copy if not
  if [ -e $fp/${sub}/aparc.a2009s+aseg.nii.gz ] ; then
    echo '* Seg brain already converted and copied for' $sub
  else
    if [ -e $fsdir/${sub}/mri/aparc.a2009s+aseg.mgz ] ; then
      echo 'Copying segmentation for' $sub
      mri_convert $fsdir/${sub}/mri/aparc.a2009s+aseg.mgz $fsdir/${sub}/mri/aparc.a2009s+aseg.nii.gz
      cp $fsdir/${sub}/mri/aparc.a2009s+aseg.nii.gz $fp/${sub}/aparc.a2009s+aseg.nii.gz
    else
      echo 'Segmentation not found for' $sub
    fi
  fi

  #Check if freesurfer brain exists; convert and copy if not
  if [ -e $fp/${sub}/freesurfer_brain.nii.gz ] ; then
    echo '* FS brain already converted and copied for' $sub
  else
    if [ -e $fsdir/${sub}/mri/brain.mgz ] ; then
      echo 'Copying brain for' $sub
      mri_convert $fsdir/${sub}/mri/brain.mgz $fsdir/${sub}/mri/brain.nii.gz
      cp $fsdir/${sub}/mri/brain.nii.gz $fp/${sub}/freesurfer_brain.nii.gz
    else
      echo 'Freesurfer brain not found for' $sub
    fi
  fi

  #Check if els parcellation exists; convert and copy if not
  if [ -e $fp/${sub}/aparc.a2009s+aseg.nii.gz ] ; then
    echo '* ELS FS seg already converted and copied for' $sub
  else
    if [ -e $fsdir/els${sub}/mri/aparc.a2009s+aseg.mgz ] ; then
      echo 'Copying segmentation for' $sub
      mri_convert $fsdir/els${sub}/mri/aparc.a2009s+aseg.mgz $fsdir/els${sub}/mri/aparc.a2009s+aseg.nii.gz
      cp $fsdir/els${sub}/mri/aparc.a2009s+aseg.nii.gz $fp/${sub}/aparc.a2009s+aseg.nii.gz
    else
      echo 'Segmentation not found for' $sub
    fi
  fi

  #Check if els freesurfer brain exists; convert and copy if not
  if [ -e $fp/${sub}/freesurfer_brain.nii.gz ] ; then
    echo '* ELS FS brain already converted and copied for' $sub
  else
    if [ -e $fsdir/els${sub}/mri/brain.mgz ] ; then
      echo 'Copying brain for' $sub
      mri_convert $fsdir/els${sub}/mri/brain.mgz $fsdir/els${sub}/mri/brain.nii.gz
      cp $fsdir/els${sub}/mri/brain.nii.gz $fp/${sub}/freesurfer_brain.nii.gz
    else
      echo 'Freesurfer brain not found for' $sub
    fi
  fi
done
