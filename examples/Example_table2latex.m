clear
clc

% Table data
a = 1e6*randn(3,3);
b = (1:3)';
c = randn(3,1);
d = [1; 0.5; -0.01];
des = ["row 1";"row 2";"row 3"];

% Create Matlab table
tbl = table(a,b,c,d,des,'VariableNames',{'$a$','$b$','$c$','$d$','Description'});

% Convert to LaTeX and write to file
table2latex(tbl,{'%1.2e','%i','%+1.3f','%g','%s'},'myfile.tex')

