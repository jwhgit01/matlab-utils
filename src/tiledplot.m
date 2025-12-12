function f = tiledplot(plotnumber,layout,plotfun,plotargs)
%tiledplot

% Get screen resolution
set(0,'units','pixels')
screenSize = get(0,'ScreenSize');
ws = screenSize(3);
ws0 = 1;
hs = screenSize(4) - 40;
hs0 = 41;

% Determine plot locations based on layout
Nh = layout(1);
Nw = layout(2);
w = floor(ws/Nw);
h = floor(hs/Nh);
nw = mod(plotnumber-1,Nw);
nh = Nh-floor((plotnumber-1)/Nw)-1;
pw = ws0 + nw*w;
ph = hs0 + nh*h;

% Set up the desired figure
f = figure(plotnumber);
f.Units = 'Pixels';
f.OuterPosition = [pw ph w h];
f.PaperSize = [w h];

% Plot
if isempty(plotfun)
    return
end
if strcmp(plotfun,'plot')
    hold on
end
feval(plotfun,plotargs{:});
if strcmp(plotfun,'plot')
    hold off
end
grid on

end