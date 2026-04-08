function gammadot = exponentialKinematics(gamma,omega)
%exponentialKinematics 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the attitude kinematics using exponential
% coordinates R_NB = expm(cpem(gamma))
%
% Inputs:
%
%   gamma   The vector part of the matrix logarithm of R_NB
%   omega   The 3x1 angular velocity vector of the body frame with respect
%           to the inertial frame, expressed in the body frame
%  
% Outputs:
%
%   gammadot    The time derivative of gamma
%

% Angle of rotation
Phi = norm(gamma);

% Inverse of the right Jacobian on SO(3)
a = (1 - 0.5*Phi*cot(0.5*Phi))/(Phi^2);
JRinv = eye(3) + 0.5*cpem(gamma) + a*cpem(gamma)*cpem(gamma);

% Exponential kinematics
gammadot = JRinv*omega;

end