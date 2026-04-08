function [u,Phi] = rotmat2axisangle(R)
%rotmat2axisangle 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the axis-angle representation of a rotation matrix
%
% Inputs:
%
%   R       A 3x3 rotation matrix
%  
% Outputs:
%
%   u       The unit-magnitude axis of rotation
%   Phi     The angle of rotation about u
%

% Rotation angle
Phi = acos(0.5*(trace(R)-1));

% Axis of rotation 
u = cpeminv(R-R')./(2*sin(Phi));

end