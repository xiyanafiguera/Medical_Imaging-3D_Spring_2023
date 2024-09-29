clear
clc

%%% Task 2

% Declare path
file_path = '/Users/xiyana/Downloads/med-course/homeworks/hw4/hippo/';
file_path_output = '/Users/xiyana/Downloads/med-course/homeworks/hw4/results/';

% Create cells to store the data
v = cell(10, 1);
f = cell(10, 1);

% Loop to load hippocampal surfaces
for i = 1:10
    % Construct file name
    file_name = [num2str(i) '.vtk'];
    
    % Load VTK file
    [v{i}, f{i}] = read_vtk(fullfile(file_path, file_name));
end

% Create cells to store new data
v_new_initial = cell(10, 1);
v_new_initial{1} = v{1};

% Step 1: pick first subject (1.vtk), and compute the best overlap for each subject via the Procrustes alignment. 
for i = 2:10
    [~,new_initial] = procrustes(v{1},v{i},'reflection',false,'scaling',false);
    v_new_initial{i} = new_initial;
end

% Step 2: Compute average shape
St_1 = compute_mean(v);   % Raw average
St = compute_mean(v_new_initial); % Procrustes alignment average

difference = St - St_1; % Difference between raw estimated average shape and current iteration 

frobenius_norm = norm(difference, 'fro'); % Initialize Frobenius norm 

St_1 = St; % Update St_1 

% Repeat 2 and 3 until the Frobenius norm of the difference between the estimated average shape of the last iteration 
% and current iteration is negligible (< 1e-12)

while frobenius_norm >= 1e-12
    % Declare a cell to store new vertex data
    v_new = cell(10, 1);
    
    % Step 3: Compute the best overlap for each subject via the Procrustes alignment (with average shape)
    for i = 1:10
        [~,new] = procrustes(St_1,v{i},'reflection',false,'scaling',false);
        v_new{i} = new;
    end

    % Step 2: Compute average shape
    St = compute_mean(v_new);

    % Difference between the estimated average shape of the last iteration and current iteration 
    difference = St - St_1;
    
    % Calculate the Frobenius norm of the difference
    frobenius_norm = norm(difference, 'fro');
    
    % Update St_1 with the current St for the next iteration
    St_1 = St;

end

f_mean = compute_mean(f);
write_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw4/results/new_average_shape.vtk',St, f_mean);

% Output VTK files
for i = 1:10
    % Construct the file name
    file_name = [num2str(i) '_new.vtk'];
    file_path_full = fullfile(file_path_output, file_name);
    % Output VTK file
    write_vtk(fullfile(file_path_output, file_name),v_new{i}, f{i});
end

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



