function [Size,Resp]=CotThDatGen(CorD,MinD,MaxD,NumStep,wavelen,rrlcor,rimcor,rrlsh,rimsh)
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
    if StepD<CorD
        Size(k)=CorD;
        Resp(k)=MCCoat(1,rrlcor,rimcor,rrlsh,rimsh,wavelen,CorD,0,1);
    elseif StepD>=CorD
        Size(k)=StepD;
        Resp(k)=MCCoat(1,rrlcor,rimcor,rrlsh,rimsh,wavelen,CorD,Size(k),1);
    end
    StepD=StepD+((MaxD-MinD)/NumStep);
end

return