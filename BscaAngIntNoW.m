function [B]=BscaAngIntNoW(sizdist,siz,nc,ns,kc,ks,VolFrac,CalcType)

%% This function integrates a size distribution to find extinction and absorption coefficients
%% 
%% sizdist is the y-axis of the size distribution. A matrix with rows of time and cols of size.
%% siz is the x-axis of the size distribution
%% wavelen is the wavelength of the spectral response function for neph
%% SpecResp is the spectral response of the nephelometer
%% nc, ns, kc, ks are the real and imaginary ri's for the core and shell 
%% VolFrac is the volume fraction of the core
%% CalcType: AngMieSca => partial angular range, mie, scattering coefficient
%%           AngCotSca => partial angular range, coated spheres, scattering coefficient
%%           AngCotAbs => partial angular range, coated spheres, absorption coefficient

if strcmp(CalcType,'AngMieSca') | strcmp(CalcType,'AngCotSca')
    ua=170;
    la=10;
elseif strcmp(CalcType,'TotMieSca')
    ua=180;
    la=0;
    CalcType = 'AngMieSca';
elseif strcmp(CalcType,'TotCotSca')
    ua=180;
    la=0;
    CalcType = 'AngCotSca';
end

switch CalcType
case 'AngMieSca'
    for j=1:length(sizdist(:,1))
        for k=1:length(sizdist(1,:))
            if isnan(sizdist(j,k))
                Kernel(k)=0;
            else
                Kernel(k)=sizdist(j,k)*MieAngFun(1,nc,kc,0.520,siz(k),la,ua,1)...  
                    *(siz(k)*1e-6)^2*(100)^3;  
            end
        end
        if sum(Kernel)==0
            B(j)=0;
        else
            B(j)=sum(Kernel);
        end
    end
    
case 'AngCotSca'   
    for j=1:length(sizdist(:,1))
        for k=1:length(sizdist(1,:))
            if isnan(sizdist(j,k))
                Kernel(k)=0;
            else
                Kernel(k)=sizdist(j,k)*MieAngFun(1,nc,kc,0.520,siz(k),la,ua,1)...  
                    *(siz(k)*1e-6)^2*(100)^3;  
            end
        end
        if sum(Kernel)==0
            B(j)=0;
        else
            B(j)=sum(Kernel);
        end
    end
    
% case 'AngCotAbs'
%     for k=1:length(sizdist(:,1))
%         for i=1:length(sizdist(1,:))
%             if isnan(sizdist(k,i)) 
%                 Kernel(i)=0;
%             else
%                 Dp(i)=siz(i);
%                 Dc(i)=Dp(i)*VolFrac^(1/3);
%                 Qabs(i)=QabsCot(1,1.7,0.5,1.33,0,0.532,Dc(i),Dp(i));
%                 Kernel(i)=Qabs(i)*sizdist(k,i)*1/siz(i)*10^12*(3/2);
%             end
%         end
%         B(k)=trapz(log10(siz),Kernel);
%     end
end

