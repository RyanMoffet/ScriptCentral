function partab(sample,raw,nkrhoA,nkrhoB,sqerrA,sqerrB,filename,flag)
% put scattering data in a csv file...

fid = fopen(sprintf('%s.csv',filename),'W');
if flag==1
    fprintf(fid, 'single parameter fit\n');
    fprintf(fid, 'class,nA,nB,k,rho,sqerrA,sqerrB,N,avg n,std n,comment\n');
elseif flag==2
    fprintf(fid, 'dual parameter fit\n');
    fprintf(fid, 'class,nA,nB,k,rhoA,rhoB,sqerrA,sqerrB,N,avg n,std n,avg rho, std n,comment\n');
elseif flag==3
    fprintf(fid, 'triple parameter fit\n');
    fprintf(fid, 'class,nA,nB,kA,kB,rhoA,rhoB,sqerrA,sqerrB,N,avg n,std n,avg k, std k,avg rho, std rho,comment\n');
% elseif flag==4
%     fprintf(fid, 'dual parameter fit\n');
%     fprintf(fid, 'class,nA,nB,kA,kB,rhoA,rhoB,sqerrA,sqerrB,N,avg n,std n,avg k, std k,avg rho, std rho,comment\n');
end
for j=1:length(sample)
    if isempty(nkrhoA{j})
        continue
    end
    if flag==1
        N=length(raw{j}(:,1))
        fprintf(fid,'%s,',sample{j});
        fprintf(fid,'%g,%g,', nkrhoA{j}(1),nkrhoB{j}(1));
        fprintf(fid,'%g,',nkrhoA{j}(2));
        fprintf(fid,'%g,',nkrhoA{j}(3));
        fprintf(fid,'%g,%g,',sqerrA{j}/(N-flag),sqerrB{j});
        fprintf(fid,'%d,',N);
        fprintf(fid,'%g,',mean([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid,'%g,',std([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid, '\n');
    elseif flag==2
        N=length(raw{j}(:,1));
        fprintf(fid,'%s,',sample{j});
        fprintf(fid,'%g,%g,', nkrhoA{j}(1),nkrhoB{j}(1));
        fprintf(fid,'%g,',nkrhoA{j}(2));
        fprintf(fid,'%g,%g,',nkrhoA{j}(3),nkrhoB{j}(3));
        fprintf(fid,'%g,%g,',sqerrA{j}/(N-flag),sqerrB{j});
        fprintf(fid,'%d,',N);
        fprintf(fid,'%g,',mean([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid,'%g,',std([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid,'%g,',mean([nkrhoA{j}(3),nkrhoB{j}(3)]));
        fprintf(fid,'%g,',std([nkrhoA{j}(3),nkrhoB{j}(3)]));
        fprintf(fid, '\n');
    elseif flag==3
        N=length(raw{j}(:,1));       
        fprintf(fid,'%s,',sample{j});
        fprintf(fid,'%g,%g,', nkrhoA{j}(1),nkrhoB{j}(1));
        fprintf(fid,'%g,%g,',abs(nkrhoA{j}(2)),abs(nkrhoB{j}(2)));
        fprintf(fid,'%g,%g,',nkrhoA{j}(3),nkrhoB{j}(3));
        fprintf(fid,'%g,%g,',sqerrA{j}/(N-flag),sqerrB{j});
        fprintf(fid,'%d,',N);
        fprintf(fid,'%g,',mean([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid,'%g,',std([nkrhoA{j}(1),nkrhoB{j}(1)]));
        fprintf(fid,'%g,',mean([nkrhoA{j}(2),nkrhoB{j}(2)]));
        fprintf(fid,'%g,',std([abs(nkrhoA{j}(2)),abs(nkrhoB{j}(2))]));
        fprintf(fid,'%g,',mean([nkrhoA{j}(3),nkrhoB{j}(3)]));
        fprintf(fid,'%g,',std([nkrhoA{j}(3),nkrhoB{j}(3)]));
        fprintf(fid, '\n');
    end
end
fclose(fid);
