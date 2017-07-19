function [Out] = CalSMPS(filename)
%%% retrieve SMPS matrix information
%%% 03 April 2004
%%% X = juliantime; Y = binmidpoints; Z = data

filestream = fopen(filename, 'r');
rowcnt = 0;
colcnt = 0;
while(feof(filestream) == 0)
    lstring = fgets(filestream); %% This gets the line
    rowcnt=rowcnt+1;
    bstring = lstring;
    while ~isempty(bstring)
        colcnt = colcnt + 1;
        [a bstring] = strtok(bstring);
        if isempty(bstring)
            continue
        else
            if strcmp(a,'NAN')
                b='0';
            else
                b=a;
            end
            Out(rowcnt,colcnt) = str2num(b);
        end
    end;
    colcnt=0;
end;  
fclose(filestream);