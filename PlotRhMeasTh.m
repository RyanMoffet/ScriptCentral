function PlotRhMeasTh(Raw,Thnkr,Clust)

%% Plots raw and theoretical data for different RH values
%% Raw is a cell array of raw data
%% Th is a cell array of the best fit data
%% Clust is the cluster number vector

MinD=0.1;                 %%min(procin(:,1));
MaxD=3;                   %%max(procin(:,1));
NumStep=300;
figure,
for i = Clust
    plot(Raw{i,3}(:,2),Raw{i,3}(:,4),'r.',...
        Raw{i,2}(:,2),Raw{i,2}(:,4),'g.',...
        Raw{i,1}(:,2),Raw{i,1}(:,4),'b.');
    hold on,
    [Size{i,3},Resp{i,3}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        Thnkr{i,3}(1),Thnkr{i,3}(2));
    [Size{i,2},Resp{i,2}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        Thnkr{i,2}(1),Thnkr{i,2}(2));
    [Size{i,1},Resp{i,1}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        Thnkr{i,1}(1),Thnkr{i,1}(2));
    plot(ScdaArray(Size{i,3},Thnkr{i,3}(3)),Resp{i,3},'r-','LineWidth',3),hold on,
        plot(ScdaArray(Size{i,2},Thnkr{i,2}(3)),Resp{i,2},'g-','LineWidth',3),hold on,
        plot(ScdaArray(Size{i,1},Thnkr{i,1}(3)),Resp{i,1},'b-','LineWidth',3),hold on
end


