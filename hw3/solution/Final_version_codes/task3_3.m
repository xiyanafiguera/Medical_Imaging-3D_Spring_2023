clear
clc

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
%%%%%%%  Task 3-2

function Q_prime = rescalePoint(Q, A, B, C)

    % Compute the normal vector 
    N = cross(B-A, C-A);

    % Compute vector from vertex A to point Q and get scale factor
    scale_factor = dot(N, A) / dot(N, Q);

    % Compute projected distance from A to Q using the normal vector N
    Q_prime = Q * scale_factor;
end