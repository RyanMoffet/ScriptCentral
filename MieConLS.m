function [nDens] = MieConLS(ExpDat,RefKDens,LoB,UpB,lambda,FitFlag)
% Fitting to refractive index
% RefKDens=[n,rho,k]
% FitFlag == 0 Do a fit to indx of refraction; 1, do a fit to density
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
% RefKDensBds=[nhi,nlo;khi,klo

global refmed lambda da ExpDat refreal dens refimag

refmed=1;
dens=RefKDens(2);
% refreal=RefKDens(1);
% refimag=abs(RefKDens(3));
da=ExpDat(:,1)';

NandK = [RefKDens(1),RefKDens(3)];
[nDens] = fmincon(@FitNK,NandK,[],[],[],[],LoB,UpB);
nDens=[nDens(1),dens,nDens(2)];

clear global refmed lambda da ExpDat refreal dens refimag
return

% -------------------------------------------------------------------------

function [SSqFun] = FitNK(NK)

% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat dens

disp(sprintf('m=%g+%gi rho=%g',NK(1),NK(2),dens))

for i=1:length(da)
    Fun(i)=((MieCalF(refmed,NK(1),NK(2),lambda,scdp(da(i),dens),1)-...
            MieCalF(refmed,NK(1),NK(2),lambda,scdp(da(i),dens),2))-ExpDat(i,2))^2;
end
SSqFun=sum(Fun);
return
