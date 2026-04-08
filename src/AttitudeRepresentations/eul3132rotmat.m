function R_NB = eul3132rotmat(Theta)
%eul1232rotmat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function constructs the rotation matrix R_NB corresponding to its
% 3-1-3 Euler angle represnetation.
%
% Inputs:
%
%   Theta   The 3x1 array containing the 3-1-3 Euler angles alpha, beta,
%           and gamma
%  
% Outputs:
%
%   R_NB    The rotation matrix R_NB corresponding to the 3-1-3 Euler
%           angles alpha, beta, and gamma
%

% Euler angles
alpha = Theta(1,1);
beta = Theta(2,1);
gamma = Theta(3,1);

% Individual rotations
R3alpha = [cos(alpha),-sin(alpha),0;sin(alpha),cos(alpha),0;0,0,1];
R1beta = [1,0,0;0,cos(beta),-sin(beta);0,sin(beta),cos(beta)];
R3gamma = [cos(gamma),-sin(gamma),0;sin(gamma),cos(gamma),0;0,0,1];

% Rotation matrix from body to inertial
R_NB = R3gamma*R1beta*R3alpha;

end