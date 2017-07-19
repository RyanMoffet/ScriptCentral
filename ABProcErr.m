function [Out]=ABProcErr(MeasA,MeasB)

%% MeasA/B = [Dp,Ratofms,Err]
%% Out = [Dp,AvRatofms,Diff]

Dp=MeasA(:,1);
diff=abs(MeasA(:,2)-MeasB(:,2));
av=(MeasA(:,2)+MeasB(:,2))/2;

j=1;
for i=1:length(av)
    if av(i)==0 | diff(i)==0
        continue
    else
        av1(j)=av(i);
        dp1(j)=Dp(i);
        diff1(j)=diff(i);
        j=j+1;
    end
end

% figure,errorbar(dp1,av1,diff1)

Out=[dp1',av1',diff1'];
