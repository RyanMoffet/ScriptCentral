function PlotProcAB(ProcDatA,ProcDatB)

figure,...
    
plot(ProcDatA(:,1),ProcDatA(:,2),'r.-',...
    'LineWidth',1,...
    'MarkerSize',5);

hold on,

plot(ProcDatB(:,1),ProcDatB(:,2),'g.-',...
    'LineWidth',1,...
    'MarkerSize',5);



% Do a legend

legend('PMT A','PMT B')

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(RawDat(:,2)) max(RawDat(:,2))]) 

% label axes

xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('Intensity (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
