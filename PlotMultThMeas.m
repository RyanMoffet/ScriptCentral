function PlotMultThMeas(InMeas,InProc,varargin)

MinD=0.1;                 %%min(procin(:,1));
MaxD=3;                   %%max(procin(:,1));
NumStep=300;

figure, 
plot(InMeas(:,1),InMeas(:,2),'k.','MarkerSize',3),hold on,
plot(InProc(:,1),InProc(:,2),'r.-','LineWidth',3),hold on,
legendstr = {'Raw','Proc'};
k=3;

if ~isequal(length(varargin{1}),3)
    InProc1=varargin{1};
    plot(InProc1(:,1),InProc1(:,2),'r.-','LineWidth',3),hold on,
    legendstr{k} = 'Proc';
    k = 4;
    j = 2;
else
    j = 1;
end

colors={'b-','g-','r-','c-','m-','k-','y-'};    
for i=j:length(varargin)
    [Size{i},Resp{i}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        varargin{i}(1),varargin{i}(2));
    plot(ScdaArray(Size{i},varargin{i}(3)),Resp{i},colors{i},'LineWidth',3),hold on,
    legendstr{k}=sprintf('Theory m=%g+%gi \rho_{eff} = %g',varargin{i});
    k=k+1;
end
hold off

legend(legendstr,0)

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(procin(:,2)) max(procin(:,2))]) 

% label axes

xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')

