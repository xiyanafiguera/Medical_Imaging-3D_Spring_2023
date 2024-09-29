clear
clc

%%% Task 3

% Declare path
file_path = '/Users/xiyana/Downloads/med-course/homeworks/hw4/results/';


% Create cells to store the data
v = cell(10, 1);
f = cell(10, 1);

for i = 1:10
    % Construct file name
    file_name = [num2str(i) '_new.vtk'];
    
    % Load VTK file
    [v{i}, f{i}] = read_vtk(fullfile(file_path, file_name));
end

%%% Task 3-1

% Declare matrix M
M = [];

% Iterate over each subject in the v cell
for i = 1:numel(v)
    % Get a subject
    subject_vector = v{i};
    % Concatenate the subject vector to the matrix M
    M = [M, subject_vector(:)];
end

% Compute PCA
[pc,~,lambda] = pca(M');


%%% Task 3-2

% Compute fraction of variance explained by component
fraction_variance = lambda / sum(lambda);

% Plot a bar graph 
figure;
bar(fraction_variance);
xlabel('Principal Component');
ylabel('Fraction of Variance');
title('Fraction of Variance Explained by Component');

% Compute the variation explained by PC 1 and PC 2
var_pc1 = fraction_variance(1);
var_pc2 = fraction_variance(2);

% Print pc1, pc2
fprintf('Variation Explained by PC 1: %.2f%%\n', var_pc1 * 100);
fprintf('Variation Explained by PC 2: %.2f%%\n', var_pc2 * 100);


%%% Task 3-3

% Square root of eigen values
sqrt_lambda = sqrt(lambda);

% Load average shape st
[st_v, st_f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw4/results/new_average_shape.vtk');

% Configurations
elements = [-3, -2, -1, 0, 1, 2, 3];

% For Pc1, Pc2
for i = 1:2
    
    % Extract (first/second) largest pc
    pc_ = pc(:,i);

    % Reshape pc back to matrix
    pc_matrix = reshape(pc_, [], 3);
    
    % For configuration 
    for j = 1:length(elements)
        
        st_new = st_v + (elements(j)*sqrt_lambda(i)*pc_matrix);
        file_name = ['pca_' num2str(i) '_' num2str(j) '_pca_new.vtk'];
        file_path_full = fullfile(file_path, file_name);
        write_vtk(fullfile(file_path, file_name),st_new, st_f);

    end
end 


