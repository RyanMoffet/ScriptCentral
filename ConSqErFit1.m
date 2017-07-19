function [nkDens,sqerrfinal] = ConSqErFit1(ExpDat,RefKDens,lambda,FitFlag)
% Fitting to refractive index
% RefKDens=[nlo,nhi,klo,khi,rholo,rhohi]
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
global nlo nhi klo khi rholo rhohi
refmed=1;
if FitFlag==3
    dens=(RefKDens(6)+RefKDens(5))/2;
    refreal=(RefKDens(2)+RefKDens(1))/2;
    refimag=abs((RefKDens(4)+RefKDens(3))/2);
    da=ExpDat(:,1)';
    nlo=RefKDens(1);
    nhi=RefKDens(2);
    klo=RefKDens(3);
    khi=RefKDens(4);
    rholo=RefKDens(5);
    rhohi=RefKDens(6);
elseif FitFlag==2
    dens=(RefKDens(6)+RefKDens(5))/2;
    refreal=(RefKDens(2)+RefKDens(1))/2;
    refimag=abs((RefKDens(4)+RefKDens(3))/2);
    da=ExpDat(:,1)';
    nlo=RefKDens(1);
    nhi=RefKDens(2);
    klo=RefKDens(3);
    khi=RefKDens(4);
    rholo=RefKDens(5);
    rhohi=RefKDens(6);
elseif FitFlag==4
    dens=(RefKDens(5));
    refreal=(RefKDens(2)+RefKDens(1))/2;
    refimag=abs((RefKDens(4)+RefKDens(3))/2);
    da=ExpDat(:,1)';
    nlo=RefKDens(1);
    nhi=RefKDens(2);
    klo=RefKDens(3);
    khi=RefKDens(4);
end
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
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNKRho,[refreal,refimag,dens],optimset('Display','iter'));
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
clear global nlo nhi klo khi rholo rhohi
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
global nlo nhi klo khi rholo rhohi
disp(sprintf('m=%g+%gi rho=%g',mRho(1),refimag,mRho(2)))
% mRho=abs(mRho); % a hack to get rid of negative values
x=0;y=0;z=0;
if mRho(1)<nlo
    x=nlo-mRho(1);
end
if mRho(1)>nhi
    x=mRho(1)-nhi;
end
if mRho(2)<rholo
    z=rholo-mRho(2);
end
if mRho(2)>rhohi
    z=mRho(2)-rhohi;
end
for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,mRho(1),refimag,lambda,scdp(ExpDat(i,1),mRho(2)),1))^2;
end
N=length(ExpDat(:,2));
SqErr=sum(Fun)+(x+y+z)*10%e-9;

% -------------------------------------------------------------------------
function [SqErr] = FitNKRho(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat
global nlo nhi klo khi rholo rhohi
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(2),mRho(3)))
x=0;y=0;z=0;
if mRho(1)<nlo
    x=nlo-mRho(1);
end
if mRho(1)>nhi
    x=mRho(1)-nhi;
end
if mRho(2)<klo
    y=klo-mRho(2);
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
N=length(ExpDat(:,2));
SqErr=sum(Fun)+(x+y+z)*10e-9;
% -------------------------------------------------------------------------
function [SqErr] = FitNK(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat dens
global nlo nhi klo khi rholo rhohi
mRho(2)=abs(mRho(2));
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(2),dens))
x=0;y=0;
if mRho(1)<nlo
    x=nlo-mRho(1);
end
if mRho(1)>nhi
    x=mRho(1)-nhi;
end
if mRho(2)<klo
    y=klo-mRho(2);
end
if mRho(2)>khi
    y=mRho(2)-khi;
end
for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,mRho(1),mRho(2),lambda,scdp(ExpDat(i,1),dens),1))^2;
end
SqErr=sum(Fun)+(x+y)*10e-9;
