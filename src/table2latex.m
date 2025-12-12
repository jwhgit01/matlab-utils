function table2latex(tbl,colFormat,file,colNames)
%table2latex 
%
% Copyright (c) 2024 Jeremy W. Hopwood. All rights reserved.
%
% This function converts a Matlab table to LaTeX formatting for use with
% the tabular and siunitx packages. It displays the table to the command
% window and optionally writes to a file if provided.
%
% Inputs:
%
%   tbl         The table to be converted to LaTeX. At this point in time,
%               the only the following data types are supported: numbers,
%               char arrays, and strings. 
%
%   colFormat   A cell array containing matlab format specifiers. See 
%               https://www.mathworks.com/help/matlab/ref/fprintf.html for
%               more information. May be given as an empty array for the
%               default befavior. Currently, '+' is the only optional
%               identifier flag that is supported.
%
%   file        The optional filename of the tex file to be written. If not
%               desired, give as an empty array [] or only provide the
%               previous arguments to table2latex.
%
%   colNames    An optional cell array that contains additional variable
%               names to be included in the second row of the table. The
%               length of this array should be equal to the total number of
%               columns in the final table. If not applicable, give as an
%               empty array [] or only provide the previous arguments.
%
% Example usage:
%
%   a = 1e6*randn(3,3);
%   b = (1:3)';
%   c = randn(3,1);
%   d = [1; 0.5; -0.01];
%   des = ["row 1";"row 2";"row 3"];
%   tbl = table(a,b,c,d,des,'VariableNames',{'$a$','$b$','$c$','$d$','Description'});
%   table2latex(tbl,{'%1.2e','%i','%+1.3f','%g','%s'},'myfile.tex')
%

% Determine dimenions
nr = size(tbl,1); % number of rows in matlab table
nc = size(tbl,2); % number of columns in matlab table
nct = 0; % number of total columns in LaTeX table
for c = 1:nc
    nct = nct + size(tbl{:,c},2);
end

% Error checking
if ~isempty(colFormat) && length(colFormat) ~= nc
    error('Length of colFormat is not consistient with provided table')
end
if nargin < 4
    colNames = [];
elseif ~isempty(colNames) && length(colNames) ~= nct
    error('Length of colNames is not consistient with provided table')
end

% String patterns for interpereting colFormat
endPat = lettersPattern(1)+textBoundary('end');
startPat = textBoundary('start')+"%";
flagEndPat = digitsPattern(1) + ".";
startPrecPat = lookAheadBoundary(flagEndPat);

% Table variable names
varNames = tbl.Properties.VariableNames;

% Initialize strings
head = "\begin{tabular}{";
tblColNames = "";
row2 = "";
rows = repmat("",nr,1);

% Coulumn number counter
k = 0;

% Construct the table by column
for c = 1:nc

    % column size
    ni = size(tbl{:,c},2);

    % Determine column format spec
    if isempty(colFormat) || isempty(colFormat{c})
        
        % Default specifiers
        lfs = "c";
        if isnumeric(tbl{:,c})
            mfs = "%g";
        else
            mfs = "%s";
        end

    else
        
        % Get matlab format spec
        mfs = string(colFormat{c});
        cc = extract(mfs,endPat); % conversion character
        prec = extractBetween(mfs,startPrecPat,endPat); % width and precision
        flags = extractBetween(mfs,startPat,flagEndPat); % flags

        % Check optional flags 
        if ~isempty(flags) && ~strcmp(flags,"+") && ~strcmp(flags,"")
            warning('Currently, ''+'' is the only supported optional identifier flag.')
        end

        % Make empty string arrays ""
        if isempty(prec), prec=""; end
        if isempty(flags), flags=""; end
        
        % Determine LaTeX format based on conversion character
        switch cc
            case {'d','i','u'}
                lfs = "c";
            case {'e','E'}
                numExp = min([max(ceil(log10(abs(log10(tbl{:,c})))),[],"all"),2]);
                lfs = "S[table-format=" + flags + prec + cc + "+" + num2str(numExp) + "]";
            case {'g','G','f','F'}
                lfs = "S[table-format=" + flags + prec + "]";
            case 's'
                lfs = "c";
            otherwise
                error('Unsupported conversion character, %s',cc)
        end

    end

    % Tabular seperator for the top row
    if c == nc
        sep = " \\";
    else
        sep = " & ";
    end

    % Column name
    if strcmp(varNames{c},"<>") % special rule
        varc = "";
    else
        varc = varNames{c};
    end

    % Use multicolumn for the first row if necessary
    if startsWith(lfs,"S") || ni > 1
        tblColNames = tblColNames + "\multicolumn{" + num2str(ni) + "}{c}{" + varc + "}" + sep;
    else
        tblColNames = tblColNames + varc + sep;
    end

    % Loop through sub-columns
    for s = 1:ni

        % Table seperator string
        if s == ni && c == nc
            sep = " \\";
        else
            sep = " & ";
        end

        % Add to the header and column names strings
        k = k + 1;
        head = head + lfs;
        if ~isempty(colNames)
            row2 = row2 + colNames{k} + sep;
        end

        % Print row to rows string array
        % Special rules:
        %   NaN --> "\multicolumn{1}{c}{--}"
        %   Inf --> "\multicolumn{1}{c}{$\infty$}"
        for r = 1:nr

            % Table value string
            val = tbl{r,c}(s);

            % Apply special rule listed above
            if isnumeric(val) && isnan(val)
                str = "\multicolumn{1}{c}{--}";
            elseif isnumeric(val) && ~isfinite(val)
                if val > 0
                    str = "\multicolumn{1}{c}{$\infty$}";
                else
                    str = "\multicolumn{1}{c}{$-\infty$}";
                end
            else % no special rules applied
                str = sprintf(mfs,tbl{r,c}(s));
            end

            % Add to row string
            rows(r,1) = rows(r,1) + str + sep;

        end % rows

    end % sub-columns

end % columns

% Close out the header
head = head + "}";

% Display to command window
disp(head)
disp("\hline\hline")
disp(tblColNames)
if row2 ~= ""
    disp(row2);
end
disp("\hline")
for r = 1:nr
    disp(rows(r))
end
disp("\hline\hline")
disp("\end{tabular}")

% Write to file if applicable
if nargin > 2 && ~isempty(file)
    fd = fopen(file, 'w');
    fprintf(fd,"%s\n",head);
    fprintf(fd,"%s\n","\hline\hline");
    fprintf(fd,"%s\n",tblColNames);
    if row2 ~= ""
        fprintf(fd,"%s\n",row2);
    end
    fprintf(fd,"%s\n","\hline");
    for r = 1:nr
        fprintf(fd,"%s\n",rows(r));
    end
    fprintf(fd,"%s\n","\hline\hline");
    fprintf(fd,"%s\n","\end{tabular}");
    fclose(fd);
end

end