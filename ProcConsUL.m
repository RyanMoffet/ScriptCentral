function [OutDatfin,RawFin]=ProcConsUL(InId,Slope,Intercept,msmt,DaBounds,RegThresh,NumPart)
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
% 
% ColIndex=DaBounds(1);

warning off

StartSize=DaBounds(1);StopSize=DaBounds(2);
FilterId=run_query(InId,sprintf('Da > %g and Da < %g'...
    ,DaBounds(1),DaBounds(2)));
[Size,Intens]=get_column(FilterId,'Da',sprintf('%s',msmt));
[Size,idx]=sort(Size); % sort by size and give index placement
for i=1:length(Size)
    Intens1(i)=Intens(idx(i)); % move intensities around to match size
end
SizeIntens1=[Size,Intens1']; % create final matrix
counter1=1;
for counter=1:floor(length(Size)/NumPart); % counter will step through NumPart particles at a time
    AvSiz_Int(counter1,1)=mean(Size((NumPart*counter-(NumPart-1)):(counter*NumPart))); % average sizes for current sample
    Intens2=sort(Intens1((NumPart*counter-(NumPart-1)):(counter*NumPart))); % Sort intensities in current sample for monreg
    %         figure,hist(Intens1,20);
    for ind2=1:length(Intens2)-1 % now step through newly sorted vector of intensities
        diff(ind2)=Intens2(ind2+1)-Intens2(ind2); % Make a vector of differences called diff (duh!)
    end
    %        diff=sort(diff);
    %                  figure,plot(1:length(diff),diff,'b+-'),hold on;
    [intb,B,AllBs]=monreg(diff); % do the monotonic regression of the differences in intensity intb will be a vector of length(diff) that is the points of the monotonic regression
    thresh = RegThresh*mean(intb);
    %                  plot(1:length(intb),intb,'ro-');
    [findex]=max(find(intb<=thresh)); % find the element of intb that is just below the regression threshold
    err=1;
    OutDat(counter1,1)=AvSiz_Int(counter1); % First column in output data matrix OutDat is the average size?????????!!
    if isempty(findex)% need to put because got errors for findex being empty
        OutDat(counter1,2)=Intens2(1);  % if findex is empty, make the second column of OutDat the first intensity,
    else
        OutDat(counter1,2)=Intens2(findex+1); % otherwise, make the second column of OutDat the intenisty correspond to the monreg thresh 
    end
    OutDat(counter1,3)=err; % third column of the output data matrix is the error
    counter1=counter1+1; % Step counter
    clear i j k intb err findex diff Intens2 % clear variables for next round
end
% end
% ** Transform OutDat into CS by applying linear calibration **
for i=1:length(OutDat(:,2))
    CS(i)=Slope*OutDat(i,2)+Intercept;
end
% ** This removes the nasty negatives **
counter2=1;
for i=1:length(AvSiz_Int(:,1))
    if CS(i)<0
        continue
    else
        OutDatfin(counter2,1)=OutDat(i,1);
        OutDatfin(counter2,2)=CS(i)';
        OutDatfin(counter2,3)=OutDat(i,3);
        counter2=counter2+1;
    end
end
% OutDatfin(:,2)=Smooth(OutDatfin(:,2),4);
%%%%%% Transform Raw Data by applying the linear calibration %%%%%%%%%
for i=1:length(SizeIntens1(:,2))
    CSRaw(i)=Slope*SizeIntens1(i,2)+Intercept;
end
% ** This removes the nasty negatives **
counter3=1;
for i=1:length(SizeIntens1(:,1))
    if CSRaw(i)<0
        continue
    else
        RawFin(counter3,1)=SizeIntens1(i,1);
        RawFin(counter3,2)=CSRaw(i)';
        counter3=counter3+1;
    end
end

figure,plot(OutDatfin(:,1),OutDatfin(:,2),'r-*'),hold on,
plot(RawFin(:,1),RawFin(:,2),'b.','MarkerSize',2)
ylim([min(RawFin(:,2)) max(OutDatfin(:,2))])
xlim([StartSize StopSize])
    
warning on