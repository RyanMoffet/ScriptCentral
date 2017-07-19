function PlotRaw(InId,DaBounds,msmt)

%% Plots raw scattering data

StartSize=DaBounds(1);StopSize=DaBounds(2);

FilterId=run_query(InId,sprintf('Da > %g and Da < %g'...
    ,DaBounds(1),DaBounds(2)));

[Size,Intens]=get_column(FilterId,'Da',sprintf('%s',msmt));

figure,plot(Size,Intens,'b.')
