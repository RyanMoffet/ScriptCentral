function ABProcErrComp(MeasA,MeasB,legendstr)

%% MeasA/B = [Dp,Ratofms,Err]
%% Out = [Dp,AvRatofms,Diff]

figure,
errorbar(MeasA(:,1),MeasA(:,2),MeasA(:,3),'r-'),hold on,
errorbar(MeasB(:,1),MeasB(:,2),MeasB(:,3),'b-')
legend(legendstr)

