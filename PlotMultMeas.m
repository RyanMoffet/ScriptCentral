function PlotMultMeas(procin,retrivedpars,samplestr)

%% CompareWithTheory 
%% allows one to plot the processed measured results together with
%% theoretical results. 
%% procin={[procin1],[procin2]}
%% retrivedpars={[nretrived,kretreived,rhoretrived], ...}
%% varargin={[n1,k1],[n2,k2],...}

colors={'b-','g-','r-','c-','m-','k-','y-'};

for j=1:length(procin)
    for i=1:length(procin{j}(:,1))
        CorrectedSiz(i)=scdp(procin{j}(i,1),retrivedpars{j}(3));
    end         
    plot(CorrectedSiz',procin{j}(:,2),colors{j},'LineWidth'...
        ,1,'MarkerSize',5),hold on,
    clear CorrectedSiz
end

legend(samplestr,0)

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(procin(:,2)) max(procin(:,2))]) 

% label axes

xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')




