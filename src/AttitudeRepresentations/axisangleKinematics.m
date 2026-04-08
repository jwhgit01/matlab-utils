function udot_Phidot  = axisangleKinematics(uPhi,omega)
%axisangleKinematics 
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the axis-angle angle kinematics --- that is, the
% time derivatives of the rotation axis u and the angle of rotation Phi
%
% Inputs:
%
%   uPhi    The concatenation of:
%       u   The unit-magnitude axis of rotation
%       Phi The angle of rotation about u
%
%   omega   The 3x1 angular velocity vector of the body frame with respect
%           to the inertial frame, expressed in the body frame
%  
% Outputs:
%
%   udot_Phidot     The concatenation of:
%       udot        The time derivative of u
%       Phidot      The time derivative of Phi
%

% Parse the concatenated state vector uPhi
u = uPhi(1:3,1);
Phi = uPhi(4,1);

% The matrix Gamma(u,Phi) used to compute udot
Gamma = cpem(u) - cot(Phi/2)*cpem(u)*cpem(u);

% Time derivative of u
udot = 0.5*Gamma*omega;

% Time derivative of Phi
Phidot = dot(u,omega);

% Concatenate the result
udot_Phidot = [udot;Phidot];

end