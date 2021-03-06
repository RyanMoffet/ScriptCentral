function PlotMeasTh(InDat,r2,ThDat,nkrho,sample,MinD,MaxD,varargin)
% InDat = [Size,CS,Err]
% r2 = [1,r;r,1] => r2=r2(1,2)^2
% ThDat = [D,CS]
% 
% sample is a string for a title
% Plot Results
Dens=nkrho(3);
for i=1:length(InDat(:,1))
    ScProcDat(i)=scdp(InDat(i,1),Dens);
end

% disp(sprintf('r^{2} = %g',r2(1,2)));

figure,plot(ScProcDat*nkrho(1),InDat(:,2),'-ok'),hold on,...
    plot(ThDat(:,1)*nkrho(1),ThDat(:,2),'-*k'),

xlabel('D_{p} (\mum)','FontSize',10)
ylabel(sprintf('Cross Section (cm^{2})','FontSize',10))
textx=(max(InDat(:,1))-min(InDat(:,1)))/5;
texty=(max(InDat(:,2))-min(InDat(:,2)))/1.1;
text(textx,texty,sprintf('m=%0.3g + %0.1ei rho=%0.3g',nkrho))
title(sprintf('Measurment vs. Theory %s',sample))
legendstr{1}=sprintf('measured r^{2} = %g',r2(1,2))
legendstr{2}=sprintf('m=%0.3g + %0.1ei rho=%0.3g',nkrho)

k=3;
NumStep=100;
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

ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
