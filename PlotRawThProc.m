function PlotRawThProc(RawDat,ProcDat,Dens,n)

figure,...
[ThDat(1,:),ThDat(2,:)]=ThDatGen(.1,3,100,0.532,...
        n,0);% % % for i=1:length(RawDat)
% % %     ScRawDat(i)=scdp(RawDat(i,1),Dens);
% % % end
ScRawDat = scdpArray(RawDat(:,1),Dens);
% % % for i=1:length(ProcDat)
% % %     ScProcDat(i)=scdp(ProcDat(i,1),Dens);
% % % end
ScProcDat = scdpArray(ProcDat(:,1),Dens);

plot(ScRawDat,RawDat(:,2),'b.','MarkerSize',2);

hold on,

plot(ScProcDat,ProcDat(:,2),'r.-',...
    'LineWidth',2,...
    'MarkerSize',8);

hold on,

plot(ThDat(1,:),ThDat(2,:),'k-',...
    'LineWidth',3,...
    'MarkerSize',8);

hold on,

% Do a legend

legend('Raw Data','Processed Data','Best Fit to Theory')

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

ylim([min(RawDat(:,2)) max(RawDat(:,2))]) 

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')

% create annotation with n and rho

text(0,0,[sprintf('n = %g ',n), '\rho' ,sprintf('= %g',Dens)]...
    ,'FontSize',18)



