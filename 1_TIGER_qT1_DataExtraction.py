#!/usr/bin/env python
# coding: utf-8

# In[3]:


from nipype.interfaces.io import DataSink, SelectFiles, DataGrabber
from nipype.interfaces.utility import IdentityInterface, Function
from nipype.pipeline.engine import Node, Workflow, JoinNode, MapNode
from nipype.interfaces import fsl
from nipype.interfaces import brainsuite
from nipype.interfaces.io import SelectFiles, DataSink, DataGrabber
from shutil import copyfile
import pandas as pd
from glob import glob
from os.path import abspath, expanduser, join
from os import chdir, remove, getcwd
from nipype import config, logging
from datetime import date
today = str(date.today())
config.enable_debug_mode()


# In[8]:


# Set variables
# subject_list = ['02-T2', '06-T1', '07-T2','08-T1', '09-T2', '10-T1', '11-T1', '12-T1', '13-T1', '15-T1', '16-T1', '17-T1',
#                 '18-T1', '19-T1', '20-T1', '21-T1', '22-T1', '23-T1', '24-T1', '29-T1', '30-T1', '31-T1', '32-T1',
#                 '35-T1', '36-T1', '37-T1', '38-T1', '40-T1', '102-T1', '103-T1', '104-T1', '105-T1', '106-T1', '107-T1', '108-T1', '109-T1',
#                 '110-T1', '111-T1']

# subject_list = ['08-T1']#, '20-T1','22-T1','29-T1','31-T1','35-T1']

home = '/Volumes/group/proc/TIGERanalysis/qT1'
fpath = join(home, 'subjDir')
workflow_dir = join(home, 'workflow')
data_dir = join(home, 'data')

subject_list = pd.read_csv(
    home + '/sublist_new.txt', sep=' ', header=None).iloc[:, 0]
subject_list


# In[3]:


# Setup Datasink, Infosource, Selectfiles

datasink = Node(DataSink(base_directory=data_dir),
                name='datasink')

# Set infosource iterables
infosource = Node(IdentityInterface(fields=['subject_id']),
                  name="infosource")
infosource.iterables = [('subject_id', subject_list)]

# SelectFiles
template = dict(t1=fpath + '/{subject_id}/raw/T1_acpc.nii.gz',
                qt1=fpath + '/{subject_id}/qt1_T1fit_final.nii.gz')

sf = Node(SelectFiles(template,
                      base_directory=fpath),
          name='sf')


# In[4]:


# Skullstrip T1w image
stripT1 = Node(fsl.BET(out_file='T1_acpc_bet.nii.gz'),
               name='stripT1')


# In[5]:

fslroi = Node(fsl.ExtractROI(t_min=0,
                             t_size=1,
                             roi_file='qt1_t1fit_extracted_vol.nii.gz', output_type='NIFTI_GZ'),
              name='fslroi')


reorient = Node(fsl.Reorient2Std(out_file='reoriented_qT1.nii.gz',
                                 output_type='NIFTI_GZ'),
                name='reorient')


# In[6]:


# Register qT1 to T1w
register_qt1 = Node(fsl.FLIRT(out_file='registered_qT1.nii.gz',
                              out_matrix_file='flirt_transform_qt1.mat'),
                    name='register_qt1')


# In[7]:


# Extract voxel values from qT1 beneath overlaid mask - Left Uncinate
get_voxLUF = Node(fsl.ImageMeants(show_all=True,
                                  out_file='ROI_voxel-contrasts_LeftUncinate.txt'),
                  name='get_voxLUF')


# In[8]:


# Extract voxel values from qT1 beneath overlaid mask - Left Uncinate
get_voxLCC = Node(fsl.ImageMeants(show_all=True,
                                  out_file='ROI_voxel-contrasts_LeftCC.txt'),
                  name='get_voxLCC')


# In[9]:


# #Extract voxel values from qT1 beneath overlaid mask - Left dAcc MRS Voxel
# get_voxLMRS = Node(fsl.ImageMeants(show_all = True,
#                                out_file = 'ROI_voxel-contrasts_LeftdACC_Voxel.txt'),
#                name = 'get_voxLMRS')


# In[10]:


# Extract voxel values from qT1 beneath overlaid mask - Right Uncinate
get_voxRUF = Node(fsl.ImageMeants(show_all=True,
                                  out_file='ROI_voxel-contrasts_RightUncinate.txt'),
                  name='get_voxRUF')


# In[11]:


# Extract voxel values from qT1 beneath overlaid mask - Right Uncinate
get_voxRCC = Node(fsl.ImageMeants(show_all=True,
                                  out_file='ROI_voxel-contrasts_RightCC.txt'),
                  name='get_voxRCC')


# In[12]:


# #Extract voxel values from qT1 beneath overlaid mask - Right dAcc MRS Voxel
# get_voxRMRS = Node(fsl.ImageMeants(show_all = True,
#                                out_file = 'ROI_voxel-contrasts_RightdACC_Voxel.txt'),
#                name = 'get_voxRMRS')


# In[15]:


qt1proc_flow = Workflow(name='qt1proc_flow')
qt1proc_flow.connect([(infosource, sf, [('subject_id', 'subject_id')]),
                      (sf, stripT1, [('t1', 'in_file')]),
                      (stripT1, datasink, [('out_file', '1_check_alignment')]),
                      (sf, fslroi, [('qt1', 'in_file')]),
                      (fslroi, reorient, [('roi_file', 'in_file')]),
                      (reorient, datasink, [
                       ('out_file', '1_check_alignment.@par')]),
                      (reorient, register_qt1, [('out_file', 'in_file')]),
                      (stripT1, register_qt1, [('out_file', 'reference')]),
                      (register_qt1, datasink, [
                       ('out_file', '1_check_alignment.@par.@par')])
                      ])

qt1proc_flow.base_dir = workflow_dir
qt1proc_flow.write_graph(graph2use='flat')
preproc = qt1proc_flow.run('MultiProc', plugin_args={'n_procs': 4})


# In[16]:


# SelectFiles
template2 = dict(qt1r=data_dir + '/1_check_alignment/_subject_id_{subject_id}/registered_qT1.nii.gz',
                 unc_maskL=fpath + '/{subject_id}/Left_Uncinate.nii.gz',
                 unc_maskR=fpath + '/{subject_id}/Right_Uncinate.nii.gz',
                 cc_maskL=fpath +
                 '/{subject_id}/Left_Cingulum_Cingulate.nii.gz',
                 cc_maskR=fpath + '/{subject_id}/Right_Cingulum_Cingulate.nii.gz')

#
#             bval=fpath+'/{subject_id}/dti.bval',
#             bvec=fpath+'/{subject_id}/dti.bvec'

sf2 = Node(SelectFiles(template2,
                       base_directory=fpath),
           name='sf2')


# In[17]:


get_stats = Workflow(name='get_stats')
get_stats.connect([(infosource, sf2, [('subject_id', 'subject_id')]),
                   (sf2, get_voxLUF, [('qt1r', 'in_file')]),
                   (sf2, get_voxLUF, [('unc_maskL', 'mask')]),
                   (get_voxLUF, datasink, [('out_file', '2_Extracted_Stats')]),
                   (sf2, get_voxLCC, [('qt1r', 'in_file')]),
                   (sf2, get_voxLCC, [('cc_maskL', 'mask')]),
                   (get_voxLCC, datasink, [
                    ('out_file', '2_Extracted_Stats.@par')]),
                   (sf2, get_voxRUF, [('qt1r', 'in_file')]),
                   (sf2, get_voxRUF, [('unc_maskR', 'mask')]),
                   (get_voxRUF, datasink, [
                    ('out_file', '2_Extracted_Stats.@par.@par')]),
                   (sf2, get_voxRCC, [('qt1r', 'in_file')]),
                   (sf2, get_voxRCC, [('cc_maskR', 'mask')]),
                   (get_voxRCC, datasink, [
                    ('out_file', '2_Extracted_Stats.@par.@par.@par')])
                   ])
get_stats.base_dir = workflow_dir
get_stats.write_graph(graph2use='flat')
preproc = get_stats.run('MultiProc', plugin_args={'n_procs': 4})


# In[ ]:


# In[ ]:
