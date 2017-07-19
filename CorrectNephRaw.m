function [corrbsp]=CorrectNephRaw(neph,T,start,res)

%% neph has column1 for time and column2 for bsp
%% T=Q/partialQ where partial Q is Q between angular range of neph
%% start and res are the start time and time resolution strings

bintime=datenum(start);
res=datenum(res);

corrbsp=zeros(length(neph(:,1)),2);
corrbsp(:,1)=neph(:,1)+datenum(0,0,0,8,0,0);

for i = 1:length(T)
    if isnan(T(i))
        T(i)=T(i-1);
        idx=find(neph(:,1)>=bintime & neph(:,1)<= bintime+res);
        corrbsp(idx(1):idx(end),2)=neph(idx(1):idx(end),2)*T(i);
        bintime=bintime+res;        
    else
        idx=find(neph(:,1)>=bintime & neph(:,1)<= bintime+res);
        corrbsp(idx(1):idx(end),2)=neph(idx(1):idx(end),2)*T(i);
        bintime=bintime+res;
    end
end