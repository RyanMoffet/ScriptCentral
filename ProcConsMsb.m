function [OutDat1,RawFin1]=ProcMsb(InId,Slope,Intercept,msmt,DaBounds,NumPart)

% Apparently this script will break up the scattering curve in the case
% of a severe notch in the raw and processed data. This notch is usually
% due to the nozzle (and nonsphericity??).
%
% DaBounds = [DaBounds(1,:);DaBounds(2,:),...]

for i=1:length(DaBounds(:,1))
   %% ConsPSD(InId,Slope,Intercept,msmt,DaBounds,NumPart)
    [proc,raw]=ConsPSD(InId,Slope,Intercept,msmt,DaBounds(i,:),NumPart);
    if i==1
        RawFin1=raw;
        OutDat1=proc;
    else
        RawFin1=[RawFin1;raw];
        OutDat1=[OutDat1;proc];
        clear raw proc
    end
end

figure,plot(OutDat1(:,1),OutDat1(:,2),'r.-',...
    'LineWidth',1,...
    'MarkerSize',5);
hold on,
plot(RawFin1(:,1),RawFin1(:,2),'b.','MarkerSize',2)
ylim([min(RawFin1(:,2)) max(OutDat1(:,2))])


    
