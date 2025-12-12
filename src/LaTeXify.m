function colorarray = LaTeXify()
%LaTeXify
%
% Copyright (c) 2025 Jeremy W. Hopwood. All rights reserved.
%

% Get handles to all open figures before setting properties
existingFigs = findall(0, 'Type', 'figure');

% Set all default interpreters are set to LaTeX
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','Default');
    set(groot, default_name,'latex');
end

% % Set all default font sizes
% fs = 10;
% index_interpreter = find(endsWith(list_factory,'FontSize'));
% for i = 1:length(index_interpreter)
%     default_name = strrep(list_factory{index_interpreter(i)},'factory','Default');
%     set(groot, default_name,fs);
% end

% Set default plotting colors and line width
% https://www.nature.com/articles/nmeth.1618
colorarray = {'#0072B2','#D55E00','#009E73','#E69F00','#56B4E9','#F0E442','#CC79A7'};
linecols = colororder(colorarray);
set(0,'DefaultAxesColorOrder',linecols)
set(0,'DefaultLineLineWidth',1.2)

% Get handles to all open figures after setting properties
newFigs = setdiff(findall(0, 'Type', 'figure'), existingFigs);

% Close any figures that were created
close(newFigs)

end

