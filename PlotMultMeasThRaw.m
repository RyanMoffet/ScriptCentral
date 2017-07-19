function PlotMultMeasThRaw(procin,retrivedpars,tstdens,varargin)

%% CompareWithTheory 
%% allows one to plot the processed measured results together with
%% theoretical results. 
%% procin={[procin1],[procin2]}
%% retrivedpars={[nretrived,kretreived,rhoretrived], ...}
%% varargin={[n1,k1],[n2,k2],...}


MinD=0.1;                 %%min(procin(:,1));
MaxD=3;                   %%max(procin(:,1));
NumStep=300;

MeasClr={'r.' 'k.'};
TheoClr={'b-' 'g-'};

if tstdens~=retrivedpars(1,3)
%     for i=1:length(procin(:,1))
        CorrectedSiz=scdp(procin(:,1),tstdens);
        CorrectedSiz1=scdp(procin(:,1),retrivedpars(3));
%     end         
    figure,plot(CorrectedSiz,procin(:,2),'b.','LineWidth',...
        1,'MarkerSize',5),hold on,
    plot(CorrectedSiz1,procin(:,2),'r.','LineWidth'...
        ,3,'MarkerSize',5),hold on,
    [SizeBf,RespBf]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        retrivedpars(1),retrivedpars(2));
    plot(SizeBf,RespBf,'k.-')
    legendstr={sprintf('measurement \rho=%g',tstdens),...
            sprintf('measurement \rho=%g',retrivedpars(3)),...
            sprintf('best fit m=%g+%gi',retrivedpars(1),retrivedpars(2))};
    k=4;
else
    figure,
%     for j=1:length(procin)
%         for i=1:length(procin{j}(:,1))
            CorrectedSiz=scdpArray(procin(:,1),retrivedpars(3));
%         end
        plot(CorrectedSiz,procin(:,2),'r.'),hold on,
        k=1;
        legendstr{k}='Raw'; 
        [SizeBf,RespBf]=ThDatGen(MinD,MaxD,NumStep,0.532,...
            retrivedpars(1),retrivedpars(2));
        plot(SizeBf,RespBf,'k-','LineWidth',3),hold on,    
        k=2;
        legendstr{k}=sprintf('Theory n=%g',retrivedpars(1));%% This plots the theoretical data
%     end
    k=3;
end 

colors={'b-','g-','r-','c-','m-','k-','y-'};

if ~isempty(varargin)
    for i=1:length(varargin)
        [Size{i},Resp{i}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
            varargin{i}(1),varargin{i}(2));
        plot(Size{i},Resp{i},colors{i},'LineWidth',3);
        legendstr{k}=sprintf('Theory m=%g+%gi',varargin{i});
        k=k+1;
    end
end


legend(legendstr,0)

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(procin(:,2)) max(procin(:,2))]) 

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('Intensity (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')




