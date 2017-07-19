function [nkDens,sq_errfinal,TDat,r2]=ParamFit(InDat,StartSize,StopSize,NKRho,Flag)
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

% ** fit to mie theory using SqErFit ** 
warning off
[nkDens,sqerrfinal] = SqErFit(InDat,NKRho,.532,Flag);

% if Flag == 0
%     n_final=nkDens(1);
%     rho_final=NKRho(2);
%     k_final=NKRho(3)
% elseif Flag == 1 
%     n_final=NKRho(1);
%     rho_final=nkDens(1);
%     k_final=NKRho(3)
% elseif Flag == 2
%     n_final=nkDens(1);
%     rho_final=nkDens(2);
%     k_final=NKRho(3);
% elseif Flag == 3
%     n_final=nkDens(1);
%     rho_final=nkDens(2);
%     k_final=nkDens(3);
% end

sq_errfinal=sqerrfinal;

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

% [Size_Corr,Resp_Corr]=ATOFMSScattFunGenA(scdp(InDat(:,1),rho_final),.532,n_final,0);
r2=corrcoef([InDatSC',Resp_Corr']);

% Plot Results

disp(sprintf('r^{2} = %g',r2(1,2)))
% figure,plot(Size1,Resp,'-*k'),hold on
% plot(InDatSC(:),InDat(:,2),'-or');
% xlabel('D_{p} (\mum)','FontSize',10)
% ylabel('Cross Section (cm^{2})','FontSize',10)
% title('Measurment vs. Theory')
% legend('measured',...
%     sprintf('theory n = %s, r^2=%g',n_final,r2(1,2)))
warning on