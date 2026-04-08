function Thetadot = eul313Kinematics(Theta,omega)
%eul123Kinematics 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the 3-1-3 (alpha-beta-gamma) Euler angle
% kinematics --- that is, the time derivatives of the Euler angles alpha,
% beta, and gamma.
%
% Inputs:
%
%   Theta   The 3x1 array [alpha; beta; gamma]
%   omega   The 3x1 angular velocity vector of the body frame with respect
%           to the inertial frame, expressed in the body frame
%  
% Outputs:
%
%   Thetadot    The time derivative of Theta
%

% First rotation angle, alpha
alpha = Theta(1,1);

% Second rotation angle, beta
beta = Theta(2,1);

% The 3x3 matrix L(Theta)
L = [-cot(beta)*sin(alpha), -cos(alpha)*cot(beta), 1;
                cos(alpha),           -sin(alpha), 0;
      sin(alpha)/sin(beta),  cos(alpha)/sin(beta), 0];

% Euler angle kinematics
Thetadot = L*omega;

end