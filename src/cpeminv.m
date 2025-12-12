function a = cpeminv(M)
%cpeminv
Ma = 0.5*(M - M');
a = [Ma(3,2); Ma(1,3); Ma(2,1)];
end