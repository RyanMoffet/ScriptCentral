function [B]=BscaAngIntForCraig(sizdist,siz,wavelen,SpecResp,nc,ns,kc,ks,VolFrac,CalcType)

%% This function integrates a size distribution to find extinction and absorption coefficients
%% 
%% sizdist is the y-axis of the size distribution. A matrix with rows of time and cols of size.
%%         normally the distributions are in dV/dlogDp (mks units) but the 'AngMieScat' was changed
%% siz is the x-axis of the size distribution (in nm)
%% wavelen is the wavelength of the spectral response function for neph (in micron)
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

% % [apsidx]=find(insiz>=apssiz);
% % [smpsidx]=find(insiz<apssiz);
% % apssiz1=insiz(apsidx(1):apsidx(end));
% % for i=1:length(apssiz1)
% %     apssiz2(i)=scdp(apssiz1(i),rho);
% % end
% % siz=[insiz(1:smpsidx(end)),apssiz2(1:end)];

switch CalcType
case 'AngMieSca'
    for j=1:length(sizdist(:,1))
        for i=1:length(wavelen)
            for k=1:length(sizdist(1,:))
                if isnan(sizdist(j,k)) | SpecResp(i) == 0
                    Kernel(i,k)=0;
                else
                    Kernel(i,k)=SpecResp(i)*sizdist(j,k)*...
                        MieAngFun(1,nc,kc,wavelen(i)/1000,siz(k),la,ua,1)...   %%% Changed for Number distributions (#/m^3) dn/dlogDp
                        *siz(k)^2*pi/4*1e-12;  
                end
            end
        end
        if sum(Kernel)==0
            B(j)=0;
        elseif length(wavelen)==1
            B(j)=trapz(log10(siz),Kernel);
        else
            B(j)=trapz(log10(siz),trapz(wavelen, Kernel));
        end
    end
    
case 'AngCotSca'   
    for j=1:length(sizdist(:,1))
        for i=1:length(wavelen)
            for k=1:length(sizdist(1,:))
                Dp(k)=siz(k);
                Dc(k)=Dp(k)*VolFrac^(1/3);
                if isnan(sizdist(j,k)) | SpecResp(i) == 0
                    Kernel(i,k)=0;
                else
                    Kernel(i,k)=SpecResp(i)*sizdist(j,k)*...
                        CotAngFun(1,nc,kc,ns,ks,wavelen(i)/1000,Dc(k),Dp(k),la,ua,1)...  %%%% These are volume distributions
                        *1/siz(k)*10^12*(3/2);
                end
            end
        end
        if sum(Kernel)==0
            B(j)=0;
        else
            B(j)=trapz(log10(siz),trapz(wavelen, Kernel));
        end
        clear Dp Dc
    end
    
case 'AngCotAbs'
    for k=1:length(sizdist(:,1))
        for i=1:length(sizdist(1,:))
            if isnan(sizdist(k,i)) 
                Kernel(i)=0;
            else
                Dp(i)=siz(i);
                Dc(i)=Dp(i)*VolFrac^(1/3);
                Qabs(i)=QabsCot(1,1.7,0.5,1.33,0,0.532,Dc(i),Dp(i));   %%%% These are volume distributions
                Kernel(i)=Qabs(i)*sizdist(k,i)*1/siz(i)*10^12*(3/2);
            end
        end
        B(k)=trapz(log10(siz),Kernel);
    end
end

