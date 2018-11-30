#! /bin/bash

#Usage: put Sub name below; run ./makesubs_tiger.sh
#Run on SNI
#this script copies els subject t1 and dti in the proper folders and renames the files needed for our scripts
#run this in config folder (or whatever folder) where the subjlist file is
#make sure the subjlist.txt is in the form "XXX" where XXX is the subject ID #

#last run May 3 by TH

for sub in 21; do #xxchange subj id

#for sub in `cat subs.txt`; do

echo "***working on $sub***"

subname='tiger'$sub
dtdir='/share/iang/active/TIGER/Participant_Data/'$sub'-T1/anatomics/dti'
t1dir='/share/iang/active/TIGER/Participant_Data/'$sub'-T1/anatomics/t1w'
tigerdir='/share/iang/proc/TIGERanalysis/DTI/matproc'

cd $tigerdir
mkdir $subname
mkdir $subname'/raw'


cd $dtdir
cp *.bval $tigerdir'/'$subname'/raw/'$subname'.bval'
cp *.bvec $tigerdir'/'$subname'/raw/'$subname'.bvec'
cp DTI_2mm_b2000_60dir_raw.nii* $tigerdir'/'$subname'/raw/'$subname'.nii.gz'
cd $t1dir
cp Ax_FSPGR_BRAVO_raw.nii.gz $tigerdir'/'$subname'/'$subname'_t1.nii.gz'
cd $tigerdir
done
