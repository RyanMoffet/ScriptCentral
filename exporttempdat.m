%% export temp dat



filename={'subscattsp' 'supscattsp'};
for i=1:length(TempOuthit)
    fid = fopen(sprintf('%s.csv',filename{i}),'W');
    for k=1:length(TempOuthit{1,i}(:,1));
        fprintf(fid,'%s,',datestr(TempOuthit{1,i}(k,1)));
        if TempOuthit{1,i}(k,2)==0
            fprintf(fid,',,\n');
        else
            fprintf(fid,'%g,',TempOuthit{1,i}(k,2));
            fprintf(fid,'%g,\n',TempOuthit{2,i}(k,2));
        end
    end
end
clear filename