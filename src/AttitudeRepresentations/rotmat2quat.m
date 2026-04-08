function q = rotmat2quat(R)
%rotmat2quat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the unit quaternion representation of a rotation
% matrix.
%
% Inputs:
%
%   R       A 3x3 rotation matrix
%  
% Outputs:
%
%   q       The unit quaternion representation of the rotation matrix R,
%           stored as a 4x1 column vector
%

% Scalar part (choose the positive value)
q0 = 0.5*sqrt(1+trace(R));

% Vector part
qvec = cpeminv(R-R')./(4*q0);

% Unit quaternion corresponding to the rotation matrix R
q = [q0; qvec];

end