function [sout,HR_Siz,NmissC,NmissR]=Satofms(hitid,missid,start,stop,times,bins,conc)

%% Satofms outputs the scaling function such that when multiplied by and
%% atofms number concentration, it outputs a number concentration scaled to
%% the aps and smps.
%% hitid and missid are the pids for all hits and misses
%% start and stop are strings containing times defining when the scaling
%% function is to be calculated
%% times and bins are vectors containing time (numbers) and size bins of
%% the smps or aps data. They should be binned according to the time
%% resolution of the scaling function with identical start and stop times.
%% conc is a matrix of concentrations with rows of size and columns of time

%% sout is the scaling function that, when multiplied by hit particle concentrations,
%% returns particle concentrations
%% HR_Siz is the average hit rate as a function size for the entire time period
%% NmissC is the "missed type" concentration
%% NmissR is the concentration of the rest of the misses...we will assume they have the same 
%%        fractional distribution as the hits.

%% Ryan Moffet 1/06

%% Variable definitions

totalid=union(hitid,missid);
[idtimes,idsize]=get_column(totalid,'Time','Da');  %% Get times and sizes of all particles
[hittimes,hitsize]=get_column(hitid,'Time','Da');

res1=datenum('1:00:00');     %% resolution of the scaling function
res2=datenum('00:01:00');    %% resolution of downtime check
binstart1=start;
binstop1=start+res1;
binstart2=start;
binstop2=start+res1;
nbin1=round((stop-start)/res1);
nbin2=round((binstop2-start)/res2);

tcnt=0;
hrcnt=1;
mincnt=1;

ATFR=5.6376e4;

sout=zeros(size(conc'));
sout(:,:)=NaN;
NmissC=sout;
NmissR=sout;

if start==times(1)-datenum('00:30:00')
    matidx=1;
else
    matidx=round((start-(times(1)-datenum('00:30:00')))/res1+1)
end


for i=1:length(bins)-1                           %% This calcs bin boundries
    bb(i)=bins(i)-(bins(i+1)-bins(i))/2;
    if bins(i+1)==bins(end)
       bb(i+1)=bins(i+1)-(bins(i+1)-bins(i))/2;
       bb(i+2)=bins(i+1)+(bins(i+1)-bins(i))/2;
   end
end

threshsiz=0.1; %% This sets the minimum size for Satofms calculation
threshidx=find(bb>threshsiz);


%% This loop finds average hitrate as a fn of size
for i=1:(length(threshidx)-1)  
    SizTotIdx{i}=find(idsize>bb(threshidx(i)) & idsize<bb(threshidx(i+1)));
    SizHitIdx{i}=find(hitsize>bb(threshidx(i)) & hitsize<bb(threshidx(i+1)));
    if length(SizTotIdx{i})<20 
        TotHR(i)=0;
    else
        TotHR(i)=length(SizHitIdx{i})/length(SizTotIdx{i});
    end
    HR_Siz(i,:)=[(bb(threshidx(i))+bb(threshidx(i)))/2,TotHR(i)];
end


%% This routine calculates the scaling function as well as "missed type" concentrations and
%% the concentration of the rest of the misses
for i=1:nbin1  %% TIME loop for scaling function
    tidx=find(idtimes>binstart1 & idtimes<binstop1);
    hidx=find(hittimes>binstart1 & hittimes<binstop1);
    for j=1:nbin2  %% inner loop for downtime check
        idx2=find(idtimes>binstart2 & idtimes<binstop2);
        if length(idx2)==0
            tcnt=tcnt;
        elseif length(idx2)>0
            tcnt=tcnt+1;
        end
        binstart2=binstop2;
        binstop2=binstop2+res2;
    end
    FT(i)=tcnt/nbin2;  %% This is fraction of time measured within a time bin
    tcnt=0;
    for k=1:(length(threshidx)-1)   %% loop for SIZE and calc of Satofms
        TotTimSizId=intersect(SizTotIdx{k},tidx);
        HitTimSizId=intersect(SizHitIdx{k},hidx);
        NumTot=length(TotTimSizId);
        NumHit=length(HitTimSizId);
        if NumTot==0 | NumHit==0 | FT(i)==0
            sout(matidx,threshidx(k))=NaN;
            Nmiss=NaN;
            HrTime=NaN;
        else
            sout(matidx,threshidx(k))=(ATFR*conc(threshidx(k),matidx))/(NumTot*FT(i));   %% Calculation of Satofms
            HrTime=length(HitTimSizId)/length(TotTimSizId);
            Nmiss=(((1-HrTime)*NumTot*FT(i))/ATFR)*sout(matidx,threshidx(k));
        end
        if HrTime<TotHR(k)                                                               %% Calcuate missed and rest of missed concs
            NmissC(matidx,threshidx(k))=((NumTot*FT(i))/ATFR)*sout(matidx,threshidx(k))*...
                (TotHR(k)-HrTime);                                                       %% This is num conc for missed class
            NmissR(matidx,threshidx(k))=(((1-TotHR(k))*NumTot*FT(i))/ATFR)*...
                sout(matidx,threshidx(k));                                               %% This is num conc for rest of misses
        else 
            NmissC(matidx,threshidx(k))=NaN;
            NmissR(matidx,threshidx(k))=Nmiss;
        end
        clear fidx
    end
    clear tidx
    binstart1=binstop1;
    binstop1=binstop1+res1;
    matidx=matidx+1;
end