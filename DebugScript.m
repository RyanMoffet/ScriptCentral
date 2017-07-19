%% Debugging Script

%% Size distributions________________________________________________________

% save Debug.mat
% 
% [apsvoldist]=givedndd(APSSize,APSConc'/5000,'volume',1);
% [smpsvoldist]=givedndd(smpssiz/1000,chrsmps'/1.5,'volume',1);
% 
% totvoldist=[smpsvoldist,apsvoldist(:,3:end)];
% totalsiz=[smpssiz/1000,APSSize(3:end)]
% figure,semilogx(totalsiz,totvoldist(250,:))
% clear j SparseVolDist SparseTotBin wave resp truncwave trunc resp
% for j=1:length(totvoldist(:,1))
%     SparseVolDist(j,:)=totvoldist(j,30:2:end);
%     if j==1
%         SparseTotBin=totalsiz(30:2:end);
%     end
% end
% figure,semilogx(totalsiz,totvoldist(:,200),'b.-',SparseTotBin,SparseVolDist(:,200),'r.-')

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
% [trunctest{1}]=BscaAngInt(SparseVolDist,SparseTotBin,truncwave,truncresp,1.33,0,0,0,0,'AngMieSca');
% save Debug.mat
% [tottest{1}]=BscaAngInt(SparseVolDist,SparseTotBin,truncwave,truncresp,1.33,0,0,0,0,'TotMieSca');
% save Debug.mat
% 
% %% Plot______________________________________________________________________________
% 
datstr={'11/08/04','11/09/04','11/10/04','11/11/04',...
        '11/12/04','11/13/04','11/14/04','11/15/04','11/16/04','11/17/04',...
        '11/18/04','11/19/04'};


%% This plots truncation error
Terr1=(trunctest{1}./tottest{1}-1)*100;
figure,plot(thrsmps,Terr1)
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')
%% This plots the correlation between measured and corrected bsca
nephcorr1=(avneph'.*(tottest{1}./trunctest{1}))/0.3;
% figure,plot(nephcorr1,tottest{1},'.',xydat,xydat,'k-')
figure,plot(hrneph,nephcorr1,'b.-',thrsmps,trunctest{1},'g.-')
set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')
figure,plot(nephcorr1,tottest{1},'b.')

%% Try with raw number conc using a sum________________________________________________________


% [apsvoldist]=givedndd(APSSize,APSConc'/5000,'volume',1);
% [smpsvoldist]=givedndd(smpssiz/1000,chrsmps','volume',1);

% TotNumDist=[chrsmps/1.5;APSConc(3:end,:)/1000]'
% totalsiz=[smpssiz/1000,APSSize(3:end)]
% for j=1:length(TotNumDist(:,1))
%     SparseDist(j,:)=TotNumDist(j,30:2:end);
%     if j==1
%         SparseTotBin=totalsiz(30:2:end);
%     end
% end
% figure,semilogx(totalsiz,TotNumDist(32,:),'b.-',SparseTotBin,SparseDist(32,:),'r.-')



% % clear trunctest tottest
% 
% [rawtrunctest{1}]=BscaAngIntNoW(SparseDist,SparseTotBin,1.33,0,0,0,0,'AngMieSca');
% save Debug.mat
% [rawtottest{1}]=BscaAngIntNoW(SparseDist,SparseTotBin,1.33,0,0,0,0,'TotMieSca');
% save Debug.mat
% 
%% This plots truncation error
% Terr1=(rawtrunctest{1}./rawtottest{1}-1)*100;
% figure,plot(thrsmps,Terr1)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% %% This plots the correlation between measured and corrected bsca
% nephcorr1=avneph'.*(rawtottest{1}./rawtrunctest{1});
% % figure,plot(nephcorr1,rawtottest{1},'.',xydat,xydat,'k-')
% figure,plot(hrneph,nephcorr1,'b.-',thrsmps,rawtottest{1}*1e6,'g.-',thrsmps,tottest{1},'r.-')
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% figure,plot(nephcorr1,rawtrunctest{1}*1e6,'b.')

























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
