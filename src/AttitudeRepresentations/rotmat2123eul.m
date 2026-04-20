function Theta = rotmat2123eul(R)
%rotmat2123eul 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes a 1-2-3 (phi-theta-psi) Euler angle representation
% of a rotation matrix R.
%
% Inputs:
%
%   R       A 3x3 rotation matrix
%  
% Outputs:
%
%   Theta   The 3x1 array [phi; theta; psi]
%

% Tolerance for gimbal lock detection
tol = sqrt(eps);

% Required elements of R
r11 = R(1,1);
r12 = R(1,2);
r21 = R(2,1);
r22 = R(2,2);
r31 = R(3,1);
r32 = R(3,2);
r33 = R(3,3);

% Check for gimbal lock: |cos(theta)| ~= 0 <=> |r31| ~= 1
if abs(1 - abs(r31)) < tol
    % Singular case
    if r31 <= -1 + tol
        theta = pi/2;
        psi = 0;
        phi = atan2(r12, r22);
    else 
        theta = -pi/2;
        psi = 0;
        phi = atan2(-r12, r22);
    end
else
    % Regular case
    theta = asin(-r31);
    phi = atan2(r32, r33);
    psi = atan2(r21, r11);
end

% 1--2--3 Euler angles
Theta = [phi;theta;psi];

end