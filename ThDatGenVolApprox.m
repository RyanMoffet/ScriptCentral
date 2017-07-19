function [Size,Resp]=ThDatGenVolApprox(CorD,MinD,MaxD,NumStep,wavelen,n1,k1,n2,k2,flag)
% This script plots ATOFMS scattering response vs size
% Size = diameter of the particle in micrometers
% Resp = scattering cross section collected by the atofms scattering
% mirrors
% MinD = Minimum Diameter to be used (in microns)
% MaxD = Maximum diameter to be used (in microns)
% NumStep = Number of points to be evauated 
% wavelen = wavelength of light (in microns)
% refreal = real part of the refractive index
% refim = imaginary part of the refractive index.
% This function uses MieCalF which is called as:
% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
% Ryan Moffet Oct '04.
StepD=MinD;
for k=1:NumStep;
    Size(k)=StepD; 
    if StepD<CorD
        StepD=StepD+((MaxD-MinD)/NumStep);
        continue
    elseif StepD>=CorD
        if flag==1
            nvol=(CorD^3*n1+Size(k)^3*n2)/(CorD^3+Size(k)^3);
            kvol=(CorD^3*k1+Size(k)^3*k2)/(CorD^3+Size(k)^3);
        elseif flag==2
%%This was comparison to Horvath
%             nvol=(CorD^3*n1+.5^3*n2)/(CorD^3+.5^3);
%             kvol=(CorD^3*k1+.5^3*k2)/(CorD^3+.5^3);
%%  Now compare to Ebert 2002
            nvol=1.5;
            kvol=.05;
           
        end
        Resp(k)=mc(1,nvol,kvol,wavelen,Size(k),1);
        StepD=StepD+((MaxD-MinD)/NumStep);
    end
end