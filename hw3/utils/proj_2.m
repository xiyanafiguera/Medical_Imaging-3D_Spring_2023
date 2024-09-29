clc;
clear;
disp("Running")
[v, f] = read_vtk('lh.white.vtk');
[v2, f2] =  read_vtk('icosphere_4.vtk');
% Initialization
Q = v2;
k = 1;
MD = KDTreeSearcher(v);
TR = triangulation(f+1, v);
triangles.point = [];
triangles.f_id = [];
triangles.barycentric_coeffs = [];
% Main loop
while ~isempty(Q)
    fprintf("%d, Q length: %d\n", k, length(Q))
    i = 1;
    while 1
        if i >= length(Q)
            break
        end
        q = Q(i, :);
        p = MD.knnsearch(q, 'k', k, 'distance', 'euclidean');
        T = vertexAttachments(TR, p');
        T_ = [T{1}];
        for j=2:length(T)
            T_ = [T_, T{j}];
        end
        f_id = T_;
        t = TR(f_id, :);
        q_proj = proj_2(q, t, v);
        bary = cartesianToBarycentric(TR, f_id', q_proj);
        check = sum(bary>=0, 2);
        check = find(check == 3);
        if ~isempty(check)
            % Store triangle
            triangles.point = [triangles.point; repmat(q, length(check), 1)];
            triangles.f_id = [triangles.f_id; f_id(check)];
            triangles.barycentric_coeffs = [triangles.barycentric_coeffs; bary(check, :)];
            Q(i, :) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    k = k+1;
end
save('triangles.mat', triangles);
disp("Done")


function q_proj=proj_2(q, t, v)
    % Obtain three vectors(points) on given t plain.
    v1 = v(t(:, 1), :);
    v2 = v(t(:, 2), :);
    v3 = v(t(:, 3), :);
    
    % Compute two vectors on given t plain.
    plain_v1 = v1 - v2;
    plain_v2 = v1 - v3;

    % Get vertical normalized vector
    triangle_normal = cross(plain_v1, plain_v2);

    % Calculate palin equation.
    d = triangle_normal * v1';
    d = diag(d);

    % 
    scale_factor = (d ./ (triangle_normal * q'));
    q_proj = scale_factor .* q;
end