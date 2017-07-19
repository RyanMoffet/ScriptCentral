function [sqerr,finalpar]=LogNFit(meas,par,distype)

%% meas is a matrix containing aps data with da in column 1 and conc in 
%% column 2
%% par contains the inital guesses for the lognormal distribution parameters, namely
%% the mean (mu) standard deviation (sig) and the concentration factor (dn)
%% dn is a multiplicitave factor that aligns the model distribution to the 
%% measured y axis of the aps distribution (concentration) cheers!

%% Ryan Moffet Mar '06 (in Mexico City!)

%% To do: put in nonnegativity constraints...

global meas1

meas1=meas;

switch distype
case 'monomod'
    mu1=par(1);
    sig=par(2);
    dn=par(3);
    [finalpar,sqerr,ExitFlg] = fminsearch(@monomodlogn,[mu1,sig,dn],optimset('Display','iter'));
case 'bimodal'
    mu1=par(1);
    mu2=par(2);
    sig1=par(3);
    sig2=par(4);
    dn1=par(5);
    dn2=par(6);
    [finalpar,sqerr,ExitFlg] = fminsearch(@bimodlogn,[mu1,mu2,sig1,sig2,dn1,dn2],...
        optimset('MaxFunEvals',1e5,'TolX',1e-8,'MaxIter',1e5));
case 'trimodal'
    mu1=par(1);
    mu2=par(2);
    mu3=par(3);
    sig1=par(4);
    sig2=par(5);
    sig3=par(6);
    dn1=par(7);
    dn2=par(8);
    dn3=par(9);
    [finalpar,sqerr,ExitFlg] = fminsearch(@trimodlogn,[mu1,mu2,mu3,sig1,sig2,sig3...
            ,dn1,dn2,dn3],optimset('MaxFunEvals',1e5,'TolX',1e-7,'MaxIter',1e5));
end

if ExitFlg == 1
    disp('Minimization algorithm has converged.')
elseif ExitFlg == 0
    disp('Maximum function evaluations exceeded.')
    disp('Minimization algorithm has not converged.')
elseif ExitFlg == -1
    disp('Algorithm was terminated by the output function.')
end


clear global meas1

%%-----------------------------------------------------------------------------------------------

function [errout] = monomodlogn(params)

global meas1

for i=1:length(meas1(:,1))
    Fun(i)=(meas1(i,2)-params(3)*lognpdf(meas1(i,1),params(1),params(2)))^2;
end
errout=sum(Fun);

%%--------------------------------------------------------------------------------------------------

function [errout] = bimodlogn(params);

global meas1
a=0;b=0;c=0;d=0;e=0;
if params(1)<-1.5  %% mu1
    a=(2-params(1))/0.2*10;
end
if params(1)>-0.3  %% mu1 
    a=(params(1)-0)*10;
end
if params(2)<1.2 %% mu2
    b=(1.5-params(2))/1.5;
end
if params(2)>2.2 %% mu2
    b=(params(2)-10)/10;
end
if params(5)<10 %% dn1
    c=(0-params(5))*100;
end
if params(6)<10 %% dn2
    d=(0-params(6))*100;
end
if params(3)<0.1 %% sig1
    e=(0.1-params(3))*10;
end
if params(3)>1.5 %% sig1
    e=(params(3)-1.5)*10;
end

Fun=(meas1(:,2)-(params(5)*lognpdf(meas1(:,1),params(1),params(3))+...
    (params(6)*lognpdf(meas1(:,1),params(2),params(4))))).^2;

errout=nansum(Fun)+(a^2+b^2+c^2+d^2+e^2)*nansum(Fun);
% sprintf('mu1=%g,  mu2=%g,  sig1=%g,  sig2=%g,  dn1=%g,  dn2=%g',params)

%%--------------------------------------------------------------------------------------------------

function [errout] = trimodlogn(params)

global meas1
a=0;b=0;c=0;d=0;e=0;f=0;

if params(1)<-3  %% mu1
    f=(2-params(1))/0.2*10;
end
if params(1)>-1.5  %% mu1 
    f=(params(1)-0)*10;
end
if params(2)<-1.5  %% mu2
    a=(2-params(1))/0.2*10;
end
if params(2)>-0.3  %% mu2 
    a=(params(1)-0)*10;
end
if params(3)<1.2 %% mu3
    b=(1.5-params(2))/1.5;
end
if params(3)>2.2 %% mu3
    b=(params(2)-10)/10;
end
if params(8)<10 %% dn1
    c=(0-params(5))*100;
end
if params(9)<10 %% dn2
    d=(0-params(6))*100;
end
if params(5)<0.1 %% sig1
    e=(0.1-params(3))*10;
end
if params(5)>1.5 %% sig1
    e=(params(3)-1.5)*10;
end

Fun=(meas1(:,2)-(params(7)*lognpdf(meas1(:,1),params(1),params(4))+...
    (params(8)*lognpdf(meas1(:,1),params(2),params(5)))+...
    (params(9)*lognpdf(meas1(:,1),params(3),params(6))))).^2;

errout=nansum(Fun)+(a^2+b^2+c^2+d^2+e^2+f^2)*nansum(Fun);
