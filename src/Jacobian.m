function varargout = Jacobian(f, x, Method, epsilon)
% Calculate Jacobian(s) of function handle f at point x.
% If f returns multiple outputs, Jacobian will return that many Jacobians.
if nargin < 3 || isempty(Method)
    Method = 'CFDM';
    epsilon = [];
end
if nargin < 4 || isempty(epsilon)
    epsilon = 1e-6;
end
epsinv = 1/epsilon;

% Assume the number of outputs requested is the same as the number of
% outputs returned by f
k = nargout;

% Force x to be a column vector
x = x(:);
n = numel(x);

% Evaluate f at x for all outputs
y0 = cell(1,k);
[y0{:}] = f(x);

% Preallocate Jacobians
m = zeros(1,k);
varargout = cell(1,k);
for jj = 1:k
    m(jj) = numel(y0{jj});
    varargout{jj} = zeros(m(jj),n);
end

switch Method
    case 'FiniteDifference'
        for ii = 1:n
            xplus = x; 
            xplus(ii) = xplus(ii) + epsilon;
            yplus = cell(1,k);
            [yplus{:}] = f(xplus);
            for jj = 1:k
                varargout{jj}(:,ii) = (yplus{jj}(:)-y0{jj}(:))*epsinv;
            end
        end

    case 'CSDA'
        for ii = 1:n
            xcs = x; 
            xcs(ii) = xcs(ii) + 1i*epsilon;
            ycs = cell(1,k);
            [ycs{:}] = f(xcs);
            for jj = 1:k
                varargout{jj}(:,ii) = imag(ycs{jj}(:))*epsinv;
            end
        end

    case 'CFDM'
        for ii = 1:n
            xp = x; xm = x;
            xp(ii) = xp(ii) + epsilon;
            xm(ii) = xm(ii) - epsilon;
            yp = cell(1,k); ym = cell(1,k);
            [yp{:}] = f(xp);
            [ym{:}] = f(xm);
            for jj = 1:k
                varargout{jj}(:,ii) = 0.5*epsinv*(yp{jj}(:)-ym{jj}(:));
            end
        end

    case 'Symbolic'
        xs = sym('xs', [n,1], 'real');
        yS = cell(1,k);
        [yS{:}] = f(xs);
        for jj = 1:k
            fx = jacobian(yS{jj}(:), xs);
            varargout{jj} = double(subs(fx,xs,x));
        end

    otherwise
        error('%s method not recognized!', Method);
end

end
