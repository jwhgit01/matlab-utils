function R = axisangle2rotmat(u,Phi)
%axisangle2rotmat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function constructs the rotation matrix corresponding to its
% axis-angle represnetation.
%
% Inputs:
%
%   u       The unit-magnitude axis of rotation
%   Phi     The angle of rotation about u
%  
% Outputs:
%
%   R       The rotation matrix corresponding to the axis-angle
%           representation (u,Phi)
%

R = eye(3) + cpem(u)*sin(Phi) + cpem(u)*cpem(u)*(1-cos(Phi));

end