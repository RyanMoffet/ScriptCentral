function [nkDens,sqerrfinal] = SqErFit(ExpDat,RefKDens,lambda,FitFlag)
% Fitting to refractive index
% RefKDens=[n,rho,k]
% FitFlag == 0 Do a fit to indx of refraction
%         == 1 Do a fit to rho only
%         == 2 Do a fit to both index of refraction and density
%         == 3 Do a fit to n, k and rho
% sqerrfinal = final value of the least squares error function
% ExpVal are the experimental cross sections (cm^2)
% nint = starting point for the fminsearch function
% k = complex index of refraction
% lambda = wavelength of incident light
% diameter = diameter of particle.
% CalS = Calibration (cross section vs peak area) curve slope
% CalInt = Calibration intercept
% ndens = [n,k,rho]
global refmed lambda da ExpDat refreal dens refimag
refmed=1;
dens=RefKDens(3);
refreal=RefKDens(1);
refimag=abs(RefKDens(2));
da=ExpDat(:,1)';
if FitFlag == 0
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitN,refreal,optimset('Display','iter'));
    nkDens=[nDens(1),refimag,dens];
elseif FitFlag == 1
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitRho,dens,optimset('Display','iter'));
    nkDens=[refreal,refimag,nDens(1)];
elseif FitFlag == 2 
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNRho,[refreal,dens],optimset('Display','iter'));
    nkDens=[nDens(1),refimag,nDens(2)];
elseif FitFlag == 3
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNKRho,RefKDens,optimset('Display','iter'));
    nkDens=nDens;
elseif FitFlag == 4
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNK,[refreal,refimag],optimset('Display','iter'));
    nkDens=[nDens(1),nDens(2),dens];
end 
if ExitFlg == 1
    disp('Minimization algorithm has converged.')
elseif ExitFlg == 0
    disp('Maximum function evaluations exceeded.')
    disp('Minimization algorithm has not converged.')
elseif ExitFlg == -1
    disp('Algorithm was terminated by the output function.')
end
clear global refmed lambda da ExpDat refreal dens refimag
% -------------------------------------------------------------------------
function [SqErr] = FitN(DumRef)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda ExpDat dens refimag
disp(sprintf('m=%g+%gi rho=%g',DumRef,refimag,dens))

for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,DumRef,refimag,lambda,scdp(ExpDat(i,1),dens),1))^2;
end
SqErr=sum(Fun);

% -------------------------------------------------------------------------
function [SqErr] = FitRho(DumRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat refreal refimag
disp(sprintf('m=%g+%gi rho=%g',refreal,refimag,DumRho))

for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,refreal,refimag,lambda,scdp(ExpDat(i,1),DumRho),1))^2;
end
SqErr=sum(Fun);

% -------------------------------------------------------------------------
function [SqErr] = FitNRho(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat refimag  
disp(sprintf('m=%g+%gi rho=%g',mRho(1),refimag,mRho(2)))
mRho=abs(mRho); % a hack to get rid of negative values
for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,mRho(1),refimag,lambda,scdp(ExpDat(i,1),mRho(2)),1))^2;
end
SqErr=sum(Fun);

% -------------------------------------------------------------------------
function [SqErr] = FitNKRho(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat 
mRho=abs(mRho);
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(2),mRho(3)))
mRho=abs(mRho);
nlo=1.33;
nhi=2;
klo=0;
khi=1;
rholo=.5;
rhohi=3;
x=0;y=0;z=0;
if mRho(1)<nlo
    x=nlo-mRho(1);
end
if mRho(1)>nhi
    x=mRho(1)-nhi;
end
if mRho(2)<klo
    y=mRho(2)-klo;
end
if mRho(2)>khi
    y=mRho(2)-khi;
end
if mRho(3)<rholo
    z=rholo-mRho(3);
end
if mRho(3)>rhohi
    z=mRho(3)-rhohi;
end
for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,mRho(1),mRho(2),lambda,scdp(ExpDat(i,1),mRho(3)),1))^2;
end
SqErr=sum(Fun)+(x+y+z)*10^-11;
% -------------------------------------------------------------------------
function [SqErr] = FitNK(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat dens
mRho(2)=abs(mRho(2));
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(2),dens))

for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,mRho(1),mRho(2),lambda,scdp(ExpDat(i,1),dens),1))^2;
end
SqErr=sum(Fun);
