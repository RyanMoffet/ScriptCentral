function timematrix = getCDFtime(V);

ncquiet;
nc = netcdf(char(V.CDFfilename), 'nowrite');              % Open NetCDF file.
vdata = var(nc);      % Get variable data.

%% populate matrix with variable names
dstring = [];
for i = 1:length(vdata)
    dstring = strvcat(name(vdata{i}), dstring);
end;
dstring = flipud(dstring);  %% flip matrix to correct indices

%% indice for time and date matrix
t = strmatch('TIME', dstring, 'exact');
d = strmatch('DATE', dstring, 'exact');

year = floor(vdata{d}(:)/1e4);
if year < 10
    year = year + 2000;
else year = year + 1900;
end;
month = floor((vdata{d}(:) - floor(vdata{d}(:)/1e4).*1e4)/100);
day = mod(vdata{d}(:),100);

hour = floor(vdata{t}(:)/1e4);
minute = floor((vdata{t}(:) - floor(vdata{t}(:)/1e4).*1e4)/100);
sec = mod(vdata{t}(:),100);

if strcmp(lower(char(V.plottype)), 'sec')
    timematrix = datenum(year,month,day,hour,minute,sec) - datenum(year-1,12,31,0,0,0);
    timematrix = (timematrix - min(timematrix))*86400;
elseif strcmp(upper((V.plottype)), 'JULIAN')
   timematrix = datenum(year,month,day,hour,minute,sec) - datenum(year-1,12,31,0,0,0);
else
   disp(['ERROR in time string: ' upper(char(V.plottype)) ' is not valid!']);
   timematrix = -1; %% error flag
end;

close(nc);