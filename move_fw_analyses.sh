#! /bin/bash

sub=$1
home=~/Downloads/qt1/${1}
dest=~/Box/LS_folders/TIGER_qT1_SOBP

if [ -d ${home} ] ; then
  mkdir $dest/${sub}
  cd $home
  tar -xvf ${home}/analysis*.tar *_t1fit_t1.nii.gz
  mv ${home}/*/*/*/output/*_t1.nii.gz $dest/${sub}/fw_qT1_t1fit_final.nii.gz
else
  echo 'Error: Could not find '$sub
fi
