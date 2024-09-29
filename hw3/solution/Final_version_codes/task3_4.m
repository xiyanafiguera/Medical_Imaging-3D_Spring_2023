clear
clc
%%%% Task 3-4 is below down 3-3

%%%% Task 3-3

% Load icosphere for query and sphere for triangles
[v_o, f_o] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.sphere.vtk');
[v, f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/icosphere_mesh/icosphere_4.vtk');

%Initialize tree for knn search
MD = KDTreeSearcher(v_o);

%Initialize triangulation
tr = triangulation(f_o+1, v_o);

% Set Q to be the vertices of icosphere
Q = v;

% Initiliaze matrices and variable to pass to next query
reachy = 1;
triang_id = [];
triang_bary = [];
p_closest = [];

% while Q is not empty but with a for loop
for i = 1:length(Q) 
    
    % Per query
    q = Q(i,:);

    % Starting from one closest neighbor
    k= 1; 
    
    % While there are still faces to visit keep same k
    while reachy==i
        
        % Temporal k
        k_temp = k;

        % Knn search, find faces that share the closest vertex p using vertex attachment 
        % and find vertices using connectivity list
        p = MD.knnsearch(q, 'k', k, 'distance', 'euclidean');
        p = p.';
        T = tr.vertexAttachments(p);        
        face = T(k);
        faces = face{1};
        
        vertices = tr.ConnectivityList(face{1},:);
        
        % For every triangle
        for triangle=1:length(vertices)
            
            % Rescale query point
            A = tr.Points(vertices(triangle,1),:);
            B = tr.Points(vertices(triangle,2),:);
            C = tr.Points(vertices(triangle,3),:);
            
            q_scaled = rescalePoint(q,A,B,C);
            
            % Obtain barycentric coefficients
            bc_coords = cartesianToBarycentric(tr, faces(triangle),q_scaled);
            
            % When all faces are checked go to next closest neighbor
            if triangle==length(vertices)
                   
                   k=k+1;
                   
            end
            
            % Do inside test using barycentric coefficients
            if all(bc_coords >= 0)
               
               % Pass to the next query
               reachy = reachy+1;
               
               % store this triangle as closest one to q
               % store barycentric coefficients for re-tessellation
               % store p 
               triang_id = [triang_id;faces(triangle)];
               triang_bary =[triang_bary;bc_coords];
               p_closest = [p_closest;p(k_temp)];               
               
               break
               
               
            end

        
        end

    
    end
    
end


%%%%%%%%%%%%%%%%  3-4
H = load('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.H.txt');
[v_original, f_original] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.vtk');
tr_original = triangulation(f_original+1, v_original);

% Initialize variables for the new mesh
newVertices = zeros(size(triang_bary, 1), size(v_original, 2));
new_H = zeros(size(triang_bary, 1), size(H, 2));

% Iterate over each vertex
for i = 1:size(triang_bary, 1)
   
    % Get the barycentric coefficients and associated faces for the vertex
    baryCoeffs = triang_bary(i, :);
    faces_id = triang_id(i, :);
    
    %Find vertices connected to the triangles and their ABC points
    vertices_original = tr_original.ConnectivityList(faces_id,:);
    ABC= tr_original.Points(vertices_original(1,:),:);
    
    % Do interpolation with the barycentric coefficients and triangles of
    % original mesh
    newVertex_v = ABC*baryCoeffs';
    newVertices(i,1) = newVertex_v(1);
    newVertices(i,2) = newVertex_v(2);
    newVertices(i,3) = newVertex_v(3);
    
    
end

% Find new H
for i=1:length(Q)
    
    new_H(i,:) = H(i);
   
end

write_property('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/search_icosphere_4.vtk',newVertices, ...
    f, struct('H', new_H));

%%%%%%%  Task 3-2

function Q_prime = rescalePoint(Q, A, B, C)

    % Compute the normal vector 
    N = cross(B-A, C-A);

    % Compute vector from vertex A to point Q and get scale factor
    scale_factor = dot(N, A) / dot(N, Q);

    % Compute projected distance from A to Q using the normal vector N
    Q_prime = Q * scale_factor;
end
