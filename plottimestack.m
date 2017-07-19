function plottimestack(startt,stopt,res,conc,size,time,timestr)

%% startt and stopt are datenums of start and stop time
%% res is the datenum of the resolution
%% conc s a cell array containing matrices for  each class. The matrices
%% contain rows of time, conlumns of size. 

nbin=(stopt-startt)/res;
binstart=startt;
binstop=startt+res;

for i=1:nbin
    starttimes(i)=binstart;
    stoptimes(i)=binstop;
    binstart=binstop;
    binstop=binstop+res;
end

for i=1:length(conc) %% loop over classes
    for j=1:length(conc{i}(:,1));       %% loop over times
        for k=1:length(conc{i}(j,:))
            if isnan(conc{i}(j,k))
                conc{i}(j,k)=0;
            end
        end
       concin(i,j)=trapz(log10(size),conc{i}(j,1:end));
    end
end

clr = [0 .5 0; .5 0 0; 1 .4 .2; 0 .2 1; 0 0 .5; .5 1 0; 1 1 0];
max_cluster = 7;
h = plot_temporal_bar(time,concin,{'ss','land','carbon','miss'},4);
%%% Set bar colors
for i = 1:4
    set(h(i),'FaceColor',clr(i,:),'EdgeColor',clr(i,:));
end
% last = time(end);
% first = time(1); %%% starting hour offset to start at midnight
% step = res; %%% 24 equals one day
% xlim([first,last]);%%%%%Can  use [1,last] or [first,last]
% xtic = get(gca, 'xtick');% set(gca,'XTick',[datenum(datstr)]')

set(gca,'XTick',[datenum(timestr)]')
datetick('x','mm/dd','keeplimits','keepticks')

title('Mass Concentrations for Calcofi Particle Classes');
xlabel('date')
ylabel('mass concentration')

%%_________________________________________________________________________

function [handle] = plot_temporal_bar(x,Matrix,SortedName,max_cluster)

figure,
handle = bar(x,Matrix(1:max_cluster,:)',1,'stack')%%1 sets width of bar > 1 equals overlap
title(inputname(1));
legend(SortedName{1:max_cluster},-1);

return