%% This creates the function R(lambda) the nephelometer spectral response
%% wave is a column vector 
%% resp is a column vector

% wave=linspace(450,600,300);
% 
% for i=1:length(wave)
%     resp(i)=radres(wave(i));
% end
% 
% resp=resp/(sum(resp)*mean(diff(wave)));
% resp2=resp/(sum(resp));
crap=trapz(wave,resp)
% plot(wave,resp,'b.-',wave,resp1,'k.-',wave,resp2,'g.-')

%% Next we want to create the size distribution function N(Dp)
%% totalsiz is a vector containing the size bins (159)
%% totalnumdist is a matrix containing the number concentrations
%%              with the sizes in rows and the times in columns
% 
% [apsvoldist]=givedndd(APSSize,APSConc'/5000,'volume',1);
% [smpsvoldist]=givedndd(smpssiz/1000,chrsmps','volume',1);
% 
% totvoldist=[smpsvoldist1,apsvoldist1(:,3:end)];
% 
% totalsiz=[smpssiz/1000,APSSize(3:end)];

% figure,plotapstemps(thrsmps,totalsiz,totvoldist')
% figure,semilogx(totalsiz,totvoldist(:,250),'b.-',totalsiz,totvoldist1(25,:),'g+')

%% Next we prepare the matrix of the product N(Dp)*R(lam)*Q(lam,Dp,theta) for integration
%% First start out with the total cross section

%% ________________________________________________________________________
%% 
% 
% for k=1:length(thrsmps)
%     for i=1:length(wave)
%         for j=1:length(totalsiz)
%             if isnan(totvoldist(j,timebin))
%                 rintmat(i,j)=0;
%             else
%                 rintmat(i,j)=resp(i)*totvoldist(j,k)*...
%                     tstbh(1,1.33,0,wave(i)/1000,totalsiz(j))...  %% did i see a matrix being formed initally?
%                     *1/totalsiz(j)*10^12*(3/2);  
%             end
%         end
%     end
%     bsca(k)=trapz(log10(totalsiz),trapz(wave,rintmat));
%     clear rintmat
% end
% 
% % figure,plot(thrsmps,bsca)
% save LumpWorkup.mat
% 
% %% Now do the same integration, except taking into account the angular range of the nephelometer
% 
% for k=1:length(thrsmps)
%     for i=1:length(wave)
%         for j=1:length(totalsiz)
%             if isnan(totvoldist(j,timebin)) | resp(i) == 0
%                 rintmat(i,j)=0;
%             else
%                 rintmat(i,j)=resp(i)*totvoldist(j,k)*...
%                     MieAngFun(1,1.33,0,wave(i)/1000,totalsiz(j),10,170,1)...  %% did i see a matrix being formed initally?
%                     *1/totalsiz(j)*10^12*(3/2);  
%             end
%         end
%     end
%     truncbsca(k)=trapz(log10(totalsiz),trapz(wave,rintmat));
%     clear rintmat
% end
% [trunctest{1}]=BscaAngInt(totvoldist,totalsiz,wave,resp,1.33,0,0,0,0,'AngMieSca');
% save LumpWorkup.mat
% [tottest{1}]=BscaAngInt(totvoldist,totalsiz,wave,resp,1.33,0,0,0,0,'TotMieSca');
% save LumpWorkup.mat
% 
%% Making plots of simulated neph data
% datstr={'11/08/04','11/09/04','11/10/04','11/11/04',...
%         '11/12/04','11/13/04','11/14/04','11/15/04','11/16/04','11/17/04',...
%         '11/18/04','11/19/04'};
% 
% %% This plots the calculated total and truncated bsp
% figure,plot(thrsmps,bsca,thrsmps,truncbsca,'r-'),
% legend('calc','calc-truncation',2)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% 
% %% This plots truncation error
% Terr=(truncbsca./bsca-1)*100;
% figure,plot(thrsmps,Terr)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% 
% %% This plots the correlation between measured and uncorrected bsca
% xydat=linspace(min(bsca),max(bsca),100);
% figure,plot(avneph,bsca,'.',xydat,xydat,'k-')
% 
% %% This plots the correlation between measured and corrected bsca
% nephcorr=avneph'.*(bsca./truncbsca);
% figure,plot(nephcorr,bsca,'.',xydat,xydat,'k-')
% figure,plot(thrsmps,nephcorr,'b.-',thrsmps,bsca,'g.-')
% 
% 
% %% First correct the raw data and then plot to check the correction
% [bspctd]=CorrectNephRaw(neph,[bsca./truncbsca]',thrsmps(1),'1:00')
% figure,plot(bspctd(:,1),bspctd(:,2)*1e6,thrsmps,nephcorr,'k-')
% 
% %% Plot the measured vs theoretical scattering
% figure,plot(thrsmps,bsca,bspctd(:,1),bspctd(:,2)*1e6,'r-'),
% legend('calc','measured',2)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% 
% %% Plot bsp and bap
% figure,plot(bspctd(:,1),bspctd(:,2)*1e6,bapav(:,1),bapav(:,2)*1e6,'r-'),
% legend('b_{sp}','b_{ap}',2)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% 
%% ________________________________________________________________________
%% Checking the influence of a spectrum of wavelengths as opposed to just
%% one...it seems to make a large difference in total scattering...
% for i=1:length(wave)
%     for j=1:length(totalsiz)
%         if isnan(totvoldist(j,timebin))
%             rintmat(i,j)=0;
%         else
%             rintmat(i,j)=resp(i)*totvoldist(j,250)*...
%                 tstbh(1,1.33,0,wave(i)/1000,totalsiz(j))...  %% did i see a matrix being formed initally?
%                 *1/totalsiz(j)*10^12*(3/2);  
%         end
%         rintmat1(j)=totvoldist(j,250)*...
%             tstbh(1,1.33,0,540/1000,totalsiz(j))...  %% did i see a matrix being formed initally?
%             *1/totalsiz(j)*10^12*(3/2);  
%     end
% end
% fullspecbsca=trapz(log10(totalsiz),trapz(wave,rintmat));
% singlewlbsca=trapz(log10(totalsiz),rintmat1);
% ratio=fullspecbsca/singlewlbsca
% clear rintmat rintmat1 fullspecbsca singlewlbsca

