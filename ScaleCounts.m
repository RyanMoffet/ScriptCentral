function [TotScCts]=ScaleCounts(inid,totmiss,start1,stop1,res1,satofms,bins)

%% TotScCts is a cell array containing a matrix of concentrations with
%% rows corresponding to time and columns corresponding to size.
%% inid is a cell array of input particle ids with the missed class going
%% second to last and the "normal" misses going last
%% start, stop and res are the datenums of corresponding start and start
%% times in addition to the temporal resolution
%% satofms is the atofms scaling function (must be the same tempoal
%% and size resolution as counts)
%% bins are the size bin centers used to generate satofms

%% first, calculate bin edges:

for i=1:length(bins)-1
    bb(i)=bins(i)-(bins(i+1)-bins(i))/2;
    if bins(i+1)==bins(end)
       bb(i+1)=bins(i+1)-(bins(i+1)-bins(i))/2;
       bb(i+2)=bins(i+1)+(bins(i+1)-bins(i))/2;
   end
end

%% now define variables 

ATFR=5.637e4; %% flowrate in cc/hr
binstart=start1;
binstop=start1+res1;
nbin1=(stop1-start1)/res1;

%% define what size to begin scaling (saves time)

threshsiz=0.1;
threshidx=find(bb>threshsiz);

%% scale raw counts

for i=1:length(inid)
    [idtimes{i},idsize{i}]=get_column(inid{i},'Time','Da');
    scaledcounts{i}=zeros(size(satofms));
    scaledcounts{i}(:,:)=NaN;
    for j=1:round(nbin1)
        tidx=find(idtimes{i}>binstart & idtimes{i}<binstop);
        for k=threshidx(1:end-1)
            sidx=find(idsize{i}>bb(k) & idsize{i}<bb(k+1));
            cts=intersect(tidx,sidx);
            if isnan(satofms(j,k)) | isinf(satofms(j,k)) | length(cts)<3
                continue
            else
                scaledcounts{i}(j,k)=(length(cts)/ATFR)*satofms(j,k);
            end
        end
        binstart=binstop;
        binstop=binstop+res1;
    end
    binstart=start1;
    binstop=start1+res1;
end

%% Add up all of the hits
tothit=scaledcounts{1}
for i=1:length(inid)
    for j=1:length(scaledcounts{i}(:,1))
        for k=1:length(scaledcounts{i}(1,:))
            tothit(j,k)=nansum([tothit(j,k),scaledcounts{i}(j,k)]);
        end
    end
end

%% Calculate final conc of particle classes
for i=1:length(inid)
    for j=1:length(tothit(:,1))
        for k=1:length(tothit(1,:))
            if tothit(j,k)==0
                TotScCts{i}(j,k)=NaN;
            else
                TotScCts{i}(j,k)=scaledcounts{i}(j,k)*...
                    (1+totmiss(j,k)/tothit(j,k));
            end
        end
    end
end
TotScCts{end+1}=tothit; % Makes the last cell in output the total hits