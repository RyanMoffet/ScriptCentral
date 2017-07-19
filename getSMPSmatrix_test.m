%%% retrieve SMPS matrix information
%%% 03 April 2004
%%% X = juliantime; Y = binmidpoints; Z = data
filename = 'C:\Data\CIFEX\Trinidad Head\APS\aps.txt';
% function [X,Y,Z] = getSMPSmatrix_test(filename);

filestream = fopen(filename, 'r');
cnt = 0;
while(feof(filestream) == 0)
    lstring = fgets(filestream);
   
    %% get size bins in SMPS data
    if(strncmp('Sample #', lstring, 8))
        bstring = lstring;
        for i=1:5  %%% Read off first 4 columns for size bins
            [a bstring] = strtok(bstring, ','); end;
                   Y = str2num(strtok(bstring, 'E'));%E marks end of size bins and beginning of text -- Event 1 ...
    end;
    
    %% get data for each size bin
    if length(str2num(strtok(lstring, ','))) == 1
        cnt = cnt + 1;
        bstring = lstring;
        [a bstring] = strtok(bstring, ',');
        %% Parse date and time and convert to julian time
        [datestamp, bstring] = strtok(bstring, ',');
        [timestamp, bstring] = strtok(bstring, ','); 
        [blank,bstring] = strtok(bstring, ',');% skip column
        [blank,bstring] = strtok(bstring, ',');% skip column
        X(cnt) = datenum(datestamp) - datenum(str2num(datestr(datenum(datestamp), 10))-1,12,31) + datenum(timestamp);
        for i=1:length(Y)
            [d bstring] = strtok(bstring, ',');
            Z(cnt,i) = str2num(d); end;
    end;
end;
X = X';
Z = Z';  % reorient matrix for contour plotting
fclose(filestream);