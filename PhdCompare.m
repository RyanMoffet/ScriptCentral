function PhdCompare(InIntens1,Size1,InIntens2,Size2,range,NumBin,legendstr,xmax)

[idx1] = find(Size1 > range(1) & Size1 < range(2));
[idx2] = find(Size2 > range(1) & Size2 < range(2));
intens1 = InIntens1(idx1);
intens2 = InIntens2(idx2);

bincent = 0:(xmax/NumBin):xmax;
[counts1,centers1] = hist(intens1,bincent);% vector of intensity histogram counts
[counts2,centers2] = hist(intens2,bincent);% vector of intensity histogram counts

DistY1=[centers1',counts1'/sum(counts1)]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency
DistY2=[centers2',counts2'/sum(counts2)]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency

err1 = DistY1(:,2).*(sqrt(counts1)./counts1)';
err2 = DistY2(:,2).*(sqrt(counts2)./counts2)';

figure,
% plot(DistY1(:,1),DistY1(:,2),'r.-'),hold on,
% plot(DistY2(:,1),DistY2(:,2),'b.-'),hold off,
errorbar(DistY1(:,1),DistY1(:,2),err1,err1,'r.-'),hold on,
errorbar(DistY2(:,1),DistY2(:,2),err2,err2,'b.-'),hold off,

xlabel('R (cm^{2}/particle)','FontSize',32)
ylabel('Normalized Counts','FontSize',32)
title(sprintf('PHDs from %g to %g',range(1),range(2)),'FontSize',12)
set(gca,'FontSize',24)



legend(legendstr)
