
# coding: utf-8

# In[1]:


import pandas as pd
from os.path import expanduser, join
from glob import glob
import pandas as pd
from datetime import date
from numpy import where
today = str(date.today())
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)


# In[2]:


home = '/Volumes/group/proc/TIGERanalysis/qT1'
dest = join(home, 'Results/Raw_VoxelData')
datadir = join(home, '/DataDir/2_Extracted_Stats')
flist = glob(datadir + '/*/ROI_voxel-*')


# In[3]:


def fix_files(file1):
    inf = file1.replace('/Volumes/group/proc/TIGERanalysis/qT1/DataDir_qT1_FLUXRUN/2_Extracted_Stats/_subject_id_',
                        '').replace('/ROI_voxel-contrasts', '').replace('.txt', '')
    file1 = pd.read_csv(file1, header=None, sep='  ')
    file = file1.transpose().rename(
        columns={0: 'L/R', 1: 'A/P', 2: 'S/I', 3: 'Voxel Contrast'})
    file['R1'] = 1 / file['Voxel Contrast']
    outfile = file.to_csv(dest + '/{}.csv'.format(inf), index=False)
    return outfile


for file1 in flist:
    fix_files(file1)


# In[6]:


lcclist = glob(dest + '/*_LeftCC.csv')
rcclist = glob(dest + '/*_RightCC.csv')
lunclist = glob(dest + '/*_LeftUncinate.csv')
runclist = glob(dest + '/*_RightUncinate.csv')
llist = [lcclist, rcclist, lunclist, runclist]


# In[8]:


def compute_mean(file):
    v1 = pd.read_csv(file, header=0)
    sub = file.replace(dest + '/', '').replace('.csv', '')
    mean = v1['Voxel Contrast'].mean()
    v2 = [sub, mean]
    means.append(v2)


means = []
for file in lcclist:
    compute_mean(file)


lccfile = pd.DataFrame(means, columns=['Left_CC', 'LCC_VoxelConMean'])
lccid = []
for x in lccfile['Left_CC']:
    y = str(x).replace('_LeftCC', '')
    lccid.append(y)
lccfile['ID'] = lccid
lccfile['LCC_R1'] = 1 / lccfile['LCC_VoxelConMean']

means = []
for file in rcclist:
    compute_mean(file)


rccfile = pd.DataFrame(means, columns=['Right_CC', 'RCC_VoxelConMean'])
rccid = []
for x in rccfile['Right_CC']:
    y = str(x).replace('_RightCC', '')
    rccid.append(y)
rccfile['ID'] = rccid
rccfile['RCC_R1'] = 1 / rccfile['RCC_VoxelConMean']

means = []
for file in lunclist:
    compute_mean(file)


luncfile = pd.DataFrame(means, columns=['Left_Unc', 'LUF_VoxelConMean'])
luncid = []
for x in luncfile['Left_Unc']:
    y = str(x).replace('_LeftUncinate', '')
    luncid.append(y)
luncfile['ID'] = luncid
luncfile['LUF_R1'] = 1 / luncfile['LUF_VoxelConMean']

means = []
r1 = []
for file in runclist:
    compute_mean(file)


runcfile = pd.DataFrame(means, columns=['Right_Unc', 'RUF_VoxelConMean'])
runcid = []
for x in runcfile['Right_Unc']:
    y = str(x).replace('_RightUncinate', '')
    runcid.append(y)
runcfile['ID'] = runcid
runcfile['RUF_R1'] = 1 / runcfile['RUF_VoxelConMean']


# In[13]:


m1 = pd.merge(lccfile, rccfile, how='outer', on='ID')
m2 = pd.merge(m1, luncfile, how='outer', on='ID')
m3 = pd.merge(m2, runcfile, how='outer', on='ID')

master1 = m3.drop(['Right_CC', 'Left_CC', 'Right_Unc', 'Left_Unc'], axis=1)
cols = master1.columns.tolist()
cols_fixed = ['ID', 'LCC_VoxelConMean', 'LCC_R1', 'RCC_VoxelConMean',
              'RCC_R1', 'LUF_VoxelConMean', 'LUF_R1', 'RUF_VoxelConMean', 'RUF_R1']
master = master1[cols_fixed].sort_values(by='ID')


# In[16]:


master.to_csv(home + '/Results/qT1_output_' + today + '.csv', index=False)
