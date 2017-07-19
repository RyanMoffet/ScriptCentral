function [value] = SlipRatio(Da,Dp)

%% This script will evaluate the ratio of slip correction factors evaluated
%% at Da and Dp respectively: value = Cc(Da)/Cc(Dp)
%%
%% Da = the aerodynamic diameter in micrometers
%% Dp = the geometric (optical) diameter in micrometers
%%
%% value = Cc(Da)/Cc(Dp)


value = (Da.*(Dp + 3.4392e-7))./(Dp.*(Da + 3.4392e-7));
