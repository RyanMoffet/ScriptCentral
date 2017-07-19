function [OutDatfin,RawFin]=ConsPSD(InId,Slope,Intercept,msmt,DaBounds,NumPart)
% TraceUpperLimit Processes the exprimental scatttering response data and
% turns the instrumental response into a partial scattering cross section.
% TraceUpperLimit traces the upper limit of the I vs. Da scatterplot
% InId = pids of experimetal data
% Slope = vector of light scattering calibration slopes i.e.:
%         [slope(saheight),slope(saarea)...]
% Intercept = vector of light scattering calibration intercepts i.e.:
%             [intercept(saheight),intercept(saarea)...]
% DaBounds=[upper,lower]
% msmt = lightscattering measurement used (saheight, saarea etc...) AS A
% STRING!!!
% NumInBin=Minimum number of particles in bin to consider
% OutDatfin = matrix whose columns are as follows: [Da,UpperLimitOfCrossSection,Error]
% RawFin = [Da of raw data, Intensity of raw data]

StartSize=DaBounds(1);StopSize=DaBounds(2);
FilterId=run_query(InId,sprintf('Da > %g and Da < %g'...
    ,DaBounds(1),DaBounds(2)));
[Size,Intens]=get_column(FilterId,'Da',sprintf('%s',msmt));
[Size,idx]=sort(Size); % sort by size and give index placement
for i=1:length(Size)
    Intens(i)=Intens(idx(i)); % move intensities around to match size
end


% % SizeIntens1=[Size,Intens]; % create final matrix

counter1=1;
for counter=1:floor(length(Size)/NumPart); % counter will step through NumPart particles at a time
    OutDat(counter1,1)=mean(Size((NumPart*counter-(NumPart-1)):(counter*NumPart))); % average sizes for current sample
    OutDat(counter1,2)=mean(Intens((NumPart*counter-(NumPart-1)):(counter*NumPart)));
    counter1=counter1+1; % Step counter
    clear i j k intb err findex diff Intens1 % clear variables for next round
end

% % ** Transform OutDat into CS by applying linear calibration **

for i=1:length(OutDat(:,2))
    CS(i)=Slope*OutDat(i,2)+Intercept;
end

% ** This removes the nasty negatives **

counter2=1;
for i=1:length(OutDat(:,1))
    if CS(i)<0
        continue
    else
        OutDatfin(counter2,1)=OutDat(i,1);
        OutDatfin(counter2,2)=CS(i)';
%         OutDatfin(counter2,3)=OutDat(i,3);
        counter2=counter2+1;
    end
end

%%%%%% Transform Raw Data by applying the linear calibration %%%%%%%%%

for i=1:length(Intens)
    CSRaw(i)=Slope*Intens(i)+Intercept;
end

% ** This removes the nasty negatives **

counter3=1;
for i=1:length(Intens)
    if CSRaw(i)<0
        continue
    else
        RawFin(counter3,1)=Size(i);
        RawFin(counter3,2)=CSRaw(i)';
        counter3=counter3+1;
    end
end

figure,plot(OutDatfin(:,1),OutDatfin(:,2),'r.-',...
    'LineWidth',1,...
    'MarkerSize',5);
hold on,
plot(RawFin(:,1),RawFin(:,2),'b.','MarkerSize',2)
ylim([min(RawFin(:,2)) max(RawFin(:,2))])

    
