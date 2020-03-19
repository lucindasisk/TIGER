#! /bin/bash

#Usage: ./run_T1fit_TIGER.sh
#A pipenv with python 2.7 and nipype package installed is used to run this script

fp=/Volumes/group/proc/TIGERanalysis/qT1/subjDir
scpt=/Volumes/group/proc/TIGERanalysis/qT1/scripts

cd $fp
subs=$(ls)
for sub in $subs ; do
  pe1=$fp/$sub/raw/qt1_pe1.nii.gz
  pe0=$fp/$sub/raw/qt1_pe0.nii.gz

  #if running Lucas data, use --cal = 1
  #if running CNI ddata, use --cal = 2 or don't include --cal
  if [ -e $fp/$sub/qt1_T1fit_final.nii.gz ] ; then
    echo '** T1fit already computed for' $sub '**'
  else
    cd $scpt
    #python2.7 t1fit_unwarp_2.7.py --tr 3000 --ti 50 --cal 2 --pe1 $pe1 $pe0 $fp/$sub/
    echo '<><><> Attempting to run' $sub '<><><>'
    python old_t1fitter_scripts/t1fit_unwarp.py --tr 3000 --ti 50 --cal 2 --pe1 $pe1 $pe0 $fp/${sub}/
  fi

  cd $fp/$sub
  if [ -e *_t1.nii.gz ] ; then
    mv *_t1.nii.gz qt1_T1fit_final.nii.gz
    # echo '** Files already tarred for' $sub '**'
    # if [ -e *.tgz ] ; then
    #   rm *.tgz
    #   echo 'Tarring extra files'
    #   mv *_t1.nii.gz qt1_T1fit_final.nii.gz
    #   tar -cvzf t1fit_other.tgz _*
    #   mkdir $fp/delete
    #   mkdir $fp/$sub/${sub}_delete
    #   mv _* $fp/$sub/${sub}_delete
    #   mv $fp/$sub/${sub}_delete $fp/delete/
    #   echo 'Successfully completed' $sub
    # else
    #   echo 'T1fitter output exists, tarring extra files'
    #   mv *_t1.nii.gz qt1_T1fit_final.nii.gz
    #   tar -cvzf t1fit_other.tgz _*
    #   mkdir $fp/delete
    #   mkdir $fp/$sub/${sub}_delete
    #   mv _* $fp/$sub/${sub}_delete
    #   mv $fp/$sub/${sub}_delete $fp/delete/
    #   echo 'Successfully completed' $sub
    # fi
  elif [ -e *_t1.nii ] ; then
    mv *_t1.nii qt1_T1fit_final.nii
    gzip qt1_T1fit_final.nii
    # if [ -e *.tgz ] ; then
    #   rm *.tgz
    #   echo 'T1fitter output exists, tarring extra files'
    #   mv *_t1.nii qt1_T1fit_final.nii
    #   gzip qt1_T1fit_final.nii
    #   tar -cvzf t1fit_other.tgz _*
    #   mkdir $fp/delete
    #   mkdir $fp/$sub/${sub}_delete
    #   mv _* $fp/$sub/${sub}_delete
    #   mv $fp/$sub/${sub}_delete $fp/delete/
    #   echo 'Successfully completed' $sub
    # else
    #   echo 'T1fitter output exists, tarring extra files'
    #   mv *_t1.nii qt1_T1fit_final.nii
    #   gzip qt1_T1fit_final.nii
    #   tar -cvzf t1fit_other.tgz _*
    #   mkdir $fp/delete
    #   mkdir $fp/$sub/${sub}_delete
    #   mv _* $fp/$sub/${sub}_delete
    #   mv $fp/$sub/${sub}_delete $fp/delete/
    #   echo 'Successfully completed' $sub
    # fi
  else
    echo 'Could not find T1fitter output for' $sub
  fi
done
