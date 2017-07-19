
%%% 04 April 2004

function [Xavg,Davg] = timeaverage(tv, zv, at);  %% input julian time, data matrix, second averaging

st = tv(1);
cnt = 0;
while st < tv(end)
    et = st + at/86400;
    j = find(tv >= st & tv < et);
    cnt = cnt + 1;
    if any(j)
        Xavg(cnt) = mean(tv(j));
        Davg(cnt,:) = mean(zv(j,:));
    else 
        Xavg(cnt) = -1;
        Davg(cnt) = -1;
    end;
    st = et;
end;