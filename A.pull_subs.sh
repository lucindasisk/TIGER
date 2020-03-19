#! /bin/bash

rawfp=/Volumes/group/active/TIGER/TIGER-T1 #/Volumes/iang/TIGER_data/TIGER-T1
elsfp=/Volumes/group/active/ELS/ELS-T3 #/Volumes/iang/ELS_data/ELS-T3
destfp=/Volumes/group/proc/TIGERanalysis/qT1/subjDir
t1fp=/Volumes/group/proc/TIGERanalysis/DTI/TIGER-T1/matproc
elst1fp=/Volumes/iang/ELS_data/ELS_DTI_Analysis/ELS_T3/matproc
mrsfp=/Volumes/group/proc/TIGERanalysis/MRS/voxel_mask_code/mask_data
log=$destfp/../No_qt1.txt

cd $rawfp
subs=$(ls)

for sub in $subs ; do
  if [ -e $sub/qt1_pe0.nii.gz ] ; then
    if [ -e $sub/qt1_pe1.nii.gz ] ; then
      if [ -e $destfp/${sub}/raw/qt1_pe1.nii.gz ] ; then
        echo '--- qT1 already copied for' $sub '---'
      else
        mkdir $destfp/${sub}
        mkdir $destfp/${sub}/raw
        cp $rawfp/${sub}/qt1_pe1.nii.gz $destfp/${sub}/raw/.
        cp $rawfp/${sub}/qt1_pe0.nii.gz $destfp/${sub}/raw/.
        echo '<><><> qT1 copied over to proc/qT1/subjDir for' $sub '<><><>'
      fi
    else
      echo '*** qT1 pe1 not found for' $sub '***'
    fi
  else
    echo '*** qT1 pe0 not found for' $sub '***'
  fi
  if [ -e $t1fp/${sub}/*_t1_acpc.nii.gz ] ; then
    if [ -d $destfp/${sub} ] ; then
      if [ -e $destfp/${sub}/raw/T1_acpc.nii.gz ] ; then
        echo '--- ACPC aligned T1 already copied for' $sub '---'
      else
        cp $t1fp/${sub}/*_t1_acpc.nii.gz $destfp/${sub}/raw/T1_acpc.nii.gz
        echo '<><><> Copied T1w ACPC aligned for' $sub '<><><>'
      fi
    else
      echo 'Analysis folder does not exist for '$sub
    fi
  else
    echo '*** ACPC aligned T1w does not exist for' $sub '***'
  fi
  
  if [ -d $destfp/${sub} ] ; then
    if [ -e $destfp/${sub}/T1_MRS.nii.gz ] ; then
      echo '--- MRS aligned T1 already copied for' $sub '---'
    else
      cp $mrsfp/${sub}_dACC*t1w.nii.gz $destfp/${sub}/T1_MRS.nii.gz
      echo '<><><> Copied MRS Aligned T1w for' $sub '<><><>'
    fi
    if [ -e $destfp/${sub}/MRS_Voxel_Mask.nii.gz ] ; then
      echo '--- MRS aligned T1 already copied for' $sub '---'
    else
      cp $mrsfp/${sub}_dACC*mask.nii.gz $destfp/${sub}/MRS_Voxel_Mask.nii.gz
      echo '<><><> Copied MRS Aligned T1w for' $sub '<><><>'
    fi
  else
    echo 'qT1 folder doesnt exist for' $sub
  fi
done

cd $elsfp
subs=$(ls)

for sub in $subs ; do
  if [ -e $sub/qt1_pe0.nii.gz ] ; then
    if [ -e $sub/qt1_pe1.nii.gz ] ; then
      if [ -e $destfp/${sub}/raw/qt1_pe1.nii.gz ] ; then
        echo '--- qT1 already copied for' $sub '---'
      else
        mkdir $destfp/${sub}
        mkdir $destfp/${sub}/raw
        cp $elsfp/${sub}/qt1_pe1.nii.gz $destfp/${sub}/raw/.
        cp $elsfp/${sub}/qt1_pe0.nii.gz $destfp/${sub}/raw/.
        echo '<><><> qT1 copied over to proc/qT1/subjDir for' $sub '<><><>'
      fi
    else
      echo '*** qT1 pe1 not found for' $sub '***'
    fi
  else
    echo '*** qT1 pe0 not found for' $sub '***'
  fi
  if [ -e $elst1fp/els${sub}/*_t1_acpc.nii.gz ] ; then
    if [ -d $destfp/${sub} ] ; then
      if [ -e $destfp/${sub}/raw/T1_acpc.nii.gz ] ; then
        echo '--- ACPC aligned T1 already copied for' $sub '---'
      else
        cp $elst1fp/els${sub}/*_t1_acpc.nii.gz $destfp/${sub}/raw/T1_acpc.nii.gz
        echo '<><><> Copied T1w ACPC aligned for' $sub '<><><>'
      fi
    else
      echo 'Analysis folder does not exist for '$sub
    fi
  else
    echo '*** ACPC aligned T1w does not exist for' $sub '***'
  fi
  if [ -d $destfp/${sub} ] ; then
    if [ -e $destfp/${sub}/T1_MRS.nii.gz ] ; then
      echo '--- MRS aligned T1 already copied for' $sub '---'
    else
      cp $mrsfp/${sub}_dACC*t1w.nii.gz $destfp/${sub}/T1_MRS.nii.gz
      echo '<><><> Copied MRS Aligned T1w for' $sub '<><><>'
    fi
    if [ -e $destfp/${sub}/MRS_Voxel_Mask.nii.gz ] ; then
      echo '--- MRS aligned T1 already copied for' $sub '---'
    else
      cp $mrsfp/${sub}_dACC*mask.nii.gz $destfp/${sub}/MRS_Voxel_Mask.nii.gz
      echo '<><><> Copied MRS Aligned T1w for' $sub '<><><>'
    fi
  else
    echo 'qT1 folder doesnt exist for' $sub
  fi
done
