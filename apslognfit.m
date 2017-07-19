function [sqerr,finalpar]=apslognfit(meas,par)

%% meas is a matrix containing aps data with da in column 1 and size in 
%% column 2
%% par contains the inital guesses for the lognormal distribution parameters, namely
%% the mean (mu) standard deviation (sig) and the concentration factor (dn)
%% dn is a multiplicitave factor that aligns the model distribution to the 
%% measured y axis of the aps distribution (concentration) cheers!
%% Ryan Moffet Dec '05

global meas1

meas1=meas;
mu1=par(1);
sig=par(2);
dn=par(3);

[finalpar,sqerr,ExitFlg] = fminsearch(@apssqerr,[mu1,sig,dn],optimset('Display','iter'));

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

function [errout] = apssqerr(params)

global meas1

for i=1:length(meas1(:,1))
    Fun(i)=(meas1(i,2)-params(3)*lognpdf(meas1(i,1),params(1),params(2)))^2;
end
errout=sum(Fun);

