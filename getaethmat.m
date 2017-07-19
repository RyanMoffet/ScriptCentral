function [x]=getaethmat(filename)

filestream = fopen(filename, 'r');

cnt=0; % row index
cnt1=1; % column index
while(feof(filestream) == 0)    
    lstring = fgets(filestream); % returns next line of the file    
    cnt=cnt+1;
    bstring=lstring;
    [date,bstring]=strtok(bstring,','); % cut out date and return rest of string in bstring
    [time,bstring]=strtok(bstring,','); % cut out time and return resto of string
    x(cnt,1)=datenum(date)+datenum(time); % make date and time the first column of the matrix x
    for i=1:26 % while there is still stuff left in the current line...
        cnt1=cnt1+1;
        [dat,bstring]=strtok(bstring,','); % take out each piece of data individually
        x(cnt,cnt1)=str2num(dat); % turn the data into a number and put in x
    end
    cnt1=1;
end  
fclose(filestream);