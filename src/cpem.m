function M = cpem(a)
%cpem
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the cross product eqwuivalent matrix of a 3x1 
% vector a. For two vectors a and b, it satisfies cpem(a)*b = cross(a,b).
%
% Inputs:
%
%   a       A 3x1 vector
%  
% Outputs:
%
%   M       The cross product equivalent matrix of the vector a
%

M = [0,-a(3,1),a(2,1); a(3,1),0,-a(1,1); -a(2,1),a(1,1),0];

end