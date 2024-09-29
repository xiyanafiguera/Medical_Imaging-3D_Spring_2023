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

[f1,v1]=isosurface(mask1.vol, n_values('N1')/2);
[f2,v2]=isosurface(mask2.vol, n_values('N2')/2);
[f3,v3]=isosurface(mask3.vol, n_values('N3')/2);
[f4,v4]=isosurface(mask4.vol, n_values('N4')/2);

mask1_f_matrix = create_sparse_matrix(f1);
mask2_f_matrix = create_sparse_matrix(f2);
mask3_f_matrix = create_sparse_matrix(f3);
mask4_f_matrix = create_sparse_matrix(f4);

save('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask1_f_matrix.mat', 'mask1_f_matrix')
save('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask2_f_matrix.mat', 'mask2_f_matrix')
save('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask3_f_matrix.mat', 'mask3_f_matrix')
save('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask4_f_matrix.mat', 'mask4_f_matrix')


function [mask_f_matrix] = create_sparse_matrix(f)
    
    %task 3-1

    len = size(f, 1);
    f_list = zeros(len * 6, 2);
    
    for i=1:len
       
        vtx = f(i, :);
        f_list((i-1)*6+1, :) = [vtx(1), vtx(2)];
        f_list((i-1)*6+2, :) = [vtx(2), vtx(3)];
        f_list((i-1)*6+3, :) = [vtx(3), vtx(1)];
        f_list((i-1)*6+4, :) = [vtx(2), vtx(1)];
        f_list((i-1)*6+5, :) = [vtx(3), vtx(2)];
        f_list((i-1)*6+6, :) = [vtx(1), vtx(3)];
    end
    

    %Task 3-2

    n = max(f_list, [], 'all');
    mask_f_matrix = sparse(f_list(:,1), f_list(:,2), 1, n, n);
    
end

