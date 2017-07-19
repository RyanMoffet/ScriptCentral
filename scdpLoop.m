function val=scdpLoop(da,rho)

% function slipcorrected Dp
% developed in response to reviewers
% scdp is what we get when we combine eqs. the slip corrected form
% of 3.28 in Hinds and eq. 3.19 and solve for Dp 
% this is used in ParamFit and SqErrFit...probably some plotting routines
% too.
for i = 1:length(da)
    val=-1.72*10^-7+(5.73*10^-18*sqrt((1.11*10^28*da+3.21*10^34*da^2+9.02*10^20*rho)*rho)/rho);
end