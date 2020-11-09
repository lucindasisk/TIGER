#! /bin/bash

home='/Users/lucindasisk/Documents/qT1'
data='/Users/lucindasisk/Documents/qT1/data/1_check_alignment'
tracts='/Users/lucindasisk/Documents/qT1/subjDir'
cd $data
#subs=$(ls)
#subs=( 021-T3 097-T3 109-T3 124-T3 130-T3 145-T3 147-T3 159-T3 162-T3 168-T3 170-T3 171-T3 178-T3 182-T3 186-T3 187-T3 191-T3 202-T3 205-T3 215-T3 134x-T3 )
subs=( 159x-T3 02-T2 07-T2 09-T2 28-T2 34-T2 )

for i in ${subs[@]}; do
  fsleyes ${data}/${i}/registered_qT1_T1acpc.nii.gz --name ${i}_qt1_data ${data}/${i}/T1_acpc_bet.nii.gz --name ${i}_T1_acpc ${tracts}/${i}/Left_Uncinate.nii.gz -cm red-yellow -n "Left_Uncinate" ${tracts}/${i}/Right_Uncinate.nii.gz -cm cool_r -n "Right_Uncinate" ${tracts}/${i}/Left_Cingulum_Cingulate.nii.gz -cm cool -n "Left_CC" ${tracts}/${i}/Right_Cingulum_Cingulate.nii.gz -cm blue -n "Right_CC" ${tracts}/${i}/Left_Corticospinal.nii.gz -cm green -n "Left_CST" ${tracts}/${i}/Right_Corticospinal.nii.gz -cm red -n "Right_CST"
done
