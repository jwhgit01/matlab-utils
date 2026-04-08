function q = axisangle2quat(u,Phi)
%axisangle2quat
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function converts the axis-angle representation of a rotation matrix
% to a unit quaternion.
%
% Inputs:
%
%   u       The unit-magnitude axis of rotation
%   Phi     The angle of rotation about u
%  
% Outputs:
%
%   q       The unit quaternion corresponding to the axis-angle
%           representation (u,Phi)
%

% Scalar part of the unit quaternion q
q0 = cos(Phi/2);

% Vector part of the unit quaternion q
qvec = u*sin(Phi/2);

% Unit attitude quaternion, q
q = [q0; qvec];

end