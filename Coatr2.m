function [SqErr]=Coatr2(m,rho,ExpDat,VolFrac)

%% m=[nc,kc,ns,ks]
%% rho = dnesity 
%% ExpDat is the experimental data with column 1 being 
%% diameter and column 2 being the partial scattering cross sections

for i=1:length(ExpDat(:,1))
    Dp=scdp(ExpDat(i,1),rho);
    Dc=Dp*VolFrac^(1/3);
    Fun(i)=(ExpDat(i,2)-MCCoat(1,m(1),m(2),m(3),m(4),0.532,Dc,Dp,1))^2;
end

SqErr=sum(Fun);
