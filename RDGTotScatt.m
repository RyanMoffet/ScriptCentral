function [SigAgg] = RDGTotScatt(n,k,Dve)

%%% Define Constants

lambda = 0.550;
a = 0.0125;
k = (2*pi)/lambda;
m = complex(n,k);
fm = abs((m^2-1)/(m^2+2))^2;
N = (Dve./(2*a)).^3;
D = 1.75;
ko = 1.22;
Rg = a.*(N./ko).^(1/D);

Gkrg = (1+(4./(3.*D)).*k^2.*Rg.^2).^(-D/2);

%%% Calculate Scattering Cross Section

SigMon = (8/3)*pi*k^4*a^6*fm;

%%% Calculate Aggeragate Properties

SigAgg = N.^2.*SigMon.*Gkrg;

