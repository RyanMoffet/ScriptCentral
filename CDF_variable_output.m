clear;
ncquiet;
CDFfilename = '20040325_2.c25.nc';

nc = netcdf(CDFfilename, 'nowrite');              % Open NetCDF file.
vdata = var(nc);      % Get variable data.

%% populate matrix with variable names
dstring = [];
for i = 1:length(vdata)
    dstring = strvcat(name(vdata{i}), dstring);
end;
dstring = flipud(dstring);  %% flip matrix to correct indices
disp(' ');
disp(' ');
disp(' ');
for i=1:length(dstring)
    disp([num2str(i) ': ' dstring(i,:)]);
    disp(['long_name: ' vdata{i}.long_name(:)]);
    disp(['units: ' vdata{i}.units(:)]);
    disp(['size: ' num2str(size(vdata{i}))]);
 %   disp(['status: ' vdata{i}.Status(:)]);
    disp(' ');
end;
        