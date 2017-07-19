sfunction [nDens,sqerrfinal] = WtdSqErFit(ExpDat,RefDens,k,lambda,FitFlag)
% Fitting to refractive index
% RefDens=[n,rho]
% FitFlag == 0 Do a fit to indx of refraction; 1, do a fit to density
%         == 2 Do a fit to both index of refraction and density
% sqerrfinal = final value of the least squares error function
% ExpVal are the experimental cross sections (cm^2)
% nint = starting point for the fminsearch function
% k = complex index of refraction
% lambda = wavelength of incident light
% diameter = diameter of particle.
% CalS = Calibration (cross section vs peak area) curve slope
% CalInt = Calibration intercept
global refmed k lambda da ExpDat refreal dens
refmed=1;
dens=RefDens(2);
refreal=RefDens(1);
da=ExpDat(:,1)';
if FitFlag == 0
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitN,refreal,optimset('Display','iter'));
    nDens(1)=nDens(1);nDens(2)=dens;
elseif FitFlag == 1
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitRho,dens,optimset('Display','iter'));
elseif FitFlag == 2 
    [nDens,sqerrfinal,ExitFlg] = fminsearch(@FitNRho,RefDens,optimset('Display','iter'));
end 
if ExitFlg == 1
    disp('Minimization algorithm has converged.')
elseif ExitFlg == 0
    disp('Maximum function evaluations exceeded.')
    disp('Minimization algorithm has not converged.')
elseif ExitFlg == -1
    disp('Algorithm was terminated by the output function.')
end
clear global refmed k lambda da ExpDat refreal dens
% -------------------------------------------------------------------------
function [SqErr] = FitN(DumRef)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed k lambda da ExpDat ExpValErr dens
disp(sprintf('n=%g rho=%g',DumRef,dens))
if length(da)==1;
    SqErr=(((MieCalF(refmed,DumRef,k,lambda,scdp(da(1),dens),1)-...
        MieCalF(refmed,DumRef,k,lambda,scdp(da(1),dens),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,DumRef,k,lambda,scdp(da(1),dens),1)-...
        MieCalF(refmed,DumRef,k,lambda,scdp(da(1),dens),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,DumRef,k,lambda,scdp(da(counter),dens),1)-...
            MieCalF(refmed,DumRef,k,lambda,da(counter)/sqrt(dens),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitRho(DumRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed k lambda da ExpDat ExpValErr refreal
disp(sprintf('n=%g rho=%g',refreal,DumRho))
if length(da)==1;
    SqErr=(((MieCalF(refmed,refreal,k,lambda,scdp(da(1),DumRho),1)-...
        MieCalF(refmed,refreal,k,lambda,scdp(da(1),DumRho),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,refreal,k,lambda,scdp(da(1),DumRho),1)-...
        MieCalF(refmed,refreal,k,lambda,scdp(da(1),DumRho),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,refreal,k,lambda,scdp(da(counter),DumRho),1)-...
            MieCalF(refmed,refreal,k,lambda,scdp(da(counter),DumRho),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end
% -------------------------------------------------------------------------
function [SqErr] = FitNRho(nRho)
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed k lambda da ExpDat ExpValErr 
disp(sprintf('n=%g rho=%g',nRho(1),nRho(2)))
if length(da)==1;
    SqErr=(((MieCalF(refmed,nRho(1),k,lambda,scdp(da(1),nRho(2)),1)-...
        MieCalF(refmed,nRho(1),k,lambda,scdp(da(1),nRho(2)),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
else
    SqErr=(((MieCalF(refmed,nRho(1),k,lambda,scdp(da(1),nRho(2)),1)-...
        MieCalF(refmed,nRho(1),k,lambda,scdp(da(1),nRho(2)),2))-ExpDat(1,2))/...
        (ExpDat(1,3)*ExpDat(1,2)))^2;
    for counter=2:length(da)
        SqErr = SqErr + (((MieCalF(refmed,nRho(1),k,lambda,scdp(da(counter),nRho(2)),1)-...
            MieCalF(refmed,nRho(1),k,lambda,scdp(da(counter),nRho(2)),2))-ExpDat(counter,2))/...
            (ExpDat(counter,3)*ExpDat(counter,2)))^2;
    end
end