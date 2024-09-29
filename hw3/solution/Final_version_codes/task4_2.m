
clc;
clear;

%%%%%%%%%%%% Task 4-1 %%%%%%%%%%%%%%%%%%%%

% Load sphere
[v, f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.sphere.vtk');

% Define range for later use in task 4-3 obtaining harmonic for 10,20,40
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

