function CompAmbPslPhd(InIntens1,Size1,PslDat,range,NumBin,legendstr,xmax)

[idx1] = find(Size1 > range(1) & Size1 < range(2));
intens1 = InIntens1(idx1);

bincent = 0:(xmax/NumBin):xmax;
[counts1,centers1] = hist(intens1,bincent);% vector of intensity histogram counts

DistY1=[centers1',counts1'/sum(counts1)]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency

err1 = DistY1(:,2).*(sqrt(counts1)./counts1)';

figure,
% plot(DistY1(:,1),DistY1(:,2),'r.-'),hold on,
% plot(DistY2(:,1),DistY2(:,2),'b.-'),hold off,
errorbar(DistY1(:,1),DistY1(:,2),err1,err1,'r.-'),hold on,
errorbar(PslDat(:,1),PslDat(:,2),PslDat(:,3),PslDat(:,3),'b.-'),hold off,

xlabel('R (cm^{2}/particle)','FontSize',12)
ylabel('Normalized Counts','FontSize',12)
title(sprintf('PHDs from %g to %g',range(1),range(2)),'FontSize',12)
legend(legendstr)
