function plotapstemps(time,size,conc)
datstr={'11/08/04','11/09/04','11/10/04','11/11/04',...
        '11/12/04','11/13/04','11/14/04','11/15/04','11/16/04','11/17/04',...
        '11/18/04','11/19/04'};
% contourf(time,size,conc,linspace(0.05e-12,0.7e-10,20))
contourf(time,size,conc,[0.5e-12,1e-12,5e-12,1e-11,1.5e-11,2e-11,2.5e-11,3e-11,4e-11,4.5e-11,5e-11])
% Xlim([.2,5])
colorbar
set(gca,'TickDir','out')
set(gca,'YScale','log')
set(gca,'Color',[0,0,0])
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')
set(gca, 'YTick', [0.01,0.1,1,10])
xlabel('Time');
ylabel('D_{p} (\mum)');
