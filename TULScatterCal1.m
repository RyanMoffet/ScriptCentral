% Lightscattering calibration
% First Run Time Query
function [Slpe,Int]=TULScatterCal(InId,PslSizes,SpeedMode)
% Scatter Cal performs an absolute calibration of pulse area/height to
% theoretical partial scattering cross section in cm^2
% PslSizes = is a vector of PSL sizes (um) that were used
% SpeedMode = a 1xn vector of modal speeds determined from plotting the
% speed distribution for each of the size PSLs described the in PslSizes vector
% Slpe = vector of slopes i.e.: [slope(saheight),slope(saarea)...]
% Int = vector of intercepts of the
SpeedTol=1; % +/- tolerence interval to select psl size = +/- 
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
        intens=sort(intens); 
        for ind2=1:length(intens)-1 % now step through newly sorted vector of intensities
            diff(ind2)=intens(ind2+1)-intens(ind2); % Make a vector of differences called diff (duh!)
        end
        %        diff=sort(diff);
        %                  figure,plot(1:length(diff),diff,'b+-'),hold on;
        [intb,B,AllBs]=monreg(diff); % do the monotonic regression of the differences in intensity intb will be a vector of length(diff) that is the points of the monotonic regression
        expectedoutliers = sqrt(length(intb)); % input via Thomas
        thresh = 2*intb(length(intb)-floor(length(intb)/expectedoutliers));
        %                  plot(1:length(intb),intb,'ro-');
        %        [findex]=max(find(intb<=RegThresh)); % find the element of intb that is just below the regression threshold
        [findex]=max(find(intb<=thresh)); % find the element of intb that is just below the regression threshold
        err=sqrt(length(i))/length(i); % err by poisson
        if isempty(findex)% need to put because got errors for findex being empty
            Ul(counter1,i)=intens(1);  % if findex is empty, make the second column of OutDat the first intensity,
        else
            Ul(counter1,i)=intens(findex+1); % otherwise, make the second column of OutDat the intenisty correspond to the monreg thresh 
        end
        intens1{i}=intens;
        size1{i}=Size;
        clear j k intb err findex diff intens
        
        [counts,centers] = hist(intens1{i},NumBin);% vector of intensity histogram counts
        ModDat=[centers;counts]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency
        subplot(4,3,i),hist(intens1{i},NumBin) % these next few lines make the intensity histogram plots
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
            plot(PslSizes,Ul(counter1,:),'o')
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
    % CrossSection = mc(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
    % need to give values for psl scattering properties
    nimp=1.59;kimp=0;lambdaimp=0.532;
    for counter2=1:length(PslSizes)
        TheorIntens(counter2)=mc(1,nimp,kimp,lambdaimp,PslSizes(counter2),1);
    end

    mymodel = fittype('a*x');
    CalCurve=fit(Ul(counter1,:)',TheorIntens',mymodel)
%     [pscat,sscat]=polyfit(Ul(counter1,:),TheorIntens,nscat); % fits data to polynomial
    xiscat=linspace(min(Ul(counter1,:)),max(Ul(counter1,:)),100); % creates data input for the calibration function evaluation
    zzscat=CalCurve(xiscat); % evaluate the calibration function
    Output = CalCurve(Ul(counter1,:));
    Corrolation = corrcoef(TheorIntens', Output');
    rsq=Corrolation(1,2)^2;
    figure,plot(Ul(counter1,:),TheorIntens,'o',xiscat,zzscat)
    text((max(xiscat)-min(xiscat))/2,CalCurve((max(xiscat)-min(xiscat))/2)...
        ,sprintf('%+5.3e*X%',CalCurve(1)),'FontSize',10)% print the equation on the figure
    text((max(xiscat)-min(xiscat))/3,CalCurve((max(xiscat)-min(xiscat))/3)...
        ,sprintf('R^{2}=%5.3e',rsq),'FontSize',10)% print the r square value on the figure
    xlabel(sprintf('%s (arb units)',intensarray{counter1})),ylabel('Cross Section (cm^{2})')
    title('Scattering Intensity Calibration Curve')
    set(gca, 'FontSize', 6)  
    Slpe(counter1)=CalCurve(1);
    Int(counter1)=0;
    
    
    %%%%%% Transform Raw Data by applying the linear calibration %%%%%%%%%
    SizeDat=[];IDat=[];
    for k=1:length(intens1) % should be length(pslsizes)
        for j=1:length(intens1{k})
            CSRaw{k}(j)=Slpe(counter1)*intens1{k}(j)+Int(counter1);
        end
        % ** This removes the nasty negatives **
        counter3=1;
        for i=1:length(CSRaw{k})
            if CSRaw{k}(i)<0
                RawFin(counter3,1)=0;
                RawFin(counter3,2)=0;
                counter3=counter3+1;
            else
                RawFin(counter3,1)=CSRaw{k}(i);
                RawFin(counter3,2)=size1{k}(i);
                counter3=counter3+1;
            end
        end
        SizeDat=[SizeDat,RawFin(:,2)'];
        IDat=[IDat,RawFin(:,1)'];
        clear CSRaw RawFin
    end
    % now transform the upper lim data to cross sections
    NewUl=Slpe(counter1)*Ul(counter1,:)+Int(counter1);
    figure,plot(PslSizes,NewUl(:),'r-'),hold on,
    plot(SizeDat,IDat,'b.')
    clear RawFin size1 intens1 NewUl
end

