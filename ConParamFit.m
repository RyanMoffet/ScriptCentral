function [nkDens,TDat,r2]=ConParamFit(InDat,StartSize,StopSize,NKRho,LoBd,UpBd,Flag);

% UnkLSFit averages experimental light scattering data and fits the data to
% mie theory
% SizeIntens = [experimental cross sections (cm^2);Da]
% StartSiz = Da to begin theoretical plotting (um)
% StopSiz = Da to begin theoretical plotting (um)
% NRho = [Index of refraction, Density] which are either initial 
%        guesses or fixed values determined elsewhere. 
% Flag = 0 for fit to real part of refractive index, 1 for fit to density
%      = 2 for fit to real part of refractive index and density
%      = 3 for fit to real and imaginary part of RI and density
%      = 4 for fit to real and imaginary part of RI (fixed density)
% TDat = Best fit theoretical model output = [size,intens]
% Ryan Moffet Nov '04

warning off

% ** fit to mie theory using SqErFit ** 

% [nkDens] = MieConLS(InDat,NKRho,LoBd,UpBd,.532,Flag);
[nkDens] = ryanOptimize(InDat,NKRho,LoBd,UpBd,.532,Flag);
%[nkDens] = exploreError(InDat,NKRho,LoBd,UpBd,.532,Flag);

% ** Now Generate Theoretical Data Based on Above Fit **

[Size1,Resp]=ATOFMSScattFunGen(StartSize,StopSize,200,.532,nkDens(1),nkDens(3));
TDat=[Size1',Resp'];

% Compute rsquare

for i=1:length(InDat(:,1))
    [Size_Corr(i),Resp_Corr(i)]=ATOFMSScattFunGenA(scdp(InDat(i,1),nkDens(2)),.532,nkDens(1),nkDens(3));
end

for i=1:length(InDat(:,1))
    InDatSC(i)=scdp(InDat(i,1),nkDens(2));
end

r2=corrcoef([InDatSC',Resp_Corr']);
disp(sprintf('r^{2} = %g',r2(1,2)))

warning on
return