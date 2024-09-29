clear
clc

%%% Task 1-1

% Declare path
file_path = '/Users/xiyana/Downloads/med-course/homeworks/hw4/hippo/';

% Create celss to store the vertices and faces data
v = cell(10, 1);
f = cell(10, 1);

% Loop to load the hippocampal surfaces 
for i = 1:10
    % Construct file name
    file_name = [num2str(i) '.vtk'];
    
    % Load VTK file
    [v{i}, f{i}] = read_vtk(fullfile(file_path, file_name));
end

% Compute mean of vertices and faces
v_mean = compute_mean(v);
f_mean = compute_mean(f);
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw4/results/average_shape.vtk',v_mean, f_mean);


% Function for average 
function v_mean = compute_mean(v)

    % Initialize mean variable
    v_mean = zeros(size(v{1}));

    % Compute the sum 
    for i = 1:numel(v)
        v_mean = v_mean + v{i};
    end
    % Divide
    v_mean = v_mean / numel(v);
end