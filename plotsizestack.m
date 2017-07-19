function plotsizestack(conc,size,plottime,res,time,timestr)

%% res is the datenum of the resolution
%% conc s a cell array containing matrices for  each class. The matrices
%% contain rows of time, conlumns of size. 
%% res is the datenum of the resolution
%% time is the datenum of the time that the mass distribution is to be
%% plotted
%% timestr is the entire time sting with elements indexed according to the
%% rows of conc

idx = find(datenum(datestr(time))==plottime);

for i=1:length(conc)
    plotmatrix(i,:)=conc{i}(idx,:);
end

clr = [0 .5 0; .5 0 0; 1 .4 .2; 0 .2 1; 0 0 .5; .5 1 0; 1 1 0];
max_cluster = 7;
h = plot_temporal_bar(size,plotmatrix,{'ss','land','carbon','miss'},5);
%%% Set bar colors
for i = 1:5
    set(h(i),'FaceColor',clr(i,:),'EdgeColor',clr(i,:));
end
% last = time(end);
% first = time(1); %%% starting hour offset to start at midnight
% step = res; %%% 24 equals one day
% xlim([first,last]);%%%%%Can  use [1,last] or [first,last]
% xtic = get(gca, 'xtick');% set(gca,'XTick',[datenum(datstr)]')

set(gca,'XScale','log')
% set(gca,'XTick',[datenum(timestr)]')
% datetick('x','mm/dd','keeplimits','keepticks')

title('Mass Distributions for Calcofi Particle Classes');
xlabel('D_{p} {\mum}')
ylabel('Mass Concentration (g/m^{3}')

%%_________________________________________________________________________

function [handle] = plot_temporal_bar(x,Matrix,SortedName,max_cluster)

figure,
handle = bar(x,Matrix(1:max_cluster,:)',1,'stack')%%1 sets width of bar > 1 equals overlap
title(inputname(1));
legend(SortedName{1:max_cluster},-1);

return