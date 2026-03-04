function a = cpeminv(M)
%cpeminv
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the inverse operation to the cross product
% equivalent matrix, often called the "vee map" (a reference to the Lie
% algebra so(3) and its one-to-one correspondence with 3-dimensional
% Eucidean space). Valid for any 3x3 matrix M, cpeminv(M) takes the
% skew-symmetric part of M and, treating it as a cross product equivalent
% matrix, returns the 3x1 vector that corresponds to it.
%
% Inputs:
%
%   M       A 3x3 matrix
%  
% Outputs:
%
%   a       The vee map of M
%

% Skew symmetric part of the matrix M. Note that any square matrix can be
% decomposed into its symmetric part 0.5*(M+M') and its skew-symmetric part
% 0.5*(M-M') such that M = 0.5*(M+M') + 0.5*(M-M').
Mskew = 0.5*(M - M');

% 3x1 vector correspoinding to the cross product equivalent matrix Mskew
a = [Mskew(3,2); Mskew(1,3); Mskew(2,1)];

end