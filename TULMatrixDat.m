function [OutDat]=TULMatrixDat(InSiz,InInt,DaBounds,BinWidth,NumInBin)
%% function [OutDatfin,RawFin]=TraceUpperLimit(InSiz,Slope,Intercept,msmt,DaBounds,BinWidth,NumInBin)

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
ColIndex=DaBounds(1);
StartSize=DaBounds(1);StopSize=DaBounds(2);
% FilterId=run_query(InId,sprintf('Da > %g and Da < %g'...
%     ,DaBounds(1),DaBounds(2)));
% [Size,Intens]=get_column(FilterId,'Da',sprintf('%s',msmt));
SizeIntens1=[InSiz,InInt];
counter=1;
for counter1=1:round((StopSize-StartSize)/BinWidth); % counter will step through bins of size BinWidth (um)
    counter1;
    [i,j]=find(SizeIntens1(:,1) > ColIndex & SizeIntens1(:,1)...
        < ColIndex+BinWidth); % this finds all particles in SizeIntens1 that fall into the current bin and returns the indices to [i,j]
    if isempty(i) | length(i) < NumInBin % ignore bins with less than NumInBin particles
        ColIndex=ColIndex+BinWidth; % go to next bin
        clear i j % clear i and j for next bin
    else
        AvSiz_IntS(1)=SizeIntens1(i(1),1); % inititate sum of Dp
        for k=2:length(i)
            AvSiz_IntS(1)=AvSiz_IntS(1)+SizeIntens1(i(k),1); % do rest of sum of Dp
        end
        AvSiz_Int(counter,1)=AvSiz_IntS(1)/length(i); % totals by length to get average of Dp and save for later...
        for ind1=1:length(i) % loop through [i j] to grab intensities of current bin
            Intens1(ind1)=SizeIntens1(i(ind1),2); % grabbing intensitites out of SizeIntens1 and assigning them to Intens1
        end
        Intens1=sort(Intens1); 
        if length(Intens1) > 100
            Intens1 = Intens1(end-99:end);
        end
        %         figure,hist(Intens1,20);
%         for ind2=1:length(Intens1)-1 % now step through newly sorted vector of intensities
%             diff(ind2)=Intens1(ind2+1)-Intens1(ind2); % Make a vector of differences called diff (duh!)
%         end
        diff = diff(Intens1);
        %        diff=sort(diff);
        %                  figure,plot(1:length(diff),diff,'b+-'),hold on;
        [intb,B,AllBs]=monreg(diff); % do the monotonic regression of the differences in intensity intb will be a vector of length(diff) that is the points of the monotonic regression
        if(length(intb)>49)
%             expectedoutliers = ceil(sqrt(length(intb))/2); % input via Thomas
            expectedoutliers = ceil(sqrt(length(intb))/2); % input via Thomas 5
        else
            expectedoutliers = ceil(length(intb)/14); % input via Thomas
        end
%         thresh = 2*intb(length(intb)-floor(length(intb)/expectedoutliers));
         thresh = 2*intb(length(intb)-floor(length(intb)/expectedoutliers));
        %                  plot(1:length(intb),intb,'ro-');
        %        [findex]=max(find(intb<=RegThresh)); % find the element of intb that is just below the regression threshold
        [findex]=max(find(intb<=thresh)); % find the element of intb that is just below the regression threshold
        err=sqrt(length(i))/(length(i)-1); % err by poisson
        if isempty(findex)% need to put because got errors for findex being empty
            OutDat(counter,2)=Intens1(1);  % if findex is empty, make the second column of OutDat the first intensity,
%         elseif counter==1
%             ColIndex=ColIndex+BinWidth;
%             continue
%         elseif Intens1(findex+1) < (.80*OutDat(counter-1,2))
%             ColIndex=ColIndex+BinWidth;
%             continue           
        else
            OutDat(counter,1)=AvSiz_Int(counter); % First column in output data matrix OutDat is the average size?????????!!            
            OutDat(counter,2)=Intens1(findex+1); % otherwise, make the second column of OutDat the intenisty correspond to the monreg thresh 
        end
        ColIndex=ColIndex+BinWidth; % set the lower Dp limit for the next bin (in um)
        counter=counter+1; % Step counter
        clear i j k intb err findex diff Intens1  % clear variables for next round
    end
end
% % ** Transform OutDat into CS by applying linear calibration **
% for i=1:length(OutDat(:,2))
%     CS(i)=Slope*OutDat(i,2)+Intercept;
% end
% % ** This removes the nasty negatives **
% counter2=1;
% for i=1:length(AvSiz_Int(:,1))
%     if CS(i)<0
%         continue
%     else
%         OutDatfin(counter2,1)=OutDat(i,1);
%         OutDatfin(counter2,2)=CS(i)';
% %         OutDatfin(counter2,3)=OutDat(i,3);
%         counter2=counter2+1;
%     end
% end
% % OutDatfin(:,2)=Smooth(OutDatfin(:,2))
% %%%%%% Transform Raw Data by applying the linear calibration %%%%%%%%%
% for i=1:length(SizeIntens1(:,2))
%     CSRaw(i)=Slope*SizeIntens1(i,2)+Intercept;
% end
% % ** This removes the nasty negatives **
% counter3=1;
% for i=1:length(SizeIntens1(:,1))
%     if CSRaw(i)<0
%         continue
%     else
%         RawFin(counter3,1)=SizeIntens1(i,1);
%         RawFin(counter3,2)=CSRaw(i)';
%         counter3=counter3+1;
%     end
% end
% 

% figure,plot(InSiz,InInt,'b.','MarkerSize',5),hold on,
% plot(OutDat(:,1),OutDat(:,2),'r+-','LineWidth',5,'MarkerSize',6)
% % ylim([min(OutDat(:,2)) max(OutDat(:,2))])
% xlim(DaBounds)

