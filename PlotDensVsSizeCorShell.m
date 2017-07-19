function PlotDensVsSizeCorShell(SizRange,NumBin,Dcore,rhoCore,rhoShell)

VolCore = 4/3*pi*(Dcore/2)^3*(100/1e6)^3; %% volume in cm^3

Sizes = [SizRange(1):(SizRange(2)-SizRange(1))/NumBin:SizRange(2)]

% for i = 1:NumBin
    VolPart = 4/3*pi*(Sizes/2).^3*(100/1e6)^3; %% volume in cm^3
    VolShell = VolPart-VolCore;
    rhoComp = (rhoShell*VolShell+rhoCore*VolCore)./VolPart;
% end

plot(Sizes,rhoComp);