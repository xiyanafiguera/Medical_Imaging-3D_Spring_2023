addpath('/Users/xiyana/freesurfer/matlab')
mri = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/ribbon.mgz')

%mask1: Left cerebral white matter = 2    
%mask3: Right cerebral white matter =  41  
%mask2: Left cerebral gray matter =   2 or 3  
%mask4: Right cerebral gray matter = 41 or 42 

raw = mri.vol
mask1 = mri 
mask2 = mri
mask3 = mri
mask4 = mri

temp1 = mri
temp1.vol = raw==2
mask1.vol = mask1.vol.*temp1.vol

temp3 = mri
temp3.vol = raw==41
mask3.vol = mask3.vol.*temp3.vol

temp2 = mri
temp2.vol = raw==3
mask2.vol = mask1.vol + (mask2.vol.*temp2.vol)

temp4 = mri
temp4.vol = raw==42
mask4.vol = mask3.vol + (mask4.vol.*temp4.vol) 


MRIwrite(mask1,'/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask1.nii.gz','uchar')
MRIwrite(mask2,'/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask2.nii.gz','uchar')
MRIwrite(mask3,'/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask3.nii.gz','uchar')
MRIwrite(mask4,'/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask4.nii.gz','uchar')
