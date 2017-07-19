function [IntAE,IntSSA]=IntegrateAbsEnhancement(CoreSize,nc,kc,nm,km,SizD,SizN)


SizN(isnan(SizN))=0;
SizN(isinf(SizN))=0;

c=SizD;     % take log of centers
dc=diff(c);     % get difference of logDp (centers)

% b(1)=c(1)-dc(1)/2; % initiate calculation of boundries

% for i=1:length(c)
%     b(i+1)=c(i)+avgdc/2; % calculate the rest of the boundries
% end

for i=1:length(c)-1
    bb(i)=c(i)-(c(i+1)-c(i))/2;
    if c(i+1)==c(end)
       bb(i+1)=c(i+1)-(c(i+1)-c(i))/2;
       bb(i+2)=c(i+1)+(c(i+1)-c(i))/2;
   end
end

% b=10.^bb;     % give boundries
dd=diff(log10(bb));  % take difference of boundries

dN=trapz(c,SizN);


%% calculate efficiencies for the cores
for i=1:length(SizD)
    if SizD(i)<CoreSize
        [qscaCore(i),qextCore(i)]=MatBHC(1,0.532,nc,kc,nc,kc,SizD(i),SizD(i));
        CabsCore(i)=(qextCore(i)-qscaCore(i)).*(pi*(SizD(i)/2)^2);
    else
        [qscaCore(i),qextCore(i)]=MatBHC(1,0.532,nc,kc,nc,kc,CoreSize,CoreSize);
        CabsCore(i)=(qextCore(i)-qscaCore(i)).*(pi*(CoreSize/2)^2);
    end
end

%% calculate babs for cores

babs_core=trapz(c,SizN.*CabsCore);
bsca=qscaCore.*pi.*(CoreSize/2).^2.*sum(SizN).*mean(dd);
bext=qextCore.*pi.*(CoreSize/2).^2.*sum(SizN).*mean(dd);


%% calculate qsca, qext and Cabs for the core-shell particles
for i=1:length(SizD)
    if SizD(i)<CoreSize
        [qscaCM(i),qextCM(i)]=MatBHC(1,0.532,nc,kc,nc,kc,SizD(i),SizD(i));
    else
        [qscaCM(i),qextCM(i)]=MatBHC(1,0.532,nc,kc,nm,km,CoreSize,SizD(i));
    end
end
Cabs=(qextCM-qscaCM).*(pi.*(SizD./2).^2);
Csca=qscaCM.*(pi.*(SizD./2).^2);
Cext=qextCM.*(pi.*(SizD./2).^2);

kernel=Cabs.*SizN;
babs_CorSh=trapz(c,kernel);
IntAE=babs_CorSh./babs_core
figure,semilogx(SizD,Cabs./CabsCore);



bsca_CorSh=trapz(c,Csca.*SizN);
bext_CorSh=trapz(c,Cext.*SizN);
IntSSA=bsca_CorSh./bext_CorSh

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
