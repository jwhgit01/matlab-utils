function q_NB = eul1232quat(Theta)
%eul1232quat 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function constructs the unit quaternion corresponding to the 1-2-3
% Euler angle representation of the rotation matrix R_NB.
%
% Inputs:
%
%   Theta   The 3x1 array containing the 1-2-3 Euler angles phi, theta, psi
%  
% Outputs:
%
%   q_NB    The unit quaternion corresponding to the rotation matrix R_NB
%

% Euler angles to rotation matrix
R_NB = eul1232rotmat(Theta);

% Rotation matrix to quaternion
q_NB = rotmat2quat(R_NB);

end