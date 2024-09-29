addpath('/Users/xiyana/freesurfer/matlab')

%mask1: Left cerebral white matter = 2    
%mask3: Right cerebral white matter =  41  
%mask2: Left cerebral gray matter =   2 or 3  
%mask4: Right cerebral gray matter = 41 or 42 

keySet = {'N1','N2','N3','N4'};
valueSet = [2,3,41,42];
n_values = containers.Map(keySet,valueSet);

load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask1_f_matrix.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask2_f_matrix.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask3_f_matrix.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/mask4_f_matrix.mat')

mask1 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask1.nii.gz')
mask2 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask2.nii.gz')
mask3 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask3.nii.gz')
mask4 = MRIread('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask4.nii.gz')

[v1_new_mesh,f1_new_mesh] = get_new_mesh(mask1_f_matrix, mask1,n_values('N1'));
[v2_new_mesh,f2_new_mesh] = get_new_mesh(mask2_f_matrix,mask2,n_values('N2'));
[v3_new_mesh,f3_new_mesh] = get_new_mesh(mask3_f_matrix,mask3,n_values('N3'));
[v4_new_mesh,f4_new_mesh] = get_new_mesh(mask4_f_matrix,mask4,n_values('N4'));

write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask1_new_mesh_second.vtk', v1_new_mesh, f1_new_mesh-1)
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask2_new_mesh_second.vtk', v2_new_mesh, f2_new_mesh-1)
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask3_new_mesh_second.vtk', v3_new_mesh, f3_new_mesh-1)
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw2/mask/mask4_new_mesh_second.vtk', v4_new_mesh, f4_new_mesh-1)


function [mesh_new_v, mesh_new_f] = get_new_mesh(matrix,mask,level)
       
       keySet = {'v1','v2','v3'};
       valueSet = [1,2,3];
       M = containers.Map(keySet,valueSet);
       
       [bins,binsizes,f,v]=get_comp(matrix,mask,level);

       sort_sizes = sort(binsizes, 'descend');
       second_highest = sort_sizes(2) 

       second_highest_element = find(bins == second_highest);
      
       indices = ismember(f, second_highest_element);

       mesh_indices = find(ismember(indices,[1 1 1],'rows'));
       mesh_new = f(mesh_indices,:);
       mesh_new_f = zeros(size(mesh_new, 3));
       

       for i=1:length(mesh_new)
            
            vtx_s = mesh_new(i, :);
            mesh_new_f (i,M('v1')) = find(second_highest_element == vtx_s(M('v1')));
            mesh_new_f (i,M('v2')) = find(second_highest_element == vtx_s(M('v2')));
            mesh_new_f (i,M('v3')) = find(second_highest_element == vtx_s(M('v3')));
            
       end
       mesh_v = v(second_highest_element,:);
       mesh_new_v = create_a_surface(mesh_v,mask);
       
end

function [bins,binsizes,f,v]= get_comp(matrix,mask,level)
       [f,v] = isosurface(mask.vol, level/2);
       G=graph(matrix);
       [bins,binsizes] = conncomp(G);
end
   
function [v] = create_a_surface(v,mask)
    
    n = size(v, 1);
    v = [v-1, ones(n, 1)] * mask.vox2ras';
    v = v - [mask.c_r, mask.c_a, mask.c_s, 0];
    v = v(:, 1:3);

end