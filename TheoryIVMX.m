function TheoryIVMX(MinD,MaxD,varargin)

%% CompareWithTheory 
%% allows one to plot the processed measured results together with
%% theoretical results. 
%% procin=[
%% retrivedpars=[nretrived,kretreived,rhoretrived]
%% varargin={[n1,k1],[n2,k2],...}


% MinD=min(procin(:,1));
% MaxD=max(procin(:,1));
NumStep=100;

% if tstdens~=retrivedpars(3)
%     for i=1:length(procin(:,1))
%         CorrectedSiz(i)=scdp(procin(i,1),tstdens);
%         CorrectedSiz1(i)=scdp(procin(i,1),retrivedpars(3));
%     end         
%     figure,plot(CorrectedSiz,procin(:,2),'r.-','LineWidth',...
%         1,'MarkerSize',5),hold on,
%     plot(CorrectedSiz1,procin(:,2),'r*-','LineWidth'...
%         ,1,'MarkerSize',5),hold on,
%     [SizeBf,RespBf]=ThDatGen(MinD,MaxD,NumStep,0.532,...
%         retrivedpars(1),retrivedpars(2));
%     plot(SizeBf,RespBf,'k-.')
%     legendstr={sprintf('measurement\rho=%g',tstdens),...
%             sprintf('measurement\rho=%g',retrivedpars(3)),...
%             sprintf('best fit m=%g+%gi',retrivedpars(1),retrivedpars(2))};
%     k=4;
% else
%     for i=1:length(procin(:,1))
%         CorrectedSiz(i)=scdp(procin(i,1),retrivedpars(3));
%     end
%     figure,plot(CorrectedSiz,procin(:,2),'r.-','LineWidth'...
%         ,1,'MarkerSize',5),hold on,
%     [SizeBf,RespBf]=ThDatGen(MinD,MaxD,NumStep,0.532,...
%         retrivedpars(1),retrivedpars(2));
%     plot(SizeBf,RespBf,'k-.')
%     legendstr{k}={sprintf('measurement\rho = %g',retrivedpars(3)),...
%             sprintf('best fit m=%g+%gi',retrivedpars(1),retrivedpars(2))};  
%     k=3;
% end 
k=1;
colors={'b-','g-','r-','c-','m-','k-','y-'};

for i=1:length(varargin)
    [Size{i},Resp{i}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        varargin{i}(1),varargin{i}(2));
    mx=Size{i}*varargin{i}(1);
    plot(mx,Resp{i},colors{i}),hold on,
    legendstr{k}=sprintf('theory m=%g+%gi',varargin{i});
    k=k+1;
end


legend(legendstr,0)

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(procin(:,2)) max(procin(:,2))]) 

% label axes

xlabel('n*D','FontSize',24,...
    'FontName','Times New Roman')

ylabel('Intensity (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')




