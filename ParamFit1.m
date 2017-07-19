function [nkDens,sq_errfinal,TDat,r2]=ParamFit1(InDat,StartSize,StopSize,NKRho,Flag)
% UnkLSFit averages experimental light scattering data and fits the data to
% mie theory
% SizeIntens = [experimental cross sections (cm^2);Da]
% StartSiz = Da to begin theoretical plotting (um)
% StopSiz = Da to begin theoretical plotting (um)

% NKRho = [nlo,nhi,klo,khi,rholo,rhohi] which are upper and lower bounds
%        for the constrained fit. The midpoint is taken as the inital
%        value for the constrained and unconstrained fits.

% Flag = 0 for fit to real part of refractive index, 1 for fit to density
%      = 2 for fit to real part of refractive index and density
%      = 3 for fit to real and imaginary part of RI and density
%      = 4 for fit to real and imaginary part of RI (fixed density)
% TDat = Best fit theoretical model output = [size,intens]
% Ryan Moffet Nov '04

% ** fit to mie theory using SqErFit ** 
warning off

j=1;
for i=1:length(InDat(:,1))
    if InDat(i,1)<StartSize | InDat(i,1)>StopSize
        continue
    else
        FitDat(j,:)=InDat(i,:);
        j=j+1;
    end
end

[nkDens,sqerrfinal] = ConSqErFit1(FitDat,NKRho,0.532,Flag)

sq_errfinal=sqerrfinal;

% ** Now Generate Theoretical Data Based on Above Fit **

[Size1,Resp]=ThDatGen(StartSize,StopSize,200,.532,nkDens(1),nkDens(2));
TDat=[Size1',Resp'];

% Compute rsquare
for i=1:length(FitDat(:,1))
    Size_Corr(i)=scdp(FitDat(i,1),nkDens(3));
    [Resp_Corr(i)]=mc(1,nkDens(1),nkDens(2),0.532,Size_Corr(i),1);
end

for i=1:length(FitDat(:,1))
    dp(i)=scdp(FitDat(i,1),nkDens(3));
end

figure,plot(dp,FitDat(:,2)),hold on,
plot(TDat(:,1),TDat(:,2),'r-');

r2=corrcoef([FitDat(:,2),Resp_Corr']);

disp(sprintf('r^{2} = %g',r2(1,2)^2))
warning on