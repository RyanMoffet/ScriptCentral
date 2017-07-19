%% plot netCDF files
%% 24 Feb. 2004

%% usage:  CDFplot(time, data structure, file information structure)
%% types: 'sec' -- number of seconds of since first record; 'julian' -- julian time
function handle = CDFplot(timematrix, D, V);

ncquiet;
nc = netcdf(char(V.CDFfilename), 'nowrite');              % Open NetCDF file.
vdata = var(nc);      % Get variable data.

%% populate matrix with variable names
dstring = [];
for i = 1:length(vdata)
    dstring = strvcat(name(vdata{i}), dstring);
end;
dstring = flipud(dstring);  %% flip matrix to correct indices

%% indices for variable matrix
j = zeros(length(D.varstr),1);
for i = 1:length(D.varstr)
    try
        j(i) = strmatch(D.varstr(i), dstring, 'exact');
    catch
        j(i) = -1;  %% error in strmatch
        disp(['WARNING: Variable "' char(D.varstr(i)) '" not found!  Removing variable from string.']);
    end;
end;
%% Restruction variable strings for valid inputs
k = find(j >= 1);
if any(k)
    D.varstr = D.varstr(k);
    j = j(k);
else
    disp('ERROR: no variables to plot');
    D.varstr = [];
    finish;
end;

varmatrix = zeros(length(D.varstr), length(timematrix));
legendstr = [];
ystr = D.varstr(1);
for i = 1:length(D.varstr)
    varmatrix(i,:) = vdata{j(i)}(:)';  %%%%%%%%********** CHECK THIS AVERAGING **********%%
    legendstr = strvcat([char(D.varstr(i)) ': ' vdata{j(i)}.units(:)], legendstr);
    if i >= 2 & i <= length(D.varstr) 
        ystr = [char(ystr) '; ' char(D.varstr(i))];
    end;
end;
legendstr = flipud(legendstr);

handle = plot(meshgrid(timematrix, 1:length(D.varstr))', varmatrix');
xmin = min(timematrix);
xmax = max(timematrix);
if length(D.range) == 2
    ymin = min(D.range);
    ymax = max(D.range);
    set(gca, 'XLim', [xmin xmax], 'YLim', [ymin ymax]);
else
    set(gca, 'XLim', [xmin xmax]);
end;
%xlabel(char(V.xlabel));
%ylabel(char(D.ylabel));
%legend(legendstr, 0);

nc = close(nc); 


    