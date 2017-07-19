funstart=datenum('08-Nov-2004 07:00:00')-datenum(0,0,0,8,0,0);
stop=datenum('19-Nov-2004 08:00:00')-datenum(0,0,0,8,0,0);
res=datenum('1:00:00');
nbin=(stop-start)/res;
% 
% for i=1:length(class)
%     [claOID{i},claOIDX{i},claCNT{i},claBCUT,claBCET]=bin_on_column(class{i}...
%         ,'Time',start,stop,nbin,'lin');
% end

%% This code plots the temporals for each class and compares them with bsp
%% and bap. Use temporals.mat to access all the variables.
% for i=1:length(class)
%     figure,
%     hl1 = line(claBCET,claCNT{i},'Color','b','Marker','.');
%     ax1 = gca;
%     set(gca,'XTick',[datenum(datstr)]')
%     datetick('x','mm/dd','keeplimits','keepticks')
%     axis tight
%     YLabel('raw counts')
%     ax2 = axes('Position',get(ax1,'Position'),...
%         'YAxisLocation','right',...
%         'Color','none',...
%         'YColor','k');
%     hl2 = line(bapav(:,1)-datenum(0,0,0,8,0,0),bapav(:,2),'Color','k','Parent',ax2...
%         ,'Marker','.');
%     hl3 = line(bspav(:,1)-datenum(0,0,0,8,0,0),bspav(:,2),'Color','g','Parent',ax2...
%         ,'Marker','.');
%     legend([hl1,hl2,hl3],sprintf('%s',clstr{i}),'b_{ap}','b_{sp}',2)
%     set(gca,'XTick',[datenum(datstr)]')
%     datetick('x','mm/dd','keeplimits','keepticks')
%     axis tight
%     XLabel('date (PST)')
%     YLabel('b (m^{-1})')
%     FileName = sprintf('C%g%s.fig',i,clstr{i}); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end

% save temporals.mat

%%_________________________________________________________________________
%% Hits and Misses

% hit=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 1',start,stop));
% miss=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 0',start,stop));
% hittimes=get_column(hit,'Time');
% misstimes=get_column(miss,'Time');

[hrtime,hfrac]=RysHitMissPlot(misstimes,hittimes,start,stop,datstr)

%% Need to plot HR and SSA _______________________________
for i=1:length(ssa)
    if ssa(i)==0
        ssa(i)=NaN
    end
end
for i=1:length(hfrac)
    if hfrac(i)==0
        hfrac(i)=NaN
    end
end

for i=1:length(datstr)/2
    datstr1{i}=datstr{2*i};
end
    figure,
    hl1 = line(bapav(:,1)-datenum(0,0,0,8,0,0),ssa,'Color','b','Marker','.','LineWidth',3);
    ax1 = gca;
    set(gca,'XTick',[datenum(datstr1)]','FontSize',24)
    datetick('x','mm/dd','keeplimits','keepticks')
    axis tight
    YLabel('SSA')
    ax2 = axes('Position',get(ax1,'Position'),...
        'YAxisLocation','right',...
        'Color','none',...
        'YColor','k','FontSize',24);
    hl2 = line(hrtime,hfrac,'Color','k','Parent',ax2...
        ,'Marker','.','LineWidth',3);
    legend([hl1,hl2],'SSA','ATOFMS Hit Fraction',4)
    set(gca,'XTick',[datenum(datstr1)]')
    datetick('x','mm/dd','keeplimits','keepticks')
    axis tight
    XLabel('date (PST)')
    YLabel('ATOFMS Hit Fraction')

%     figure,plot(ssa,hfrac,'.')