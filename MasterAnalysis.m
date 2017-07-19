% %% Debugging Script
% 
% %% Size distributions________________________________________________________
% 
% save MasterAnalysis.mat
% 
% [apsvoldist]=givedndd(APSSize,APSConc'/5000,'volume',1);
% [smpsvoldist]=givedndd(smpssiz/1000,chrsmps','volume',1);
% 
% totvoldist=[smpsvoldist,apsvoldist(:,3:end)];
% totalsiz=[smpssiz/1000,APSSize(3:end)]
% figure,semilogx(totalsiz,totvoldist(200,:))
% clear j SparseVolDist SparseTotBin wave resp truncwave trunc resp
% for j=1:length(totvoldist(:,1))
%     SparseVolDist(j,:)=totvoldist(j,30:2:end);
%     if j==1
%         SparseTotBin=totalsiz(30:2:end);
%     end
% end
% % figure,semilogx(totalsiz,totvoldist(:,200),'b.-',SparseTotBin,SparseVolDist(:,200),'r.-')
% 
% %% Response______________________________________________________________________
% 
% wave=linspace(450,600,300);
% 
% for i=1:length(wave)
%     resp(i)=radres(wave(i));
% end
% 
% resp=resp/(sum(resp)*mean(diff(wave)));
% 
% truncwave=wave(1:10:end);
% truncresp=resp(1:10:end);
% 
% %% Integrate______________________________________________________________________
% 
% 
% 
% clear trunctest tottest
% [truncsiz{1}]=BscaAngInt(SparseVolDist,SparseTotBin,truncwave,truncresp,1.33,0,0,0,0,'AngMieSca');
% save MasterAnalysis.mat
% [totsiz{1}]=BscaAngInt(SparseVolDist,SparseTotBin,truncwave,truncresp,1.33,0,0,0,0,'TotMieSca');
% save MasterAnalysis.mat
% 
% tic
% %% Sea Salt
% [truncbsca2{1}]=BscaAngInt(SparseVolDists{1},SparseBins{1},truncwave,truncresp,1.34,0,0,0,0,'AngMieSca');
% [totbsca2{1}]=BscaAngInt(SparseVolDists{1},SparseBins{1},truncwave,truncresp,1.34,0,0,0,0,'TotMieSca');
% toc
% save MasterAnalysis.mat
% %% Dust
% [truncbsca2{2}]=BscaAngInt(SparseVolDists{2},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,'AngMieSca');
% [totbsca2{2}]=BscaAngInt(SparseVolDists{2},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,'TotMieSca');
% 
% save MasterAnalysis.mat
% %% Carbon
% [truncbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,'AngCotSca');
% [totbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,'TotCotSca');
% save LumpWorkup.mat

% [CalcBabs2]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,'AngCotAbs');
% save MasterAnalysis.mat

% 
% %% Plot______________________________________________________________________________

datstr={'11/08/04','11/09/04','11/10/04','11/11/04',...
        '11/12/04','11/13/04','11/14/04','11/15/04','11/16/04','11/17/04',...
        '11/18/04','11/19/04'};


%% This plots truncation error
Terr1=(truncsiz{1}./totsiz{1}-1)*100;
figure,plot(thrsmps,Terr1)
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')
%% This plots the correlation between measured and corrected bsca
nephcorr1=avneph'.*(totsiz{1}./truncsiz{1});
% figure,plot(nephcorr1,tottest{1},'.',xydat,xydat,'k-')
figure,plot(hrneph,nephcorr1,'b.-',thrsmps,totsiz{1},'g.-')
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')
figure,plot(nephcorr1,totsiz{1},'b.')


CompareBscat(totbsca2,truncbsca2,thrsmps,avneph',thrsmps,{'SeaSalt','Dust','Carbon'})

figure,plot(thrsmps,CalcBabs2,bapav(:,1),bapav(:,2)*10e6)

figure,plot(CalcBabs2,bapav(:,2)*10e6,'r.')

CompareTemporals(thrsmps,CalcBabs2,bapav(:,1),bapav(:,2)*10e6,'atofms','aeth')





























% [dbtrunctest{1}]=BscaAngInt(totvoldist(245,:),totalsiz,wave,resp,1.33,0,0,0,0,'AngMieSca');
% 
% [dbtottest{1}]=BscaAngInt(totvoldist(245,:),totalsiz,wave,resp,1.33,0,0,0,0,'TotMieSca');
% 
% [truncbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.33,0,0,0,0,'AngCotSca');
% [totbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.33,0,0,0,0,'TotCotSca');


% for k=245%1:length(thrsmps)
%     for i=1:length(wave)
%         for j=1:length(totalsiz)
%             if isnan(totvoldist(k,1))
%                 dbrintmat(i,j)=0;
%             else
%                 dbrintmat(i,j)=resp2(i)*totvoldist(k,j)*...
%                     tstbh(1,1.33,0,wave(i)/1000,totalsiz(j))...  %% did i see a matrix being formed initally?
%                     *1/totalsiz(j)*10^12*(3/2);  
%             end
%         end
%     end
%     dbbsca(k)=trapz(log10(totalsiz),trapz(wave,dbrintmat));
%     clear dbrintmat
% end
% 
% % figure,plot(thrsmps,dbbsca)
% save LumpWorkup.mat

%% Now do the same integration, except taking into account the angular range of the nephelometer
% 
% for k=245%1:length(thrsmps)
%     for i=1:length(wave)
%         for j=1:length(totalsiz)
%             if isnan(totvoldist(k,j)) | resp(i) == 0
%                 dbrintmat(i,j)=0;
%             else
%                 dbrintmat(i,j)=resp(i)*totvoldist(k,j)*...
%                     MieAngFun(1,1.33,0,wave(i)/1000,totalsiz(j),10,170,1)...  %% did i see a matrix being formed initally?
%                     *1/totalsiz(j)*10^12*(3/2);  
%             end
%         end
%     end
%     dbtruncbsca(k)=trapz(log10(totalsiz),trapz(wave,dbrintmat));
%     clear dbrintmat
% end
% 
