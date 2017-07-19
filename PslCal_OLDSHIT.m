% Timeline For SallysDust
% PSLs 
psl{1}=run_query('Time = [15-Jun-2004T21:01:51 15-Jun-2004T21:28:35]'); % 250nm PSL
psl{2}=run_query('Time = [15-Jun-2004T19:59:46 15-Jun-2004T20:18:37]'); % 300nm PSL
psl{3}=run_query('Time = [15-Jun-2004T19:34:51 15-Jun-2004T19:53:09]'); % 420nm PSL
psl{4}=run_query('Time = [15-Jun-2004T19:08:53 15-Jun-2004T19:29:40]'); % 600nm PSL
psl{5}=run_query('Time = [15-Jun-2004T18:39:53 15-Jun-2004T19:01:53]'); % 810nm PSL
psl{6}=run_query('Time = [15-Jun-2004T18:07:07 15-Jun-2004T18:35:13]'); % 990nm PSL
psl{7}=run_query('Time = [15-Jun-2004T17:43:52 15-Jun-2004T18:04:17]'); % 1500nm PSL
psl{8}=run_query('Time = [15-Jun-2004T20:30:14 15-Jun-2004T20:56:08]'); % 2700nm PSL
% analyse PSLs
% first do a size calibration based on speeds
NumBin=1000;
PslSizes=[250,300,420,600,810,990,1500,2700]; % PSL sizes
for i = 1:length(psl)
    [Speed{i},Size{i}] = get_column(psl{i},'Velocity','Da'); % make columns of speed and size for different psl samples defined above
    avg=mean(Speed{i});stdev=std(Speed{i}); % calc mean and stdev of the speeds
    Nstdev=1;
    for N = 1:NumBin + 1
        edges(1,N)=[avg-Nstdev*stdev+(2*Nstdev*stdev*(N-1))/(NumBin)]; % calculate the edges of the bins for plotting the speed histograms
    end
    for j=1:length(edges)
        centers(1,j)=[edges(j)+2*Nstdev*stdev/(2*NumBin)]; % this finds the centers of the bins whos edges were defined above
    end
    HisDat = histc(Speed{i},edges);% vector of speed histogram counts
    ModDat=[centers;HisDat'];%histogram data in [x,y] pairs
    k=1;j=1;
    for j=1:length(ModDat(1,:))
        if ModDat(2,j)>ModDat(2,k); %find most frequent bin (mode) which will be defined as ModDat(2,k)
            k=j;
        end
        j=j+1;
    end
    SpeedMode(i)=ModDat(1,k); % this gives the speed at the location of the distribution mode
    subplot(3,3,i),bar(edges,HisDat,'histc') % these next few lines make the speed histogram plots
    xlim([min(edges),max(edges)])
    xlabel('Speed (m/s)','FontSize',10),ylabel('frequency','FontSize',10)
    title(sprintf('%d nm PSL',PslSizes(i)),'FontSize',10)
    set(gca, 'XMinorTick', 'on')
    set(gca, 'xticklabel', ceil(min(edges)):ceil((max(edges)-min(edges))/10):ceil(max(edges)))
    set(gca, 'xtick', ceil(min(edges)):ceil((max(edges)-min(edges))/10):ceil(max(edges)))
    set(gca, 'FontSize', 6)
    clear edges
end
n=3; % order of polynomial to be fit
[p,s]=polyfit(SpeedMode,PslSizes,n); % fits data to polynomial
xi=linspace(250,500,100); % creates data input for the polynomial evaluation
zz=polyval(p,xi); % evaluate the polynomial
figure,plot(SpeedMode,PslSizes,'o',xi,zz)
text(275,polyval(p,275),sprintf('%+5.3e*X^3%+5.3e*X^2%+5.3e*X%+5.3e',p),'FontSize',10)% print the equation on the figure
xlabel('speed (m/s)'),ylabel('size (nm)')
title('Size Calibration Curve')
set(gca, 'XMinorTick', 'on')
set(gca, 'xticklabel', 250:50:500)
set(gca, 'xtick', 250:50:500)
set(gca, 'FontSize', 6)


