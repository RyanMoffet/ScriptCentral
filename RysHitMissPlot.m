function [hbctr,hr]=RysHitMissPlot(misstime,hittime,start,stop,timestr)

%% Hittime and misstime are vectors of times for hit and miss pids
resolution=datenum('1:00:00');
nbin=(stop-start)/resolution;
[hitcnt,hbctr]=hist(hittime,nbin);
[misscnt,mbctr]=hist(misstime,nbin);

figure,plot(hbctr,hitcnt,'r.-',mbctr,misscnt,'k.-');
legend('hits','misses',2)
set(gca,'XTick',[datenum(timestr)]')
datetick('x','mm/dd','keeplimits','keepticks')

hr=(hitcnt./(misscnt+hitcnt))
figure,plot(hbctr,hr,'r.-');
legend('Hit %',2)
set(gca,'XTick',[datenum(timestr)]')
datetick('x','mm/dd','keeplimits','keepticks')

