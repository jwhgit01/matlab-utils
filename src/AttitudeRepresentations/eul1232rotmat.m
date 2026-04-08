function R_NB = eul1232rotmat(Theta)
%eul1232rotmat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function constructs the rotation matrix R_NB corresponding to its
% 1-2-3 Euler angle represnetation.
%
% Inputs:
%
%   Theta   The 3x1 array containing the 1-2-3 Euler angles phi, theta, psi
%  
% Outputs:
%
%   R_NB    The rotation matrix corresponding the the 1-2-3 Euler angles
%           phi, theta, psi
%

% Euler angles
phi = Theta(1,1);
theta = Theta(2,1);
psi = Theta(3,1);

% Individual rotations
R1 = [1,0,0;0,cos(phi),-sin(phi);0,sin(phi),cos(phi)];
R2 = [cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
R3 = [cos(psi),-sin(psi),0;sin(psi),cos(psi),0;0,0,1];

% Rotation matrix from body to inertial
R_NB = R3*R2*R1;

end