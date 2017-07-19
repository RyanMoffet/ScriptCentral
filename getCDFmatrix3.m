%% plot netCDF files (DISTRIBUTION)
%% 24 Feb. 2004

%% usage:  CDFplot(netCDF_filename, parameter string of variables to plot, type of graph to plot)
%% types: 'sec' -- number of seconds of since first record; 'julian' -- julian time
function [X,Y,Z] = CDFplot(varstr, CDFfilename, zcells);

ncquiet;
nc = netcdf(char(CDFfilename), 'nowrite');              % Open NetCDF file.
vdata = var(nc);      % Get variable data.

%% populate matrix with variable names
dstring = [];
for i = 1:length(vdata)
    dstring = strvcat(name(vdata{i}), dstring);
end;
dstring = flipud(dstring);  %% flip matrix to correct indices

%% indice for time and date matrix
tindex = strmatch('TIME', dstring, 'exact');
dindex = strmatch('DATE', dstring, 'exact');

year = floor(vdata{dindex}(:)/1e4);
if year < 10
    year = year + 2000;
else year = year + 1900;
end;
month = floor((vdata{dindex}(:) - floor(vdata{dindex}(:)/1e4).*1e4)/100);
day = mod(vdata{dindex}(:),100);

hour = floor(vdata{tindex}(:)/1e4);
minute = floor((vdata{tindex}(:) - floor(vdata{tindex}(:)/1e4).*1e4)/100);
sec = mod(vdata{tindex}(:),100);

X = datenum(year,month,day,hour,minute,sec) - datenum(year-1,12,31,0,0,0);

%% indices for variable matrix
try
    Z.index = strmatch(varstr, dstring, 'exact');
    Z.matrix = vdata{Z.index}(:);
    Z.data = squeeze(Z.matrix(:,1,:));
    Z.legendstr = strvcat([char(varstr) ': ' vdata{Z.index}.units(:)]);  
    Y = vdata{Z.index}.CellSizes(zcells);  %% get values for third dimension
catch
    Z.index = -1;  %% error in strmatch
    Z.matrix = []; 
    Z.data = [];
    Z.legendstr = [];
    Y = [];
    disp(['WARNING: Variable "' char(varstr) '" not found!  Removing variable from string.']);
end;


nc = close(nc); 


    