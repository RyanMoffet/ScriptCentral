function PlotMeasTh(InDat,r2,ThDat,nkrho,sample)
% InDat = [Size,CS,Err]
% r2 = [1,r;r,1] => r2=r2(1,2)^2
% ThDat = [D,CS]
% Plot Results
Dens=nkrho(3);
for i=1:length(InDat(:,1))
    ScProcDat(i)=scdp(InDat(i,1),Dens);
end

% disp(sprintf('r^{2} = %g',r2(1,2)));

figure,plot(ThDat(:,1),ThDat(:,2),'-*k'),hold on,...
    plot(ScProcDat,InDat(:,2),'-ok')

xlabel('D_{p} (\mum)','FontSize',10)
ylabel(sprintf('R (cm^{2})','FontSize',10))
xmin = min(ScProcDat(:,1));
textx=(max(InDat(:,1))-min(InDat(:,1)))/5;
texty=(max(InDat(:,2))-min(InDat(:,2)))/1.1;
text(textx,texty,sprintf('m=%0.3g + %0.1ei rho=%0.3g',nkrho))
title(sprintf('Measurment vs. Theory %s',sample))
legend(sprintf('measured r^{2} = %g',r2(1,2)^2))

