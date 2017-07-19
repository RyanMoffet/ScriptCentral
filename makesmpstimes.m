function [timeout1,concout]=makesmpstimes(timein,concin,start,stop,res)

%% This changes the date format of the smps data as well as giving hourly averages.

%% Make cell array of times
for i=1:length(timein{1})
    timeout{1}(i)=datenum('1/1/1904 0:0:0')+datenum([0,0,0,0,0,timein{1}(i)]);
end

for i=1:length(timein{2})
    timeout{2}(i)=datenum('1/1/1904 0:0:0')+datenum([0,0,0,0,0,timein{2}(i)]);
end

%% Make final array of times

timein=[timeout{1},timeout{2}]';

smpsconc=zeros(534,110);  %% got rid of first two bins
smpsconc(1:111,1:103)=concin{1}(1:111,3:end); %% got rid of first two bins
smpsconc(112:end,1:110)=concin{2};

for i=1:length(smpsconc(:,1))
    for j=1:length(smpsconc(1,:))
        if smpsconc(i,j)==0
            smpsconc(i,j)=NaN;
        else
            continue
        end
    end
end

binstart=datenum(start);
binstop=datenum(stop);
timeres=datenum(res);
nbin=round((binstop-binstart)/timeres);
binstop=binstart+timeres;
% concout=zeros(nbin,110);

for j=1:nbin
    idx=find(timein>=binstart & timein<binstop);
    if isempty(idx)
        concout(j,:)=NaN;
        timeout1(j)=mean([binstart,binstop]);
    elseif length(idx)==1
        concout(j,:)=NaN;
        timeout(j)=timein(idx);
    else
        concout(j,:)=mean(smpsconc(idx(1):idx(end),:));
        timeout1(j)=binstart+timeres/2;
     end
        binstart=binstop;
        binstop=binstop+timeres;
end

concout=concout';    