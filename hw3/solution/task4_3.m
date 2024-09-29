
clc;
clear;

%%%%%%%%%%%% Task 4-1 %%%%%%%%%%%%%%%%%%%%

% Load sphere
[v, f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.sphere.vtk');

% Define range of degree for use in task 4-3 
max_lenghts = [10,20,40];

% Define matrix vector to save harmonic bases matrices
matrixVector = cell(1, 3);

%Define loop to generate harmonic base at degree 10, 20 and 40
for i=1:length(max_lenghts)

    % Define degree of base
    max_l = max_lenghts(i);

    % Define number of bases
    number_bs = (max_l+1)^2;

    % Define matrix to store harmonic bases
    harmonic_bs = zeros(size(v,1), number_bs);
    
    % Define loop to iterate from 0 to degree max_l
    for l = 0:max_l
        
        % Generate harmonic basis at degree l
        h = spharm_real(v, l);

        % Calculate the base index
        base_idx = l^2 + (1:2*l+1);

        % Save the harmonic base
        harmonic_bs(:, base_idx) = h;
    end
    
    % Save the harmonic bases at degree 10, 20 and 40
    matrixVector{i} = harmonic_bs;
end 




%%%%%%% task 4-2
clear v;
clear f;

% Load mean curvate 
H = load('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.H.txt');

% Load the overlayed input mesh 
[v,f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/lh.white.H.vtk');

% Define a vector to store coefficient matrices
coefficientsVector = cell(1, 3);

% Define loop to obtain coefficients at degree 10, 20 and 40
for i=1:length(matrixVector)
    
    % Get the stored harmonic bases at degree 10, 20 and 40
    harmonic_bs = matrixVector{i};

    % Solve linear system 
    coefficient = harmonic_bs \ [v,H];
    
    % Save coefficients
    coefficientsVector{i} = coefficient;
    
    % Clear the coefficient variable just in case
    clear coefficient;
    
end

%%%%%% Task 4-3 %%%%%%%%%%
clear H;
clear v;
clear f;
% 4-3 must be repeated for icosphere 4, 5 and 6

% Define range of degree for obtaining harmonic
max_lenghts = [10,20,40];

% Load icosphere
[v_ico,f_ico] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/icosphere_mesh/icosphere_6.vtk');

% Define a reconstruction vector for vertices
rcnst_v_Vector = cell(1, 3);

% Define a reconstruction vector for mean curvatures
rcnst_H_Vector = cell(1, 3);

% Define loop to reconstruct signals at degree 10, 20 and 40
for i=1:length(max_lenghts)

    % Define degree of base
    max_l = max_lenghts(i);

    % Define matrix for base of icosphere
    base = [];

    % Define loop to iterate from 0 to degree max_l
    for l = 0:max_l

        % Generate harmonic basis at degree l 
        base = [base,spharm_real(v_ico,l)];

    end
    
   
    % Reconstruct signal using harmonic base of icosphere and coefficients
    % of the sphere ar the same degree from 4-2
    rcnst_signal = base * coefficientsVector{i};

    % Reconstruc vertices
    v = rcnst_signal(:,1:3);

    % Reconstruc mean curvatures
    H = rcnst_signal(:,4);
    
    % Save reconstructed vertices
    rcnst_v_Vector{i} = v;

    % Save reconstructed mean curvatures
    rcnst_H_Vector{i} = H;
    
    % Delete v and H
    clear v;
    clear H;

end 

% Write the reconstructed v and H to the icoshpere at degree 10, 20 and 40

write_property('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/icosphere_6_degree_10.vtk', rcnst_v_Vector{1}, ...
    f_ico, struct('H', rcnst_H_Vector{1}));

write_property('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/icosphere_6_degree_20.vtk', rcnst_v_Vector{2}, ...
    f_ico, struct('H', rcnst_H_Vector{2}));

write_property('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/icosphere_6_degree_40.vtk', rcnst_v_Vector{3}, ...
    f_ico, struct('H', rcnst_H_Vector{3}));
