function val=scdp(da,rho)

% function slipcorrected Dp
% da is the aerodynamic diameter in micrometers
% rho is the density in g/cm^3
% val is the geometric diameter
% developed in response to reviewers
% scdp is what we get when we combine eqs. the slip corrected form
% of 3.28 in Hinds and eq. 3.19 and solve for Dp 
% this is used in ParamFit and SqErrFit...probably some plotting routines
% too.
% 
val=-1.7196*10^-7+(5.72624*10^-18*sqrt((1.1055*10^28*da+3.21442*10^34*da.^2+9.01813*10^20*rho)*rho)/rho);