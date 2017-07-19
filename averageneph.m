function [Ti,bav]=averageneph(timein,bsp,start,stop,resolution)

%% timein is a column vector of datenums
%% sizein is a row vector of size bins
%% concin is a matrix of concentrations with rows and columns corresponding
%% to dates and size.

start = datenum(start);
stop = datenum(stop);
resolution=datenum(resolution);
nbin=round((stop-start)/resolution);

binstart=start;
binstop=start+resolution;
for j=1:nbin
    idx=find(timein>binstart & timein<binstop);
    if isempty(idx)
        bav(j,:)=zeros(1,51);
        Ti(j)=mean([binstart,binstop]);
    else
        bav(j,:)=mean(bsp(idx(1):idx(end),:));
        Ti(j)=binstart+resolution/2;
     end
        binstart=binstop;
        binstop=binstop+resolution;
end


    