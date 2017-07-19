function [OutDat1]=ProcMsbMatrix(InSiz,InR,Slope,Intercept,DaBounds,BinWidth)
%%       [OutDat1,RawFin1]=ProcMsbMatrix(InId,Slope,Intercept,msmt,DaBounds,BinWidth)
% This script will break up the scattering curve in the case
% of a severe notch in the raw and processed data. This notch is usually
% due to the nozzle (and nonsphericity??).
%
% DaBounds = [DaBounds(1,:);DaBounds(2,:),...]

for i = 1:length(DaBounds(:,1))
    gidx{i} = find(InSiz > DaBounds(i,1) & InSiz < DaBounds(i,2));
end

if length(gidx) == 1
    totidx = gidx{1};
elseif length(gidx) == 2
    totidx = union(gidx{1},gidx{2});
elseif length(gidx) > 2
    totidx = union(gidx{1},gidx{2});
    for i = 2:length(gidx)
        totidx = union(totidx,gidx{i});
    end
end

Size = InSiz(totidx);
Intens = InR(totidx);

SizeIntens1=[Size,Intens];
counter1=1;
StartSize = min(Size);
StopSize = max(Size);
ColIndex = StartSize;
for counter=1:floor((StopSize-StartSize)/BinWidth); 
    [i,j]=find(SizeIntens1(:,1) > ColIndex & SizeIntens1(:,1)...
        < ColIndex+BinWidth);
    if isempty(i) | length(i) < 10 % ignore bins with less than 10 particles
        ColIndex=ColIndex+BinWidth;
        clear i j
    else
        AvSiz_IntS(1)=SizeIntens1(i(1),1);
        AvSiz_IntS(2)=SizeIntens1(i(1),2);
        for k=2:length(i)
            AvSiz_IntS(1)=AvSiz_IntS(1)+SizeIntens1(i(k),1); % get totals
            AvSiz_IntS(2)=AvSiz_IntS(2)+SizeIntens1(i(k),2);
        end
        AvSiz_Int(counter1,1)=AvSiz_IntS(1)/length(i); % totals by length to get average
        AvSiz_Int(counter1,2)=AvSiz_IntS(2)/length(i);
        AvSiz_Int(counter1,3)=(sqrt(length(i))/(length(i)-1));
        ColIndex=ColIndex+BinWidth;
        counter1=counter1+1;
        clear i j k
    end
end

OutDat1 = AvSiz_Int;

% 
% 
% 
% 
% for i=1:length(DaBounds(:,1))
%     [proc,raw]=ProcScattDatC(InId,Slope,Intercept,msmt,DaBounds(i,:),BinWidth);
%     if i==1
%         RawFin1=raw;
%         OutDat1=proc;
%     else
%         RawFin1=[RawFin1;raw];
%         OutDat1=[OutDat1;proc];
%         clear raw proc
%     end
% end

figure,plot(OutDat1(:,1),OutDat1(:,2),'r.-',...
    'LineWidth',1,...
    'MarkerSize',5);
hold on,
plot(InSiz,InR,'b.','MarkerSize',2)
ylim([min(InR) max(InR)])

% 
% function [OutDat,RawFin]=ProcScattDatC(InId,Slope,Intercept,msmt,DaBounds,BinWidth)
% % ProcScattDat Processes the exprimental scatttering response data and
% % turns the instrumental response into a partial scattering cross section
% % InId = pids of experimetal data
% % Slope = vector of light scattering calibration slopes i.e.:
% %         [slope(saheight),slope(saarea)...]
% % Intercept = vector of light scattering calibration intercepts i.e.:
% %             [intercept(saheight),intercept(saarea)...]
% % PartialCS = vector of partial scattering cross sections calculated from
% %             the above calibration parameters i.e.:
% %             [PartialCS(saheight),PartialCS(saarea)...]
% % msmt = lightscattering measurement used (saheight, saarea etc...)
% % OutDat = matrix whose columns are as follows: [Da,AveragedCrossSection,Error]
% % Raw data transformed into partial scattering cross section
% ColIndex=DaBounds(1);
% StartSize=DaBounds(1);StopSize=DaBounds(2);
% FilterId=run_query(InId,sprintf('Da > %g and Da < %g'...
%     ,DaBounds(1),DaBounds(2)));
% [Size,Intens]=get_column(FilterId,'Da',sprintf('%s',msmt));
% SizeIntens1=[Size,Intens];
% counter1=1;
% for counter=1:floor((StopSize-StartSize)/BinWidth); 
%     [i,j]=find(SizeIntens1(:,1) > ColIndex & SizeIntens1(:,1)...
%         < ColIndex+BinWidth);
%     if isempty(i) | length(i) < 10 % ignore bins with less than 10 particles
%         ColIndex=ColIndex+BinWidth;
%         clear i j
%     else
%         AvSiz_IntS(1)=SizeIntens1(i(1),1);
%         AvSiz_IntS(2)=SizeIntens1(i(1),2);
%         for k=2:length(i)
%             AvSiz_IntS(1)=AvSiz_IntS(1)+SizeIntens1(i(k),1); % get totals
%             AvSiz_IntS(2)=AvSiz_IntS(2)+SizeIntens1(i(k),2);
%         end
%         AvSiz_Int(counter1,1)=AvSiz_IntS(1)/length(i); % totals by length to get average
%         AvSiz_Int(counter1,2)=AvSiz_IntS(2)/length(i);
%         AvSiz_Int(counter1,3)=(sqrt(length(i))/(length(i)-1));
%         ColIndex=ColIndex+BinWidth;
%         counter1=counter1+1;
%         clear i j k
%     end
% end
% 
% % ** Transform Response to Partial Cross Section **
% for i=1:length(AvSiz_Int(:,2))
%     CS(i)=Slope*AvSiz_Int(i,2)+Intercept;
% end
% % ** This removes the nasty negatives **
% counter2=1;
% for i=1:length(AvSiz_Int(:,1))
%     if CS(i)<0
%         OutDat(counter2,1)=AvSiz_Int(i,1);
%         OutDat(counter2,2)=0;
%         OutDat(counter2,3)=0;
%         counter2=counter2+1;
%     else
%         OutDat(counter2,1)=AvSiz_Int(i,1);
%         OutDat(counter2,2)=CS(i)';
%         OutDat(counter2,3)=AvSiz_Int(i,3);
%         counter2=counter2+1;
%     end
% end
% %%%%%% Transform Raw Data by applying the linear calibration %%%%%%%%%
% for i=1:length(Intens)
%     CSRaw(i)=Slope*Intens(i)+Intercept;
% end
% % ** This removes the nasty negatives **
% counter3=1;
% for i=1:length(Intens)
%     if CSRaw(i)<0
%         continue
%     else
%         RawFin(counter3,1)=Size(i);
%         RawFin(counter3,2)=CSRaw(i)';
%         counter3=counter3+1;
%     end
% end
% 
% 
%     
