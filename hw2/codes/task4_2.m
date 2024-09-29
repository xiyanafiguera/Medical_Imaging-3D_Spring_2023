addpath('/Users/xiyana/freesurfer/matlab')

%mask1: Left cerebral white matter = 2    
%mask3: Right cerebral white matter =  41  
%mask2: Left cerebral gray matter =   2 or 3  
%mask4: Right cerebral gray matter = 41 or 42 

load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/v1_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/v2_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/v3_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/v4_new_mesh.mat')

load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/f1_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/f2_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/f3_new_mesh.mat')
load('/Users/xiyana/Downloads/med-course/homeworks/hw2/mat/f4_new_mesh.mat')

ec1=get_Euler_characteristic(f1_new_mesh,v1_new_mesh)
ec2=get_Euler_characteristic(f2_new_mesh,v2_new_mesh)
ec3=get_Euler_characteristic(f3_new_mesh,v3_new_mesh)
ec4=get_Euler_characteristic(f4_new_mesh,v4_new_mesh)


genus1 =(2-ec1)/2;
genus2 = (2-ec2)/2;
genus3 = (2-ec3)/2;
genus4 = (2-ec4)/2;

disp("left cerebral white matter euler characteristic:"+ec1)
disp("left cerebral white matter genus number:"+genus1)

disp("left cerebral gray matter euler characteristic:"+ec2)
disp("left cerebral gray matter genus number:"+genus2)

disp("right cerebral white matter euler characteristic:"+ec3)
disp("right cerebral white matter genus number:"+genus3)

disp("right cerebral gray matter euler characteristic:"+ec4)
disp("right cerebral gray matter genus number:"+genus4)


function [ec] = get_Euler_characteristic(f,v)
    matrix = create_sparse_matrix(f);
    m = find(matrix~=0);
    n = length(m);
    E = n / 2;
    [V,a] = size(v);
    [F,a] = size(f);
    ec = V-E+F;
    
end


function [mask_f_matrix] = create_sparse_matrix(f)
 
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

    n = max(f_list, [], 'all');
    mask_f_matrix = sparse(f_list(:,1), f_list(:,2), 1, n, n);
    
end