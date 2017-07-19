%% Plot scattering temporals for CalCOFI

function [AvDat]=ScattTemp(InId,sample,slope,intercept,timerang,timstp)

Start = datenum(timerang{1});
Stop = datenum(timerang{2});
TimeLength = Stop - Start;
TimeDiv = 24*60/10; %Enter time bin (e.g. /10 for 10 min bins or /30 for 30 min bins)
TimeStep=DATENUM(0,0,0,timstp,0,0);
m = TimeLength/TimeStep; % this is the number of bins


msmt={'saarea' 'sbarea'};

for j=1:length(InId)
    for i=1:length(msmt)
        timeinc=Start;
        for k=1:round(m)
            startq=datestr(timeinc,0);
            timeinc=timeinc+TimeStep;
            PartTime=run_query(InId{j},sprintf('Time = [%s %s]',...
                startq,datestr(timeinc)));
            [scattint]=get_column(PartTime,msmt{i});
            bintime=timeinc-TimeStep/2;
            if isempty(scattint)
                meanint=0;
            else
                meanint=mean(scattint)*slope(i)+intercept(i);
            end
            AvDat{i,j}(k,:)=[bintime,meanint];
        end
    end
    title(sprintf('Scattering Temporal for %s /n %s',...
        sample{j},msmt{i}))
    figure,plot(AvDat{1,j}(:,1),AvDat{1,j}(:,2),'k-',...
        AvDat{2,j}(:,1),AvDat{2,j}(:,2),'r-')
    legend({'PMTA' 'PMTB'});
    xlabel('Date and Time'),
    ylabel('Partial Scattering Cross Section /n cm^{2}/particle');
    set(gcf,'PaperOrientation','landscape')
    set(gcf,'PaperPosition',[0.5 0.5 10 7.5])   
    FileName = sprintf('ScaTmp%s',sample{j}); % Names the file (differently) for each cluster
    saveas (gcf,FileName, 'fig');
end


            
        
        