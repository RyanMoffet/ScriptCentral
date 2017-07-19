function [CorrectNeph,sumbsca]=CompareBscat(TotBsca,TruncBsca,AtofTime,inneph,NephTime,measstr)

linestr={'b.-','g.-','r.-','k.-','c.-','m.-'};
legendstr=measstr;

figure,
for i=1:length(TruncBsca)
    for j=1:length(TruncBsca{i}(1,:))
        if TruncBsca{i}(1,j) == 0 | inneph(j) == 0
            TruncBsca{i}(1,j)=NaN;
            TotBsca{i}(1,j)=NaN;
%             inneph(j)=NaN;
%             NephTime(j)=NaN;
        else
            TruncBsca{i}(1,j)=TruncBsca{i}(1,j);
            TotBsca{i}(1,j)=TruncBsca{i}(1,j);
            AtofTime(1,j)=AtofTime(1,j);
            inneph(j)=inneph(j);
        end
    end
    plot(AtofTime,TruncBsca{i},linestr{i})
    hold on
end
plot(NephTime,inneph,linestr{i+1})
xlabel('Time')
ylabel('B_{sca}')
legend(legendstr);
datstr = {'11/08/04','11/09/04','11/10/04','11/11/04','11/12/04','11/13/04','11/14/04','11/15/04','11/16/04'...
    '11/17/04','11/18/04','11/19/04'}
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')


for i=1:length(TruncBsca{1}(1,:))
    sumbsca(i)=nansum([TotBsca{1}(i),TotBsca{2}(i),TotBsca{3}(i)]);
    sumTruncBsca(i)=nansum([TruncBsca{1}(i),TruncBsca{2}(i),TruncBsca{3}(i)]);
end
CorrectNeph=inneph.*(sumbsca./sumTruncBsca);
figure,plot(AtofTime,(sumTruncBsca./sumbsca-1)*100);

figure,plot(AtofTime,sumTruncBsca,linestr{1},NephTime,CorrectNeph,linestr{2});
legend('SumOfClasses','Neph')
xlabel('Time')
ylabel('B_{sca}')
datstr = {'11/08/04','11/09/04','11/10/04','11/11/04','11/12/04','11/13/04','11/14/04','11/15/04','11/16/04'...
    '11/17/04','11/18/04','11/19/04'}
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')

    