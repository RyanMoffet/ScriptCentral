% aethtimes{1,1}={'02-Nov-2004 13:00:00','08-Nov-2004 03:35:00','13-Nov-2004 16:20:00','14-Nov-2004 07:25:00',...
%         '15-Nov-2004 23:40:00','16-Nov-2004 08:10:00','18-Nov-2004 07:10:00','19-Nov-2004 01:10:00'};
% aethtimes{2,1}={'08-Nov-2004 03:15:00','13-Nov-2004 16:00:00','14-Nov-2004 07:00:00','15-Nov-2004 23:20:00',...
%         '16-Nov-2004 07:45:00','18-Nov-2004 06:50:00','19-Nov-2004 00:50:00','19-Nov-2004 08:30:00'};
% 
% aeth(:,1)=aeth(:,1)+datenum(0,0,0,8,0,0);
[babs]=AethBabs(bspctd,aeth,aethtimes);

figure,plot(babs(:,1),babs(:,2),'r.-',bspctd(:,1),bspctd(:,2),'b.-'),
legend('bap','bsp',2)
set(gca,'XTick',[datenum(aethtimes{1,1})]')
datetick('x','mm/dd','keeplimits','keepticks')

[bapav]=averageaeth(babs,'08-Nov-2004 07:00:00','19-Nov-2004 08:00:00','1:00:00')
[bspav]=averageaeth(bspctd,'08-Nov-2004 07:00:00','19-Nov-2004 08:00:00','1:00:00')
plot(bspav(:,1),bspav(:,2)*1e6,'r.-',bspav(:,1),bsca,'g.-')


figure,plot(bapav(:,1),bapav(:,2),'k.-',bspav(:,1),bspav(:,2),'g.-'),
legend('b_{ap}','b_{sp}',2)
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')


ssa=(bspav(:,2))./(bapav(:,2)+bspav(:,2));

figure,plot(bapav(:,1),ssa,'k.-'),
legend('SSA',2)
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')

figure,plot(bspav(:,2),bapav(:,2))