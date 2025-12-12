function fts = TaylorSeries(f,x,x0,N,idisp)
%TaylorSeries 
%
% Copyright (c) 2023 Jeremy W. Hopwood. All rights reserved.
%
% This function computes the Nth order multivariate Taylor series expansion
% of the vector-valued function f with respect to x about the point x0.
%
% Inputs:
%
%   f       The function, f: R^n --> R^m, that we wish to approximate.
%   x       The vector, x \in R^n, of which f is a function. 
%   x0      The point, x = x0, about which the Taylor series is performed.
%   N       The order of the Taylor series approximation
%   idisp   A logical whether to display the status of the expansion.
%  
% Outputs:
%
%   fts     The Nth order Taylor series approxiamtion of f about x = x0.
%

%%%%%% TODO %%%%%%
% Use Recursion! %
%%%%%%%%%%%%%%%%%%

% Get necessary dimensions
n = size(x,1);
m = size(f,1);

% Return if zero order is specified
if N == 0
    fts = subs(f,x,x0);
    return
end

% Initialize the result
fts = zeros(m,1,'like',x);

switch N
    case 1
        for ii = 1:m
            fi = f(ii);
            ftsi = subs(fi,x,x0);
            for jj = 1:n
                if idisp
                    fprintf('%i,%i\n',ii,jj)
                end
                Jij = diff(fi,x(jj));
                ftsi = simplify(ftsi + (1/factorial(1))*subs(Jij,x,x0)*(x(jj)-x0(jj)));
            end
            fts(ii,1) = ftsi;
        end
        return

    case 2
        for ii = 1:m
            fi = f(ii);
            ftsi = subs(fi,x,x0);
            for jj = 1:n
                Jij = diff(fi,x(jj));
                ftsi = ftsi + (1/factorial(1))*subs(Jij,x,x0)*(x(jj)-x0(jj));
                for kk = 1:n
                    if idisp
                        fprintf('%i,%i,%i\n',ii,jj,kk)
                    end
                    Kijk = diff(Jij,x(kk));
                    ftsi = simplify(ftsi + (1/factorial(2))*subs(Kijk,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk)));
                end
            end
            fts(ii,1) = ftsi;
        end
        return

    case 3
        for ii = 1:m
            fi = f(ii);
            ftsi = subs(fi,x,x0);
            for jj = 1:n
                Jij = diff(fi,x(jj));
                ftsi = simplify(ftsi + (1/factorial(1))*subs(Jij,x,x0)*(x(jj)-x0(jj)));
                for kk = 1:n
                    Kijk = diff(Jij,x(kk));
                    ftsi = simplify(ftsi + (1/factorial(2))*subs(Kijk,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk)));
                    for ll = 1:n
                        if idisp
                            fprintf('%i,%i,%i,%i\n',ii,jj,kk,ll)
                        end
                        Lijkl = diff(Kijk,x(ll));
                        ftsi = simplify(ftsi + (1/factorial(3))*subs(Lijkl,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk))*(x(ll)-x0(ll)));
                    end
                end
            end
            fts(ii,1) = ftsi;
        end
        return

    case 4
        for ii = 1:m
            fi = f(ii);
            ftsi = subs(fi,x,x0);
            for jj = 1:n
                Jij = diff(fi,x(jj));
                ftsi = simplify(ftsi + (1/factorial(1))*subs(Jij,x,x0)*(x(jj)-x0(jj)));
                for kk = 1:n
                    Kijk = diff(Jij,x(kk));
                    ftsi = simplify(ftsi + (1/factorial(2))*subs(Kijk,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk)));
                    for ll = 1:n
                        Lijkl = diff(Kijk,x(ll));
                        ftsi = simplify(ftsi + (1/factorial(3))*subs(Lijkl,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk))*(x(ll)-x0(ll)));
                        for mm = 1:n
                            if idisp
                                fprintf('%i,%i,%i,%i,%i\n',ii,jj,kk,ll,mm)
                            end
                            Mijkl = diff(Lijkl,x(mm));
                            ftsi = simplify(ftsi + (1/factorial(4))*subs(Mijkl,x,x0)*(x(jj)-x0(jj))*(x(kk)-x0(kk))*(x(ll)-x0(ll))*(x(mm)-x0(mm)));
                        end
                    end
                end
            end
            fts(ii,1) = ftsi;
        end
        return

    otherwise
        error('Invalid order')

end

end