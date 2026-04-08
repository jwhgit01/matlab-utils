function animateRotation(rotations, body_vectors, plot_basis_vectors, vidWriterObj, stlFile, stlRotation, stlTranslation)
%animateRotation
%
% Copyright (c) 2026 Jeremy W. Hopwood. All rights reserved.
%
% This function animates the rotational motion of a rigid body represented
% by an STL mesh.
%
% Usage Example:
%
%   vidWriter = VideoWriter('rotation_animation.mp4','MPEG-4');
%   open(vidWriter);
%   animateRotation(q_NB, omega_B, true, vidWriter, "shuttle.stl");
%   close(vidWriter);
%
% Inputs:
%
%   rotations
%       Either:
%         - 3x3xN array of rotation matrices R_IB
%         - Nx4 array of unit quaternions q_NB
%         - Nx3 array of 1-2-3 Euler angles parameterizing R_NB
%
%   body_vectors
%       N x (3*m) array containing m time histories of body-frame vectors.
%       Each row is assumed to be:
%           [v1x v1y v1z v2x v2y v2z ... vmx vmy vmz]
%       Pass [] if not desired.
%
%   plot_basis_vectors
%       Logical scalar. If true, plots the body front-right-down body frame
%       basis vectors.
%
%   vidWriterObj
%       A VideoWriter object. The function writes each frame to it. The
%       caller should open(...) it before calling this function. Pass [] to
%       skip video writing.
%
%   stlFile
%       STL filename.
%
%   stlRotation (optional)
%       3x3 rotation matrix applied to the STL in the body frame before
%       animation, to align the STL with the desired body axes.
%       Default: eye(3)
%
%   stlTranslation (optional)
%       3x1 translation applied to the STL in the body frame before
%       animation, to place the desired body origin.
%       Default: [0;0;0]
%

%% Input parsing and validation

% Require between 5 and 7 input arguments
narginchk(5, 7);

% Defaults for optional arguments
if nargin < 6 || isempty(stlRotation)
    stlRotation = eye(3); % no rotation
end
if nargin < 7 || isempty(stlTranslation)
    stlTranslation = zeros(3,1); % no translation
end

% Get rotation matrix time history from rotations input
%
% rotations is a 3x3xN array of rotation matrices
if ndims(rotations) == 3 && size(rotations,1) == 3 && size(rotations,2) == 3
    R_IB = rotations; % input is already array of rotation matrices
    N = size(R_IB, 3); % number of samples
%
% rotations is either 1-2-3 Euler angles or unit quaternions
else
    N = size(rotations,1); % number of samples
    R_IB = zeros(3,3,N); % initialize result

    % Nx4 quaternion history
    if size(rotations,2) == 4
        for k = 1:N
            q_NB_k = rotations(k,:).';
            R_IB(:,:,k) = quat2rotmat(q_NB_k);
        end
    
    % Nx3 1-2-3 Euler angle history
    elseif size(rotations,2) == 3
        for k = 1:N
            Theta_k = rotations(k,:).';
            R_IB(:,:,k) = eul1232rotmat(Theta_k);
        end

    % Invalid dimensions
    else
        error('rotations must be either 3x3xN, Nx4, or Nx3.');
    end
end

% Validate body_vectors input
if isempty(body_vectors) % no body-frame vectors
    
    % Number of body-frame vectors to plot
    m = 0;

else

    % Error checking
    if size(body_vectors,1) ~= N
        error('body_vectors must have N rows, matching the number of rotation samples.');
    end
    if mod(size(body_vectors,2), 3) ~= 0
        error('body_vectors must have a number of columns equal to 3*m.');
    end

    % Number of body-frame vectors to plot
    m = size(body_vectors,2)/3; 

end

% Validate optional STL transformations
if ~isequal(size(stlRotation), [3 3])
    error('stlRotation must be 3x3.');
end
if ~isequal(size(stlTranslation), [3 1])
    error('stlTranslation must be 3x1.');
end

%% Read STL and set up figure

% Read STL and align/place it in the body frame. The local function
% readStlCompat handles different versions of MATLAB.
[F,V] = readStlCompat(stlFile); % F = faces, V = vertices
V_B = (stlRotation*V.').'; % rotate STL to align body frame
V_B = V_B + stlTranslation.'; % translate STL to origin of body frame

% Determine physical size of STL model
modelSize = max(vecnorm(V_B,2,2));
if isempty(modelSize) || modelSize == 0 % handle edge cases
    modelSize = 1;
end

% Fixed vector display length and axis limits
displayVecLen = 1.25*modelSize;
plotRadius = 1.4*displayVecLen;

% Create and set up the figure
fig = figure(Color='w',Units='pixels',Position=[100 100 1280 720]); % 720p
ax = axes(Parent=fig,Position=[0.05 0.05 0.9 0.9]);
hold(ax,'on');
grid(ax,'on');
axis(ax,'equal');
xlim(ax,[-plotRadius, plotRadius]);
ylim(ax,[-plotRadius, plotRadius]);
zlim(ax,[-plotRadius, plotRadius]);
view(ax,3);
xticklabels(ax,{})
yticklabels(ax,{})
zticklabels(ax,{})

%% Plot the intial attitude, body-frame vectors, and basis vectors

% This matrix converts the physical plotting convention used in the rigid
% body model, where the third axis points down, into MATLAB display
% coordinates, where positive z points upward on the screen
R_DI = diag([1 -1 -1]); % inertial frame --> display frame

% Initialize STL at first frame
R_IB_0 = R_IB(:,:,1); % intial attitude
V_0 = (R_DI*R_IB_0*V_B.').'; % initial vertices to plot
patchH = patch(ax,Faces=F,Vertices=V_0,FaceColor=[0.80 0.82 0.88],...
    EdgeColor='none',FaceLighting='gouraud',AmbientStrength=0.35,...
    DiffuseStrength=0.75,SpecularStrength=0.10);

% Set lighting and camera
camlight(ax,'headlight');
material(ax,'dull');

% Body frame basis vectors if applicable
basisH = gobjects(0);
if plot_basis_vectors
    basisColors = [1 0 0; 0 0.6 0; 0 0.45 1]; % b1 red, b2 green, b3 blue
    basisBody = eye(3); % body frame bassis vectors expressed in body frame
    basisH = gobjects(3,1);
    for ii = 1:3 % loop through each basis vector and plot
        b_i = basisBody(:,ii);
        p = R_DI*R_IB_0*displayVecLen*b_i;
        basisH(ii) = plot3(ax,[0 p(1)],[0 p(2)],[0 p(3)],LineWidth=2.0,...
            Color=basisColors(ii,:));
    end
end

% Additional body-frame vectors if applicable
vecH = gobjects(0);
if m > 0
    vecColors = lines(m); % standard plotting colors
    vecH = gobjects(m,1);
    vb = reshape(body_vectors(1,:),3,[]);
    for jj = 1:m % loop through the m body-frame vectors
        vbj = vb(:,jj);
        if norm(vbj) < eps
            p = [0;0;0];
        else
            p = R_DI*R_IB_0*(displayVecLen*vbj/norm(vbj));
        end
        vecH(jj) = plot3(ax,[0 p(1)],[0 p(2)],[0 p(3)],LineWidth=2.0,...
            Color=vecColors(jj,:));
    end
end

%% Animation loop
for k = 1:N

    % Attitude rotation matrix at kth timestep
    R_IB_k = R_IB(:,:,k);

    % Update STL
    V_plot = (R_DI*R_IB_k*V_B.').'; % rotate vertices into display frame
    patchH.Vertices = V_plot; % update patch handle

    % Update basis vectors if applicable
    if plot_basis_vectors
        for ii = 1:3
            b_i = basisBody(:,ii); % ith basis vector
            p = R_DI*R_IB_k*displayVecLen*b_i; % rotate into display frame
            basisH(ii).XData = [0 p(1)];
            basisH(ii).YData = [0 p(2)];
            basisH(ii).ZData = [0 p(3)];
        end
    end

    % Update body vectors if applicable
    if m > 0
        vb = reshape(body_vectors(k,:), 3, []);
        for jj = 1:m
            vbj = vb(:,jj);
            if norm(vbj) < eps
                p = [0;0;0];
            else
                p = R_DI*R_IB_k*(displayVecLen*vbj/norm(vbj));
            end
            vecH(jj).XData = [0 p(1)];
            vecH(jj).YData = [0 p(2)];
            vecH(jj).ZData = [0 p(3)];
        end
    end

    % Update figure with new data from kth timestep
    drawnow;

    % If a video writer object was given, write frame to file
    if ~isempty(vidWriterObj)
        writeVideo(vidWriterObj, getframe(fig));
    end

end % end of animation loop

end % end of animateRotation function

%% Local functions

function [faces,vertices] = readStlCompat(stlFile)
    % First try the newer MATLAB stlread behavior in which a
    % triangulation-like object or struct may be returned
    try
        TR = stlread(stlFile);
    
        % triangulation object output
        if isa(TR,'triangulation')
            faces = TR.ConnectivityList;
            vertices = TR.Points;
            return
        end
    
        % Struct-based output used by some versions
        if isstruct(TR)
            if isfield(TR,'ConnectivityList') && isfield(TR,'Points')
                faces = TR.ConnectivityList;
                vertices = TR.Points;
                return
            elseif isfield(TR,'faces') && isfield(TR,'vertices')
                faces = TR.faces;
                vertices = TR.vertices;
                return
            end
        end
    catch
        % Do nothing here and fall through to the older two-output syntax
    end
    
    % Fall back to the older stlread syntax that directly returns faces and
    % vertices as separate outputs
    try
        [faces,vertices] = stlread(stlFile);
        return
    catch ME
        error('Unable to read STL file "%s". Original error: %s',...
              stlFile,ME.message);
    end
end
