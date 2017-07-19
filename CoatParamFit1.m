function [DcOut,sqerrfinal,TDat,r2]=CoatParamFit1(InDat,MDcRho,Flag1)
% UnkLSFit averages experimental light scattering data and fits the data to
% mie theory
% SizeIntens = [experimental cross sections (cm^2);Da]
% StartSiz = Da to begin theoretical plotting (um)
% StopSiz = Da to begin theoretical plotting (um)

% mRhoEta=[nc,kc,ns,ks,Dc,rho] 

% Flag1 is a flag for the future...use 0 now.

% TDat = Best fit theoretical model output = [size,intens]
% Ryan Moffet Nov '04

% ** fit to mie theory using SqErFit ** 

warning off

% StartSize=InDat(1,1);
% StopSize=InDat(end,1);
% idx=find(InDat(:,1)>StartSize & InDat(:,1)<StopSize);
% FitDat=[InDat(idx(1):idx(end),1),InDat(idx(1):idx(end),2)];

[DcOut,sqerrfinal] = CoatSqErFit(InDat,MDcRho,.532,Flag1)

% ** Now Generate Theoretical Data Based on Above Fit **

%%             CotThDatGen(CorD,MinD,MaxD,NumStep,wavelen,rrlcor,rimcor,rrlsh,rimsh)

% [Size,Resp]=CotThDatGen(CorP,MinD,MaxD,NumStep,wavelen,rrlcor,rimcor,rrlsh,rimsh,flag)
[Size1,Resp]=CotThDatGen(DcOut,InDat(1,1),InDat(end,1),100,0.532,MDcRho(1),MDcRho(2),MDcRho(3),MDcRho(4));
TDat=[Size1',Resp'];


% Compute rsquare
for i=1:length(InDat(:,1))
    [Resp_Corr(i)]=MCCoat(1,MDcRho(1),MDcRho(2),MDcRho(3),MDcRho(4),0.532,DcOut,scdp(InDat(i,1),MDcRho(end)),1);
end

for i=1:length(InDat(:,1))
    dp(i)=scdp(InDat(i,1),MDcRho(end));
end

figure,plot(dp,InDat(:,2)),hold on,
plot(TDat(:,1),TDat(:,2),'r-');



r2=corrcoef([InDat(:,2),Resp_Corr']);

warning on