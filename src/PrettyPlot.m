function PrettyPlot(fig,filename,pdf)
%PrettyPlot 
%
% Copyright (c) 2023 Jeremy W. Hopwood. All rights reserved.
%
% This function formats and optionally saves figures for publication. 
%
% Example usage:
%   fig = figure('Units','Inches');
%   fig.Position(3:4) = [3 2];
%   plot(t,x)
%   xlabel('Time [s]')
%   ylabel('State vector, $x$')
%   filename = './Figures/myFigure';
%   PrettyPlot(fig,filename);
%
% Inputs:
%
%   fig         The handle of the figure of inetrest
%
%   filename    The file path and base file name of the figure (optional)
%

% Figure properties
fig.Color = 'w';

% Make paper properties match the on-screen size
fig.PaperSize = fig.Position(3:4);

% Axes properties
axs = findall(fig, 'Type','axes');
for k = 1:numel(axs)
    ax = axs(k);
    ax.FontName = 'Times';
    ax.FontSize = 10;
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.ZColor = 'k';
    ax.Box = 'on';
end

% if a filepath is given, save figure
if nargin > 1 && (isstring(filename) || ischar(filename))
    savefig(fig,strcat(filename,".fig"));
    if nargin < 3 || pdf
        % exportgraphics(fig,strcat(filename,".pdf"),'BackgroundColor','w','ContentType','vector');
        print(fig, strcat(filename,".pdf"), '-dpdf', '-vector');
    end
    exportgraphics(fig,strcat(filename,".png"),'BackgroundColor','w','Resolution',500);
end

end