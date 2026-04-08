function q_NB_dot = quatKinematics(q_NB,omega)
%quatKinematics 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the unit quaternion kinematics.
%
% Inputs:
%
%   q_NB    The unit quaternion representation of the rotation matrix R_NB,
%           stored as a 4x1 column vector
%   omega   The 3x1 angular velocity vector of the body frame with respect
%           to the inertial frame, expressed in the body frame
%  
% Outputs:
%
%   q_NB_dot    The time derivative of q_NB
%

% Scalar part
q0 = q_NB(1,1);

% Vector part
qvec = q_NB(2:4,1);

% The 4x3 matrix Xi(q_NB)
Xi = [-qvec'; q0*eye(3) + cpem(qvec)];

% Quaternion attitude kinematics
q_NB_dot = 0.5*Xi*omega;

end