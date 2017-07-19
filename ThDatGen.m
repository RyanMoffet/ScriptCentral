function [Size,Resp]=ThDatGen(MinD,MaxD,NumStep,wavelen,refreal,refim)
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
    Resp(k)=mc(1,refreal,refim,wavelen,Size(k),1);
    StepD=StepD+((MaxD-MinD)/NumStep);
end