fucntion PlotCalcofiTemporals(claBCET,claCNT,datstr,bapav,bspav)

%% This code plots the temporals for each class and compares them with bsp
%% and bap. Use temporals.mat to access all the variables.
for i=1:length(class)
    figure,
    hl1 = line(claBCET,claCNT{i},'Color','b','Marker','.');
    ax1 = gca;
    set(gca,'XTick',[datenum(datstr)]')
    datetick('x','mm/dd','keeplimits','keepticks')
    axis tight
    YLabel('raw counts')
    ax2 = axes('Position',get(ax1,'Position'),...
        'YAxisLocation','right',...
        'Color','none',...
        'YColor','k');
    hl2 = line(bapav(:,1)-datenum(0,0,0,8,0,0),bapav(:,2),'Color','k','Parent',ax2...
        ,'Marker','.');
    hl3 = line(bspav(:,1)-datenum(0,0,0,8,0,0),bspav(:,2),'Color','g','Parent',ax2...
        ,'Marker','.');
    legend([hl1,hl2,hl3],sprintf('%s',clstr{i}),'b_{ap}','b_{sp}',2)
    set(gca,'XTick',[datenum(datstr)]')
    datetick('x','mm/dd','keeplimits','keepticks')
    axis tight
    XLabel('date (PST)')
    YLabel('b (m^{-1})')
    FileName = sprintf('C%g%s.fig',i,clstr{i}); % Names the file (differently) for each cluster
    saveas (gcf,FileName, 'fig');
    close
end
