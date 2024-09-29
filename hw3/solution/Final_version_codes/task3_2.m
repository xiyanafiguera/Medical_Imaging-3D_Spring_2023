
%%%%%%%  Task 3-2

function Q_prime = rescalePoint(Q, A, B, C)

    % Compute the normal vector 
    N = cross(B-A, C-A);

    % Compute vector from vertex A to point Q and get scale factor
    scale_factor = dot(N, A) / dot(N, Q);

    % Compute projected distance from A to Q using the normal vector N
    Q_prime = Q * scale_factor;
end