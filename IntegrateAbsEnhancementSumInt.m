function [AE,SSA]=IntegrateAbsEnhancementSumInt(CoreSize,nc,kc,nm,km,SizD,SizN,freshpar)

%% IntAE is the integrated (over core and total particle sizes) absorption enhancement
%% IntSSA is the integrated SSA over core and particle sizes.
%%
%% CoreSize is the CoreSize - a relic from an old script
%% nc is the core refractive index
%% kc is the core imaigninary ri
%% nm is the real mantle ri, km is the imag mantle ri
%% SizD are the size bin centers for the particle size distribution (aged) (units must be in um)
%% SizN are the particle concentrations for each size bin SizD (dN/dlogDp - units must be in #/cm^3)
%% freshpar are lognormal parameters describing the fresh soot size distribiution. These parameters
%%          [mean,GSD,N] are to be used to model the core sizes of the aged particles. 


SizN(isnan(SizN))=0;
SizN(isinf(SizN))=0;

c=SizD;     



dN=trapz(log10(c),SizN);

FreshDist=LogNFuncGen(SizD,[freshpar(1),freshpar(2),1],'HindsNumMon')';
FreshDist=dN.*FreshDist./trapz(log10(c),FreshDist);
trapz(log10(c),FreshDist)
FreshDist(isnan(FreshDist))=0;
normFreshDist=(FreshDist)'./sum(FreshDist);
figure,semilogx(SizD,FreshDist,'k.-'),hold on, semilogx(SizD,SizN,'g.-'),hold off,xlim([0.05,1]);


%% calculate AE and SSA from using lognormally distributed cores


%% First step is to build kernel
for i=1:length(SizD) %% loop over total particle size
    for j=1:length(SizD) %% loop over core sizes
        kern_p1(i,j)=normFreshDist(j).*SizN(i);
        if kern_p1>0 | j<i
            [qscore,qecore]=MatBHC(1,0.532,nc,kc,nm,km,SizD(j),SizD(j));  %% do core
            [qscaCM,qextCM]=MatBHC(1,0.532,nc,kc,nm,km,SizD(j),SizD(i)); %% do core-shell
            CaCore(i,j)=(qecore-qscore).*(pi.*(SizD(j)./2).^2);
            CsCM(i,j)=qscaCM.*(pi.*(SizD(i)./2).^2);
            CeCM(i,j)=qextCM.*(pi.*(SizD(i)./2).^2);
            CaCM(i,j)=CeCM(i,j)-CsCM(i,j);
            kern_abscore(i,j)=kern_p1(i,j).*CaCore(i,j);
            kern_absCS(i,j)=kern_p1(i,j).*CaCM(i,j);
            kern_extCS(i,j)=kern_p1(i,j).*CeCM(i,j);
            kern_scaCS(i,j)=kern_p1(i,j).*CsCM(i,j);
        else
            kern_abscore(i,j)=0;
            kern_absCS(i,j)=0;
            kern_extCS(i,j)=0;
            kern_scaCS(i,j)=0;
        end
    end
end
    
ba_core=trapz(log10(c),sum(kern_abscore'));
ba_CS=trapz(log10(c),sum(kern_absCS'));
be_CS=trapz(log10(c),sum(kern_extCS'));
bs_CS=trapz(log10(c),sum(kern_scaCS'));

AE=ba_CS./ba_core;
SSA=bs_CS./be_CS;
