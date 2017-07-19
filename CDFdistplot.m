%% plot netCDF files (DISTRIBUTION)
%% 24 Feb. 2004

%% usage:  CDFplot(netCDF_filename, parameter string of variables to plot, type of graph to plot)
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
k = find(j > 1);
if any(k)
    D.varstr = D.varstr(k);
    j = j(k);
else
    disp('ERROR: no variables to plot');
    D.varstr = [];
    finish;
end;

if strcmp(lower(char(D.scale)), 'log')
    Z = log10(vdata{j(1)}(:)+eps);  %% get mxn of data matrix && take log10 of values
    Z = squeeze(Z(:,1,:)); %%%***************** CHECK VALIDITY OF THIS *******************%%%
elseif strcmp(lower(char(D.scale)), 'linear')
    Z = vdata{j(1)}(:);  %% get mxn of data matrix 
    Z = squeeze(Z(:,1,:)); %%%***************** CHECK VALIDITY OF THIS *******************%%%
end;
    
Y = vdata{j(1)}.CellSizes(D.zcells);  %% get values for third dimension
minZ = min(min(Z)');  %% minimum values for data matrix
if minZ < D.threshold; minZ = D.threshold; end;  %% apply threshold to data
maxZ = max(max(Z)');  %% maximum values for data matrix

zbin = [minZ:(maxZ-minZ)/D.contbins:maxZ];
[C1 hcp] = contourf(timematrix, Y, Z', zbin);
set(hcp, 'EdgeColor', 'none');
handle = get(hcp, 'Parent'); %% returns axis handle for post plot manipulations
xlabel(char(V.xlabel));
ylabel(char(D.ylabel));

%% add color bar and modify axis to show log-scale
hc = colorbar('horizontal');
set(hc, 'XTick', [], 'XTickLabel', [], ...
    'YTick', [], 'YTickLabel', []);
xlim = 10.^get(hc, 'Xlim');
d1 = axes('Position', get(hc, 'Position'), ...
    'TickDir', 'in', ...
    'TickLength', [0.01 0], ... 
    'Visible', 'on', 'Xlim', xlim, ...
    'XScale', 'log', ...
    'YTick', [], 'YTickLabel', [], .....
    'Color', 'none', ...
    'Box', 'on', 'Layer', 'top');
set(hc, 'XLabel', text('Parent', hc, 'String', char(D.zlabel)));
set(hc, 'Title', text('Parent', hc, 'String', [])); %% necessary to force xlabel in previous command

nc = close(nc); 


    