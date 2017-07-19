function [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
% 
% C Program SCATTER is designed to calculate scattering cross section
% C (cm2) vs particle diameter (um) for a sphere illuminated by a laser
% C beam for various scattering geometries.
% C Formulae by  W.W. Szymanski (1986), init. program by S. Palm (1986).
% C Final corrections by A. Majerowicz (1986).
% C Corrections to off-axis calculations and modification of integration
% C tolerance conditions by M. Stolzenburg (1990).
% SCATTER was translated into MATLAB and renamed "MieCalF" by R. Moffet (2004)
%
% REFMED = Refractive index of the medium (air, water,etc...)
% REFPART = Refractive index of the paricle
% WAVELEN = Wavelength of incident light
% DIAMETER = Diameter of the particle
% LGEOM = Scattering Geometry = 1 for on axis = 2 for off axis
global X REFREL ILLUM LGEOM BETA1 BETA2 THETA0 PHI0 PI
REFPART=n+k*i;
PI=acos(-1.0);
% C *** INTEGRATION TOLERANCE ***
TOLR=1.E-5;
% C *** QUAD OUTPUT ***
% LDBG = 0 - no output =1 - output final iteration of quatr
% =2 - output every iteration of qatr
LDBG=0;
%
%  ILLUM   Beams            |   LGEOM  Axis        PHI Range
%    1    single            |     1     on         -PI to +PI
%    2    dual,incoherent   |     2     off  PHI0-DPHI to PHI0+DPHI
%    3    dual,coherent     |
ILLUM=1;
if LGEOM == 1 
    BETA1DEG=7.2;
    BETA2DEG=172.8;
    BETA1=BETA1DEG*PI/180.;
    BETA2=BETA2DEG*PI/180.;
    THETALO=BETA1;
    THETAHI=BETA2; 
else
    BETA1DEG=0.;
    BETA2DEG=73.;
    BETA1=BETA1DEG*PI/180.;
    BETA2=BETA2DEG*PI/180.; 
    THETA0DEG=90.;
    THETA0=THETA0DEG*PI/180.;
    PHI0DEG=90.;
    PHI0=PHI0DEG*PI/180.;
    THETALO=THETA0-BETA2;
    THETAHI=THETA0+BETA2; 
end
% C
% C ****   Calculate Machine Precision **** WHY!??
% C
NPREC=0;
NPREC=NPREC+1;
while 1+(1/2)^NPREC > 1.000000 %GOTO 80
    NPREC=NPREC+1; %80
end
PRECCAL=(1/2)^(NPREC-1);
NPREC=0;
NPREC=NPREC+1;
PRECSTO=1+(1/2)^NPREC;
while PRECSTO > 1.000000 %GOTO 85
    NPREC=NPREC+1; %85
    PRECSTO=1+(1/2)^NPREC;
end
PRECSTO=(1/2)^(NPREC-1);

% C
% C **** USE SYMMETRY ABOUT THETA=90 TO MINIMIZE INTEGRATION RANGE ****
% C
FSYM=1.;
if abs(THETAHI+THETALO-PI) < 1.0E-5 
    THETAHI=PI/2;
    if ILLUM == 1;
        ILLUM = 2;
    else
        FSYM=2;
    end
end
% C
% C **** CALCULATE PARAMETERS ****
% C
FACTOR=FSYM*(0.5E-4*WAVELEN/PI)^2;
REFREL=REFPART/REFMED;
X=(PI*DIAMETER*REFMED)/WAVELEN;
VOL=PI*DIAMETER^3/6;
% C
% C Start of Integration
% C
% X, REFREL, ILLUM, LGEOM, BETA1, BETA2, THETA0, PHI0,THETALO,THETAHI,TOLR,LDBG
[R] = QATR(THETALO,THETAHI,0.,TOLR,LDBG);
CrossSection = R*FACTOR;
clear global X REFREL ILLUM LGEOM BETA1 BETA2 THETA0 PHI0 PI
%********************************************************************
% Begin Sub function QATR
%********************************************************************

function [Y]=QATR(XL,XU,EPS,ERR,LDBG,Y)

% C Subroutine to integrate the function fnmie(x) using Romberg quadrature
% C XL,XU = lower, upper limits of integral
% C EPS = absolute error bound for the numerical integration
% C ERR = relative error bound for the numerical integration
% C NDIM = maximum number of bisections of integration domain
% C LDBG = flag for debugging output
% C FCT = user defined function or integrand to be integrated
% C Y = returned value of integral
% C IER = error flag or number of bisections done
% C   1<=IER<=NDIM: number of bisections done, convergence criterion met
% C       IER>NDIM: convergence criterion not met, NDIM bisections done
% C
% C DELT1 = estimated error for previous iteration
% C DELT2 = estimated error for current iteration
% C ICNV = no. of consecutive iterations ABS(DELT2) has decreased
% C JCNV = no. of consecutive iterations ABS(DELT2) has been
% C        within at least one of the error bounds EPS or ERR
% C Convergence is accepted when (JCNV>=NCNV) or (ICNV>=MCNV and JCNV>0).
% C When integrating over highly oscillatory Mie scattering patterns false
% C apparent convergence sometimes occurs when only two consecutive
% C iterations are considered.  More complex convergence criteria applied
% C here virtually eliminates the possibility of acceptance of a false
% C convergence.
% C
global REFREL ILLUM BETA1 BETA2 THETA0 PHI0 PI

NDIM = 15;
I=1;
AUX(1) = (fnmie(XL)+fnmie(XU))/2;
DELT2 = 0.;
H = XU-XL;
if H == 0 % GOTO 8
    IER=I; % 8
    Y = H*AUX(1);
    if LDBG == 1 
        disp(sprintf('Qatr Iter = %g Err = %g Rel Err = %g',...
            I,DELT2,abs(DELT2/AUX(1))))
    end % exit 
else
    E = EPS/abs(H);
    MCNV = 5;
    ICNV = 0;
    NCNV = 3;
    JCNV = 0;
    JJ = 1;
    for I=2:NDIM;
        RJJ = JJ;
        SM = 0;
        for J=1:JJ;
            Xeval = XL+((J-0.5)/RJJ)*H;
            SM = SM + fnmie(Xeval);
        end     
        AUX(I) = (AUX(I-1)+SM/RJJ)/2;
        Y = AUX(1);
        Q = 1;
        for II=I-1:-1:1
            Q = 4*Q;
            AUX(II) = AUX(II+1) + (AUX(II+1)-AUX(II))/(Q-1);
        end
        DELT1 = DELT2;
        DELT2 = Y-AUX(1);
        if LDBG == 2 
            disp(sprintf('Qatr Iter = %g Err = %g Rel Err = %g y = %g',...
                I,DELT2,abs(DELT2/AUX(1)),AUX(1)))
        end
        if abs(DELT2) > abs(DELT1) 
            ICNV = -1;
        end
        ICNV = ICNV+1;    
        if abs(DELT2) > E & abs(DELT2/AUX(1)) > ERR 
            JCNV = -1;
        end
        JCNV = JCNV+1;    
        if (ICNV >= MCNV & JCNV > 0) | JCNV >= NCNV 
%             disp('Integration convergence accepted')
            break
        end
        JJ= 2 * JJ;
    end
    IER=I;
    if (IER+1)>NDIM
        disp(sprintf('convergence criterion not met %g bisections done'...
            ,NDIM+1))
    end
    Y = H*AUX(1);
    if LDBG == 1 
        disp(sprintf('Qatr Iter = %g Err = %g Rel Err = %g',...
            I,DELT2,abs(DELT2/AUX(1))))
    end % exit 
end
%********************************************************************
% Begin Sub function FNMIE
%********************************************************************
function [Response]=fnmie(THETA)

% Returns scattered intensity per dTHETA at zenith THETA
% over azimuth PHI range specified by LGEOM with ILLUMination
%
%  ILLUM   Beams            |   LGEOM  Axis        PHI Range
%    1    single            |     1     on         -PI to +PI
%    2    dual,incoherent   |     2     off  PHI0-DPHI to PHI0+DPHI
%    3    dual,coherent     |
%
%
global X REFREL ILLUM LGEOM BETA1 BETA2 THETA0 PHI0 PI
[s1,s2,SI1,SI2]=bhangf(X,REFREL,THETA);
% C
% C Calculates scattering cross section of particles over specified
% C collection geometry (LGEOM) 
% C
% C  LGEOM  Axis        PHI Range
% C   1     on         -PI to +PI
% C   2     off  PHI0-DPHI to PHI0+DPHI
% C
% C *** INTEGRATION GEOMETRY ***
% See Hodkinson, R.J.; Greenfield,J.R Appl. Opt Vol. 4 No. 11 p1463 for a
% complete description of the (complicated) geometry.
if ILLUM ==1
    I1=abs(s1)^2;
    I2=abs(s2)^2;
elseif ILLUM ==2
    I1=abs(s1)^2+abs(SI1)^2;
    I2=abs(s2)^2+abs(SI2)^2;
else
    I1=abs(s1+SI1)^2;
    I2=abs(s2+SI2)^2;
end
if LGEOM == 1 
    Response=(I1+I2)*PI*sin(THETA);
else
    DPHI=(cos(BETA2)-cos(THETA)*cos(THETA0))...
        /(sin(THETA)*sin(THETA0));
    if DPHI < 0
        DPHI = acos(-min(abs(DPHI),1.));
    else        
        DPHI=acos(min(abs(DPHI),1.));
    end
    FD=0.25*(sin(2.*(PHI0+DPHI))-sin(2.*(PHI0-DPHI)));
    if abs(THETA-THETA0) < BETA1 
        DPHI1=(cos(BETA1)-cos(THETA)*cos(THETA0))...
            /(sin(THETA)*sin(THETA0));
        if DPHI1 < 0
            DPHI1 = acos(-min(abs(DPHI1),1.));
        else        
            DPHI1=acos(min(abs(DPHI1),1.));
        end
        DPHI=DPHI-DPHI1;
        FD=FD-0.25*(sin(2.*(PHI0+DPHI1))-sin(2.*(PHI0-DPHI1)));
    end
    Response=(I1*(DPHI-FD)+I2*(DPHI+FD))*sin(THETA);
end
%********************************************************************
% Begin Sub function bhangf...a deviant of bhmie. See "Absorption and 
% Scattering of Light by Small Particles" by Bohren and Huffman for a
% complete description of the orignal fortran code.
%********************************************************************
function [s1,s2,SI1,SI2]=bhangf(X,REFREL,THETA)
% C
% C Series terminated after NSTOP terms
% C       
XSTOP=X+4*X^(1/3)+2.0;
NSTOP=ceil(XSTOP);
if (NSTOP>3000) 
    disp('ERROR IN SUBROUTINE BHMIE')
    disp('ARRAY D() IS NOT LARGE ENOUGH')
    disp(sprintf('TRY DIMENSION OF GREATER THAN',NSTOP))
end
% C
% C Logarithmic derivative D(J) calculated by DOWNWARD
% C recurrence beginning with initial value 0.0+I*0.0
% C at J = NMX
% C
Y=X*REFREL;
NMX=ceil(max(XSTOP,abs(Y)))+15;
D1=0.0+0.0*i;
for N = NMX:-1:2;
    RN=real(N);
    D1=(RN/Y)-(1/(D1+RN/Y));
    D(min(NSTOP,N-1))=D1;
end
% C
% C Riccati-Bessel functions with real argument X
% C calculated by upward recurrence
% C
DX=X;
PSI1=cos(DX);
PSI=sin(DX);
CHI1=-sin(X);
CHI=cos(X);
APSI=real(PSI);
XI=APSI-CHI*i;
QSCA=0.0;
QEXT=0.0;
S1B=0.0+0.0*i;
SGNN=1;
for N=1:NSTOP;
    DN=N;
    RN=N;
    PSI0=PSI1;
    PSI1=PSI;
    PSI=(2*DN-1)*PSI1/DX-PSI0;
    CHI0=CHI1;
    CHI1=CHI;
    CHI=(2*RN-1)*CHI1/X-CHI0;
    APSI1=APSI;
    APSI=real(PSI);
    XI1=XI;
    XI=APSI-CHI*i;
    AN(N)=((D(N)/REFREL+RN/X)*APSI-APSI1)...
        /((D(N)/REFREL+RN/X)*XI-XI1);
    BN(N)=((D(N)*REFREL+RN/X)*APSI-APSI1)...
        /((D(N)*REFREL+RN/X)*XI-XI1);
    SGNN=-SGNN;
    QSCA=QSCA+(2*RN+1)*(abs(AN(N))^2+abs(BN(N))^2);
    QEXT=QEXT+(2*RN+1)*real(AN(N)+BN(N));
    S1B=S1B+SGNN*(2*RN+1)*(BN(N)-AN(N));
end
X1=X;
REFREL1=REFREL;
% C
% C Angular dependent factors PI and TAU
% C calculated by upward recurrence
% C
AMU=cos(THETA);
PI1=0.0;
PI=1.0;
S1=0+0*i;
S2=0+0*i;
SI1=0+0*i;
SI2=0+0*i;
SGNN=1;
for N=1:NSTOP;
    RN=real(N);
    FN=(2.*RN+1)/(RN*(RN+1));
    SGNN=-SGNN;
    TAU=RN*AMU*PI-(RN+1)*PI1;
    S1=S1+FN*(BN(N)*TAU+AN(N)*PI);
    S2=S2+FN*(AN(N)*TAU+BN(N)*PI);
    SI1=SI1+SGNN*FN*(BN(N)*TAU-AN(N)*PI);
    SI2=SI2+SGNN*FN*(AN(N)*TAU-BN(N)*PI);
    PI0=PI1;
    PI1=PI;
    PI=((2*RN+1)/RN)*AMU*PI1-(RN+1)*PI0/RN;
end
s1=S1;
s2=S2;