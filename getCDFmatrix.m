%% plot netCDF files
%% 24 Feb. 2004

%% usage:  CDFplot(time, data structure, file information structure)
%% types: 'sec' -- number of seconds of since first record; 'julian' -- julian time
function D = getCDFmatrix(varstr,CDFfilename);

ncquiet;
nc = netcdf(CDFfilename, 'nowrite');              % Open NetCDF file.
vdata = var(nc);      % Get variable data.

%% populate matrix with variable names
dstring = [];
for i = 1:length(vdata)
    dstring = strvcat(name(vdata{i}), dstring);
end;
dstring = flipud(dstring);  %% flip matrix to correct indices

%% indices for variable matrix
try
    D.index = strmatch(varstr, dstring, 'exact');
    D.data = vdata{D.index}(:);  %%%%%%%%********** CHECK THIS AVERAGING **********%%
    D.legendstr = strvcat([varstr ': ' vdata{D.index}.units(:)]);  
catch
    D.index = -1;  %% error in strmatch
    D.data = [];
    D.legendstr = [];
    disp(['WARNING: Variable "' char(D.varstr(i)) '" not found.']);
end;
nc = close(nc); 


    