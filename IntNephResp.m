function [value]=IntNephResp(start,stop,int)

wave=linspace(start,stop,int);

for i=1:length(wave)
    resp(i)=radres(wave(i));
end

resp=resp/(sum(resp)*mean(diff(wave)));

value=trapz(wave,resp);

plot(wave,resp)