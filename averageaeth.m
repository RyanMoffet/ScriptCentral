function [bav]=averageaeth(bapin,start,stop,resolution)

%% bapin(:,1) returns a vector datenums for bap
%% bapin(:,2) returns a vector bap for bap
%% start and stop are strings of starting and stopping time
%% resolution is a string containing the time resolution

start = datenum(start);
stop = datenum(stop);
resolution=datenum(resolution);
nbin=round((stop-start)/resolution);

binstart=start;
binstop=start+resolution;
for j=1:nbin
    idx=find(bapin(:,1)>binstart & binstop>bapin(:,1));
    if isempty(idx)
        bav(j,2)=0;
        bav(j,1)=mean([binstart,binstop]);
    elseif mean(bapin(idx(1):idx(end),2))<0
        bav(j,2)=0;
        bav(j,1)=binstart+resolution/2;
        clear idx
    else
        bav(j,2)=mean(bapin(idx(1):idx(end),2));
        bav(j,1)=binstart+resolution/2;
        clear idx
     end
        binstart=binstop;
        binstop=binstop+resolution;
end


    