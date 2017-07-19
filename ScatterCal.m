% Lightscattering calibration
% First Run Time Query
function [Slpe,Int]=ScatterCal(InId,PslSizes,SpeedMode)
% Scatter Cal performs an absolute calibration of pulse area/height to
% theoretical partial scattering cross section in cm^2
% PslSizes = is a vector of PSL sizes (um) that were used
% SpeedMode = a 1xn vector of modal speeds determined from plotting the
% speed distribution for each of the size PSLs described the in PslSizes vector
% Slpe = vector of slopes i.e.: [slope(saheight),slope(saarea)...]
% Int = vector of intercepts of the
warning off
SpeedTol=2; % +/- tolerence interval to select psl size = +/- 
intensarray={'saheight' 'saarea' 'sbheight' 'sbarea'};
NumBin=25;
for j = 1:length(SpeedMode)
SelectPsl{j}=run_query(InId{j},sprintf('Velocity > %d and Velocity < %d'...
    ,SpeedMode(j)-SpeedTol,SpeedMode(j)+SpeedTol));
end
for counter1=1:length(intensarray)
    figure
    for i = 1:length(PslSizes)
        [intens,Size] = get_column(SelectPsl{i},eval(sprintf('intensarray{%d}'...
            ,counter1)),'Da'); % make columns of speed and size for different psl samples defined above
        avg=mean(intens);
        Av(counter1,i)=[avg]; % sets up a matrix of averages...[msmt (saarea etc),psl size]
        stdev=std(intens); % calc mean and stdev of the intensity
        [counts,centers] = hist(intens,NumBin);% vector of intensity histogram counts
        ModDat=[centers;counts]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency
        subplot(4,3,i),hist(intens,NumBin) % these next few lines make the intensity histogram plots
        xlabel(sprintf('%s (arb units)',intensarray{counter1}),'FontSize',10)
        ylabel('frequency','FontSize',10)
        title(sprintf('%d nm PSL',PslSizes(i)),'FontSize',10)
        set(gca, 'XMinorTick', 'on')
        set(gca, 'xticklabel', floor(min(centers)):ceil((max(centers)...
            -min(centers))/10):ceil(max(centers)))
        set(gca, 'xtick', floor(min(centers)):ceil((max(centers)...
            -min(centers))/10):ceil(max(centers)))
        set(gca, 'FontSize', 6)
        if i == length(PslSizes)
            subplot(4,3,length(PslSizes)+1)
            plot(PslSizes,Av(counter1,:),'o')
            ylabel(sprintf('%s (arb units)',intensarray{counter1}))...
                ,xlabel('size (\mum)')
            title('Scattered Intensity vs Da')
            set(gca, 'XMinorTick', 'on')
            set(gca, 'xticklabel', max(PslSizes):50:min(PslSizes))
            set(gca, 'xtick', max(PslSizes):50:min(PslSizes))
            set(gca, 'FontSize', 6)
        end
        clear edges
    end
    %%FIT HERE
    % CrossSection = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
    % need to give values for psl scattering properties
    nimp=1.59;kimp=0;lambdaimp=0.532;
    for counter2=1:length(PslSizes)
        TheorIntens(counter2)=mc(1,nimp,kimp,lambdaimp,PslSizes(counter2),1);
    end
     ft_ = fittype('poly1');
    [CalCurve,gof]=fit(Av(counter1,:)',TheorIntens',ft_)
%     [pscat,sscat]=polyfit(Av(counter1,:),TheorIntens,nscat); % fits data to polynomial
    xiscat=linspace(min(Av(counter1,:)),max(Av(counter1,:)),100); % creates data input for the calibration function evaluation
    zzscat=CalCurve(xiscat); % evaluate the calibration function
    Output = CalCurve(Av(counter1,:));
    Corrolation = corrcoef(TheorIntens', Output');
    rsq=Corrolation(1,2)^2;
    figure,plot(Av(counter1,:),TheorIntens,'o',xiscat,zzscat)
    Slpe(counter1)=CalCurve(1)-CalCurve(0);
    Int(counter1)=CalCurve(0);
    text((max(xiscat)-min(xiscat))/2,CalCurve((max(xiscat)-min(xiscat))/2)...
        ,sprintf('%+5.3e*X%+5.3e',Slpe(counter1),Int(counter1)),'FontSize',10)% print the equation on the figure
%     text((max(xiscat)-min(xiscat))/2,CalCurve((max(xiscat)-min(xiscat))/2)...
%         ,sprintf('%+5.3e*X',CalCurve(1),CalCurve(2)),'FontSize',10)% print the equation on the figure
    text((max(xiscat)-min(xiscat))/3,CalCurve((max(xiscat)-min(xiscat))/3)...
        ,sprintf('R^{2}=%5.3e',rsq),'FontSize',10)% print the r square value on the figure
    xlabel(sprintf('%s (arb units)',intensarray{counter1})),ylabel('Cross Section (cm^{2})')
    title('Scattering Intensity Calibration Curve')
    set(gca, 'FontSize', 6)  
    clear gof
end

warning on