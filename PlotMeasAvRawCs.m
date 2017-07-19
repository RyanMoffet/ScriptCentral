function PlotMeasAvRawCs(InDat)
% InDat = [Size,CS,Err]
% Plot Results
figure,plot(InDat(:,1),InDat(:,2)...
    ,'-ok')
xlabel('D_{p} (\mum)','FontSize',10)
ylabel('Cross Section (cm^{2})','FontSize',10)
title('Cross Section Measurment vs. D_{a}')
