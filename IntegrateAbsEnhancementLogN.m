function [IntAE,IntSSA]=IntegrateAbsEnhancementLogN(CoreSize,nc,kc,nm,km,SizD,SizN,freshpar)

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

% SizD=sort(SizD.*10e-6);

SizN(isnan(SizN))=0;
SizN(isinf(SizN))=0;

c=SizD;     % take log of centers
dc=diff(c);     % get difference of logDp (centers)

% b(1)=c(1)-dc(1)/2; % initiate calculation of boundries

% for i=1:length(c)
%     b(i+1)=c(i)+avgdc/2; % calculate the rest of the boundries
% end

for i=1:length(c)-1
    bb(i)=c(i)+(c(i+1)-c(i))/2;
    if c(i+1)==c(end)
       bb(i+1)=c(i+1)-(c(i+1)-c(i))/2;
       bb(i+2)=c(i+1)+(c(i+1)-c(i))/2;
   end
end

% b=10.^bb;     % give boundries
dd=diff(log10(bb));  % take difference of boundries

dN=trapz(log10(c),SizN);

% % for i=1:length(SizD)
% %         [qscaCore(i),qextCore(i)]=MatBHC(1,0.532,nc,kc,nc,kc,SizD(i),SizD(i));
% % end
% % CabsCore=(qextCore-qscaCore).*(pi.*(SizD./2).^2);
FreshDist=LogNFuncGen(SizD,[freshpar(1),freshpar(2),1],'HindsNumMon')';
FreshDist=dN.*FreshDist./trapz(log10(c),FreshDist);
trapz(log10(c),FreshDist)
FreshDist(isnan(FreshDist))=0;
normFreshDist=(FreshDist)'./sum(FreshDist);
figure,semilogx(SizD,FreshDist,'k.-'),hold on, semilogx(SizD,SizN,'g.-'),hold off,xlim([0.05,1]);

%% calculate babs for cores

% % babs_core=trapz(SizD,FreshDist.*CabsCore);
% % bsca=qscaCore.*pi.*(CoreSize/2).^2.*sum(SizN).*mean(dd);
% % bext=qextCore.*pi.*(CoreSize/2).^2.*sum(SizN).*mean(dd);


%% calculate qsca, qext and Cabs for the core-shell particles

for j=1:length(SizD) %% core size
    if normFreshDist(j)==0 %% if there are no particles in the core distribution
        babsCor(j)=0;
        bextCor(j)=0;
        bscaCor(j)=0;
        AE(j)=0;
        SSA(j)=0;
    else  %% if the core distribution has particles in it.
        for i=1:length(SizD) %% total particle size
            if i<=j %% if particle size is less than core size,
                [qscaCM,qextCM]=MatBHC(1,0.532,nc,kc,nc,kc,SizD(i),SizD(i)); %% make zero coating
                Cabs(i)=(qextCM-qscaCM).*(pi.*(SizD(i)./2).^2);
                Cext(i)=qextCM.*(pi.*(SizD(i)./2).^2);
                Csca(i)=qextCM.*(pi.*(SizD(i)./2).^2);
                CaCoreOnly(i)=Cabs(i);
            else  %% if core is smaller than total particle size...
                [qscore,qecore]=MatBHC(1,0.532,nc,kc,nm,km,SizD(j),SizD(j));
                [qscaCM,qextCM]=MatBHC(1,0.532,nc,kc,nm,km,SizD(j),SizD(i)); %% do core-shell
                CaCoreOnly(i)=(qecore-qscore).*(pi.*(SizD(j)./2).^2);
                Cabs(i)=(qextCM-qscaCM).*(pi.*(SizD(i)./2).^2);
                Cext(i)=qextCM.*(pi.*(SizD(i)./2).^2);
                Csca(i)=qscaCM.*(pi.*(SizD(i)./2).^2);
            end
        end
        babsCor(j)=trapz(log10(c),Cabs'.*SizN); %% integration over the aged distribution
        bextCor(j)=trapz(log10(c),Cext'.*SizN);
        bscaCor(j)=trapz(log10(c),Csca'.*SizN);
        baCoreOnly(j)=trapz(log10(c),CaCoreOnly'.*SizN);
        AE(j)=babsCor(j)./baCoreOnly(j);
        SSA(j)=bscaCor(j)./bextCor(j);
        clear Cabs Cext Csca qscaCM qextCM babsCor baCoreOnly
    end
end
% Csca=qscaCM.*(pi.*(SizD./2).^2);
% Cext=qextCM.*(pi.*(SizD./2).^2);

% kernel=Cabs.*SizN;
IntAE=sum(normFreshDist.*AE');
IntSSA=sum(normFreshDist.*SSA');
% bext_CorSh=sum(normFreshDist.*bextCor');
% bsca_CorSh=sum(normFreshDist.*bscaCor');
% 
% IntSSA=bsca_CorSh./bext_CorSh;

% IntAE=babs_CorSh./babs_core
% figure,semilogx(SizD,babs_CorSh./babs_core);


% 
% bsca_CorSh=trapz(c,Csca.*SizN);
% bext_CorSh=trapz(c,Cext.*SizN);
% IntSSA=bsca_CorSh./bext_CorSh

% AbsEnhance(AbsEnhance<1)=1;
% SizN(isnan(SizN))=0;
% SizN(isinf(SizN))=0;
% 
% 
% IntAE=sum((AbsEnhance.*SizN)./sum(SizN))%%trapz(c,AbsEnhance.*SizN);
% IntSSA=sum(((qscaCM./qextCM).*SizN)./sum(SizN))
% 
% figure,
% semilogx(SizD,AbsEnhance,'b.-')
% 
% xlabel('D_{p} (\mum)');
% ylabel('Abs. Enhancement');
% 
% 
