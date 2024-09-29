addpath('/Users/xiyana/freesurfer/matlab')

%mask1: Left cerebral white matter = 2    
%mask3: Right cerebral white matter =  41  
%mask2: Left cerebral gray matter =   2 or 3  
%mask4: Right cerebral gray matter = 41 or 42 

keySet = {'N1','N2','N3','N4'};
valueSet = [2,3,41,42];
n_values = containers.Map(keySet,valueSet);

mask1 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask1.nii.gz')
mask2 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask2.nii.gz')
mask3 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask3.nii.gz')
mask4 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask4.nii.gz')


[f1,v1] = create_a_surface(mask1,n_values('N1'))
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask1.vtk', v1, f1-1)

[f2,v2] = create_a_surface(mask2,n_values('N2'))
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask2.vtk', v2, f2-1)

[f3,v3] = create_a_surface(mask3,n_values('N3'))
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask3.vtk', v3, f3-1)

[f4,v4] = create_a_surface(mask4,n_values('N4'))
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask4.vtk', v4, f4-1)


function [f,v] = create_a_surface(mask,level)
    
    [f,v]=isosurface(mask.vol, level/2);
    n = size(v, 1);
    v = [v-1, ones(n, 1)] * mask.vox2ras';
    v = v - [mask.c_r, mask.c_a, mask.c_s, 0];
    v = v(:, 1:3);
end
