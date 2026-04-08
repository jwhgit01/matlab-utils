function R = quat2rotmat(q)
%quat2rotmat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function converts a unit quaternion to its equivalent rotation
% matrix representation.
%
% Inputs:
%
%   q       The unit quaternion representation of a rotation matrix stored
%           as a 4x1 column vector
%  
% Outputs:
%
%   R       The rotation matrix corresponding the unit quaternion q
%

% Scalar part
q0 = q(1,1);

% Vector part
qvec = q(2:4,1);

% Rotation matrix
R = (q0^2 - qvec'*qvec)*eye(3) + 2*(qvec*qvec') + 2*q0*cpem(qvec);

end