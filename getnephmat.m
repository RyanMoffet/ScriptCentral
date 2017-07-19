function [x]=getnephmat(filename)

filestream = fopen(filename, 'r');

cnt=0; % row index
cnt1=1; % column index
while(feof(filestream) == 0)    
    lstring = fgets(filestream); % returns next line of the file    
    cnt=cnt+1;
    bstring=lstring;
    [trash,bstring]=strtok(bstring); % cut out time and return resto of string
    for i=1:6
        if i==1
            [dattime{i},bstring]=strtok(bstring); % cut out time and return resto of string
            dateandtime(i)=str2num(sprintf('20%s',dattime{i}));
        else
            [dattime{i},bstring]=strtok(bstring); % cut out time and return resto of string
            dateandtime(i)=str2num(dattime{i});
        end
    end
    x(cnt,1)=datenum(dateandtime); % make date and time the first column of the matrix x
    for i=1:5 % now for the last five columns
        cnt1=cnt1+1;
        [dat,bstring]=strtok(bstring); % take out each piece of data individually
        x(cnt,cnt1)=str2num(dat); % turn the data into a number and put in x
    end
    cnt1=1;
end  
fclose(filestream);