function [DcOut,sqerrfinal] = CoatSqErFit(ExpDat,mDcRho,lambda,FitFlag)
% % Fitting to refractive index
% % mRhoEta=[nc,kc,ns,ks,rhoc,Eta] where 
% %         nc is n for the core
% %         kc is k for the core
% %         ns is n for the shell
% %         ks is k for the shell
% %         rhoc is the density of the composite
% %         Eta is the volume fraction
% %         
% % FitFlag == 0 Do a fit to indx of refraction
% %         == 1 Do a fit to rho only
% %         == 2 Do a fit to both index of refraction and density
% %         == 3 Do a fit to n, k and rho
% % sqerrfinal = final value of the least squares error function
% % ExpVal are the experimental cross sections (cm^2)
% % nint = starting point for the fminsearch function
% % k = complex index of refraction
% % lambda = wavelength of incident light
% % diameter = diameter of particle.
% % CalS = Calibration (cross section vs peak area) curve slope
% % CalInt = Calibration intercept
% % RhoEta = [rho,eta]


global refmed lambda da ExpDat Ref rho


refmed=1;
Ref=mDcRho(1:4);
Dc=mDcRho(5);
rho=mDcRho(6);
da=ExpDat(:,1)';


[DcOut,sqerrfinal,ExitFlg] = fminsearch(@FitDcRho,[Dc],optimset('Display','iter'));


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


function [SqErr] = FitDcRho(Dc)

global refmed lambda da ExpDat Ref rho


Dc=abs(Dc);
DcLo=0;
DcHi=1;
x=0;z=0;

disp(sprintf('Dc=%g',Dc(1)))

if Dc<DcLo
    x=DcLo-Dc;
end
if Dc(1)>DcHi
    x=Dc-DcHi;
end

for i=1:length(ExpDat(:,1))
    Dp=scdp(ExpDat(i,1),rho);
    if Dc>Dp
        Dc=Dp;
    end
    Fun(i)=(ExpDat(i,2)-MCCoat(1,Ref(1),Ref(2),Ref(3),Ref(4),lambda,Dc,Dp,1))^2;
end

SqErr=sum(Fun)%+(x+z)*10^-11;

% --------v-----------------------------------------------------------------
