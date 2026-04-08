function Thetadot = eul123Kinematics(Theta,omega)
%eul123Kinematics 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the 1-2-3 Euler angle kinematics --- that is, the
% time derivative of the Euler angles phi, theta, and psi.
%
% Inputs:
%
%   Theta   The 3x1 array containing the 1-2-3 Euler angles phi, theta, psi
%   omega   The 3x1 angular velocity vector of the body frame with respect
%           to the inertial frame, expressed in the body frame
%  
% Outputs:
%
%   Thetadot    The time derivative of Theta
%

% Roll angle
phi = Theta(1,1);

% Pitch angle
theta = Theta(2,1);

% The 3x3 matrix L(Theta)
L = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
     0, cos(phi),           -sin(phi)           ;
     0, sin(phi)*sec(theta), cos(phi)*sec(theta)];

% 1-2-3 Euler angle kinematics
Thetadot = L*omega;

end