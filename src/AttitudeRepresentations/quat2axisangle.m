function [u,Phi] = quat2axisangle(q)
%quat2axisangle 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function converts the unit quaternion representation of a rotation
% matrix its corresponding axis-angle representation.
%
% Inputs:
%
%   q       The unit quaternion representation of a rotation matrix stored
%           as a 4x1 column vector
%  
% Outputs:
%
%   u       The unit-magnitude axis of rotation
%   Phi     The angle of rotation about u
%

% Scalar part
q0 = q(1,1);

% Vector part
qvec = q(2:4,1);

% Rotation angle
Phi = 2*acos(q0);

% Rotation axis for a near-zero angle
tol = sqrt(eps);
if abs(Phi) < tol
    u = zeros(3,1);
    return
end

% Rotation axis for a non-zero angle
u = qvec./sin(Phi/2);

end