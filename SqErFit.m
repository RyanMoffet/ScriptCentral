function [nDens,sqerrfinal] = SqErFit(ExpDat,RefKDens,lambda,FitFlag)
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
global refmed lambda da ExpDat refreal dens refimag
refmed=1;
dens=RefKDens(2);
refreal=RefKDens(1);
refimag=abs(RefKDens(3));
da=ExpDat(:,1)';
if FitFlag == 0
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitN,refreal,optimset('Display','iter'));
    nDens(1)=nDens(1);nDens(2)=dens;
elseif FitFlag == 1
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitRho,dens,optimset('Display','iter'));
elseif FitFlag == 2 
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNRho,RefKDens,optimset('Display','iter'));
elseif FitFlag == 3
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNKRho,RefKDens,optimset('Display','iter'));
elseif FitFlag == 4
    NandK=[RefKDens(1),RefKDens(3)]
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNK,NandK,optimset('Display','iter'));
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
global refmed k lambda da ExpDat dens refimag
disp(sprintf('m=%g+%gi rho=%g',DumRef,k,dens))
if length(da)==1;
    SqErr=(((MieCalF(refmed,DumRef,refimag,lambda,scdp(da(1),dens),1)-...
        MieCalF(refmed,DumRef,refimag,lambda,scdp(da(1),dens),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,DumRef,refimag,lambda,scdp(da(1),dens),1)-...
        MieCalF(refmed,DumRef,refimag,lambda,scdp(da(1),dens),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,DumRef,refimag,lambda,scdp(da(counter),dens),1)-...
            MieCalF(refmed,DumRef,refimag,lambda,scdp(da(counter),dens),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitRho(DumRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed k lambda da ExpDat refreal refimag
disp(sprintf('m=%g+%gi rho=%g',refreal,refimag,DumRho))
if length(da)==1;
    SqErr=(((MieCalF(refmed,refreal,refimag,lambda,scdp(da(1),DumRho),1)-...
        MieCalF(refmed,refreal,refimag,lambda,scdp(da(1),DumRho),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,refreal,refimag,lambda,scdp(da(1),DumRho),1)-...
        MieCalF(refmed,refreal,refimag,lambda,scdp(da(1),DumRho),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,refreal,refimag,lambda,scdp(da(counter),DumRho),1)-...
            MieCalF(refmed,refreal,refimag,lambda,scdp(da(counter),DumRho),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitNRho(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed k lambda da ExpDat refimag  
disp(sprintf('m=%g+%gi rho=%g',mRho(1),refimag,mRho(2)))
if length(da)==1;
    SqErr=(((MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(1),nRho(2)),1)-...
        MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(1),nRho(2)),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(1),nRho(2)),1)-...
        MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(1),nRho(2)),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(counter),nRho(2)),1)-...
            MieCalF(refmed,nRho(1),refimag,lambda,scdp(da(counter),nRho(2)),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitNKRho(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat 
mRho(3)=abs(mRho(3));
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(3),mRho(2)))
if length(da)==1;
    SqErr=(((MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(1),mRho(2)),1)-...
        MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(1),mRho(2)),2))-ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(1),mRho(2)),1)-...
        MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(1),mRho(2)),2))-ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(counter),mRho(2)),1)-...
            MieCalF(refmed,mRho(1),mRho(3),lambda,scdp(da(counter),mRho(2)),2))-ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitNK(mRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat dens
mRho(2)=abs(mRho(2));
disp(sprintf('m=%g+%gi rho=%g',mRho(1),mRho(2),dens))
for i=1:length(da)
    Fun(i)=((MieCalF(refmed,mRho(1),mRho(2),lambda,scdp(da(i),dens),1)-...
            MieCalF(refmed,mRho(1),mRho(2),lambda,scdp(da(i),dens),2))-ExpDat(i,2))^2;
end
SqErr=sum(Fun);
fprintf(1, 'm = %g + %g *i   rho = %g   error = %E\n', mRho(1), mRho(2), dens, SqErr);
