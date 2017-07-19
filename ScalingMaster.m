%% Scaling Master
% ApportScattMaster

%% Define start, stop hit, miss etc____________________________________________________________
%% 
% start=datenum('08-Nov-2004 07:00:00')-datenum(0,0,0,8,0,0);
% stop=datenum('19-Nov-2004 08:00:00')-datenum(0,0,0,8,0,0);
% res=datenum('1:00:00');
% nbin=(stop-start)/res;
% % 
% hit=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 1',start,stop));
% miss=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 0',start,stop));
% total=run_query(sprintf('InstCode == ELD and Time = [%f %f]',start,stop));
% hittimes=get_column(hit,'Time');
% misstimes=get_column(miss,'Time');

%%Workup size distributions_____________________________________________________________________

% totnumdist=[chrsmps'/1.5,APSConc(3:end,:)'/5000]; 
% totalsiz=[smpssiz/1000,APSSize(3:end)];
% totaldndd=givedndd(totalsiz,totnumdist,'volume',1);
% semilogx(totalsiz,totaldndd(150,:),'b.-',totalsiz,totvoldist(150,:),'g+')
% figure,plotapstemps(thrsmps,totalsiz,totvoldist')


%% Run Scaling and Scale counts________________________________________________________________
% 
% [sout1,HR_dat,NMissT,NMissR]=Satofms(hit,miss,start,stop...
%     ,SizTiGmt,totalsiz,totnumdist');
% save LumpWorkup.mat
% clear lumpconcs
% [lumpconcs]=ScaleCounts(lumptype,NMissR,start,stop,res,sout1,totalsiz)
% save LumpWorkup.mat
% 
% 
%% Fit scaled distributions to Lognormals_________________________________________________________
% 
% 
% for i=1:length(lumpconcs)
%     for j=1:length(lumpconcs{i}(:,1))
%         lumpvoldist{i}(j,:)=givedndd(totalsiz,lumpconcs{i}(j,:),'volume',1);
%     end
% end
% save LumpWorkup.mat
% 
% 
% 
% meanvoldist=nanmean(lumpvoldist);
% 
% semilogx(totalsiz,lumpvoldist{3}(165,:),'b.-',totalsiz,totvoldist(:,265)','r.-')
% 
% [err,crappar]=LogNFit([totalsiz',meanvoldist'],[-1.9,1,.2,.2,0.3e-11,0.4e-11],'bimodal');
% crapx=[totalsiz(1):0.01:totalsiz(end)];
% crapy=LogNFuncGen(crapx,crappar);
% figure,semilogx(totalsiz',meanvoldist,'b.',crapx,crapy,'b-')
% 
% 
%   
% 
% [err,crappar]=LogNFit([totalsiz',totaldndd(150,:)'],[-1.9,1,.2,.2,0.4e-11,1e-11],'bimodal');
% crapx=[totalsiz(1):0.01:totalsiz(end)];
% crapy=LogNFuncGen(crapx,crappar);
% figure,semilogx(totalsiz',lumpvoldist(2,:)','b.',crapx,crapy,'b-')
% figure,semilogx(totalsiz',totaldndd(150,:)','b.',crapx,crapy,'b-')
% 
% %% Integrate distributions to find bsca and babs____________________________________________________
% 
% 
% %%% For comparison to Neph:
% 
% %% Sea Salt
% [truncbsca1{1}]=BscaAngInt(lumpvoldist{1},totalsiz,wave,resp,1.34,0,0,0,0,'AngMieSca');
% [totbsca1{1}]=BscaAngInt(lumpvoldist{1},totalsiz,wave,resp,1.34,0,0,0,0,'TotMieSca');
% 
% save LumpWorkup.mat
% %% Dust
% [truncbsca1{2}]=BscaAngInt(lumpvoldist{2},totalsiz,wave,resp,1.37,0,0,0,0,'AngMieSca');
% [totbsca1{2}]=BscaAngInt(lumpvoldist{2},totalsiz,wave,resp,1.37,0,0,0,0,'AngMieSca');
% 
% save LumpWorkup.mat
% %% Carbon
% [truncbsca1{2}]=BscaAngInt(lumpvoldist{3},totalsiz,wave,resp,1.36,0,0,0,0,'AngMieSca');
% [totbsca1{2}]=BscaAngInt(lumpvoldist{3},totalsiz,wave,resp,1.37,0,0,0,0,'AngMieSca');
% 
% save LumpWorkup.mat
% %% EC
% [truncbsca1{4}]=BscaAngInt(lumpvoldist{4},totalsiz,wave,resp,1.7,0.5,1.33,0,0.05,'AngCotSca');
% [totbsca1{4}]=BscaAngInt(lumpvoldist{4},totalsiz,wave,resp,1.7,0.5,1.33,0,0.05,'AngCotSca');
% 
% 
% [CalcBabs1]=BscaAngInt(lumpvoldist{3},totalsiz,wave,resp,1.7,0.5,1.33,0,0.05,'AngCotAbs');
% save LumpWorkup.mat
% 
% MakeIntegrationMatrix
% save LumpWorkup.mat
% 
% CompareBscat(totbsca1,truncbsca1,thrsmps,avneph',thrsmps,{'SeaSalt','Dust','Carbon'})
% 
% figure,plot(thrsmps,CalcBabs,bapav(:,1),bapav(:,2)*10e6)
% 
% figure,plot(CalcBabs,bapav(:,2)*10e6,'r.')
% 
% CompareTemporals(thrsmps,CalcBabs,bapav(:,1),bapav(:,2)*10e6,'atofms','aeth')
% 
% 
%%  New Approach: take and scale down SMPS and APS Distributions__________________________________________________

[ScDnClDists,SmClDists,SmClSiz]=ClassFracDist(lumpconcs,totnumdist,totalsiz);
for i=1:length(ScDnClDists)
    for j=1:length(ScDnClDists{i}(:,1))
        ScDnVolClDists{i}(j,:)=givedndd(totalsiz,ScDnClDists{i}(j,:),'volume',1);
        SmClVolDists{i}(j,:)=givedndd(SmClSiz{i},SmClDists{i}(j,:),'volume',1);
    end
end

clear SparseBins SparseVolDists
for i=1:length(SmClVolDists)
    for j=1:length(SmClVolDists{i}(:,1))
        SparseVolDists{i}(j,:)=SmClVolDists{i}(j,30:2:end);
        if j==1
            SparseBins{i}(1,:)=SmClSiz{i}(30:2:end);
        end
    end
end
sample=3;
time=261;
figure,semilogx(totalsiz,ScDnVolClDists{sample}(time,:),'b.-',totalsiz,totvoldist(time,:)','r.-')
figure,semilogx(SparseBins{1},SparseVolDists{sample}(time,:),'b.-',totalsiz,totvoldist(time,:)','r.-')
figure,semilogx(totalsiz,lumpvoldist{sample}(time,:),'b.-',totalsiz,totvoldist(time,:)','r.-')

truncwave=wave(1:10:end);
truncresp=resp(1:10:end);

plot(wave,resp,'b-',truncwave,truncresp,'r.-')

%% Sea Salt
[truncbsca2{1}]=BscaAngInt(SparseVolDists{1},SparseBins{1},truncwave,truncresp,1.34,0,0,0,0,1.25,APSSize(3),'AngMieSca');
[totbsca2{1}]=BscaAngInt(SparseVolDists{1},SparseBins{1},truncwave,truncresp,1.34,0,0,0,0,1.25,APSSize(3),'TotMieSca');
save LumpWorkup.mat
%% Dust
[truncbsca2{2}]=BscaAngInt(SparseVolDists{2},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,1.25,APSSize(3),'AngMieSca');
[totbsca2{2}]=BscaAngInt(SparseVolDists{2},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,1.25,APSSize(3),'TotMieSca');

save LumpWorkup.mat
%% Carbon
[truncbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,1.25,APSSize(3),'AngMieSca');
[totbsca2{3}]=BscaAngInt(SparseVolDists{3},SparseBins{1},truncwave,truncresp,1.37,0,0,0,0,1.25,APSSize(3),'TotMieSca');

save LumpWorkup.mat

%% EC
[truncbsca2{4}]=BscaAngInt(SparseVolDists{4},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,0.9,APSSize(3),'AngCotSca');
[totbsca2{4}]=BscaAngInt(SparseVolDists{4},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,0.9,APSSize(3),'TotCotSca');
save LumpWorkup.mat

[CalcBabs2]=BscaAngInt(SparseVolDists{4},SparseBins{1},truncwave,truncresp,1.7,0.5,1.33,0,0.05,0.9,APSSize(3),'AngCotAbs');
save LumpWorkup.mat

[CorrectedNeph,TotalScatt]=CompareBscat(totbsca2,truncbsca2,thrsmps,avneph',thrsmps,{'SeaSalt','Dust','Carbon','EC','neph'});
CompareTemporals(thrsmps,TotalScatt,thrsmps,CorrectedNeph,'atofms','neph')

% figure,plot(thrsmps,CalcBabs2,bapav(:,1),bapav(:,2)*1e6)
% 
% figure,plot(CalcBabs2,bapav(:,2)*1e6,'r.')

CompareTemporals(thrsmps,CalcBabs2,bapav(:,1),bapav(:,2)*1e6,'atofms','aeth')


% for j=1:length(totvoldist(1,:))
%     SparseVolDist(:,j)=totvoldist(30:2:end,j);
%     if j==1
%         SparseTotBin=totalsiz(30:2:end);
%     end
% end
% figure,semilogx(totalsiz,totvoldist(:,200),'b.-',SparseTotBin,SparseVolDist(:,200),'r.-')


% clear trunctest tottest
% [trunctest{1}]=BscaAngInt(SparseVolDist',SparseTotBin,truncwave,truncresp2,1.33,0,0,0,0,'AngMieSca');
% save LumpWorkup.mat
% [tottest{1}]=BscaAngInt(SparseVolDist',SparseTotBin,truncwave,truncresp2,1.33,0,0,0,0,'TotMieSca');
% save LumpWorkup.mat

% %% This plots truncation error
% Terr1=(trunctest{1}./tottest{1}-1)*100;
% figure,plot(thrsmps,Terr1)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% %% This plots the correlation between measured and corrected bsca
% nephcorr1=avneph'.*(tottest{1}./trunctest{1});
% figure,plot(nephcorr1,tottest{1},'.',xydat,xydat,'k-')
% figure,plot(thrsmps,nephcorr1,'b.-',thrsmps,tottest{1},'g.-')


%% Plots__________________________________________________________________________________________________

% %% Fig 1a: Raw SS Scattering
% PlotRaw(lumptype{1},[0.1,3],'saarea')

% %% Fig 1b: Raw Carbon Scattering
% PlotRaw(lumptype{3},[0.1,1.7],'saarea')

% %% Fig 2a: Best fit and proc for SS
% PlotABErrComp(LumpProcA{1},LumpProcB{1},1,[LumpER{1}(1),LumpER{1}(2),0,0,LumpER{1}(3)])

% %% Fig 2b: Best fit and proc for Carbon
% PlotABErrComp(LumpProcA{3},LumpProcB{3},2,[1.7,0.5,1.33,0,LumpER{3}(2)],LumpER{3}(1),2)

%% This plots the correlation between measured and corrected bsca
% CompareBscat(totbsca2,truncbsca2,thrsmps,avneph',thrsmps,{'SeaSalt','Dust','Carbon'})
% 
% CompareTemporals(thrsmps,CalcBabs2,bapav(:,1),bapav(:,2)*1e6,'atofms','aeth')


%% This plots the correlation between measured and corrected bsca
% nephcorr1=avneph'.*(tottest{1}./trunctest{1});
% figure,plot(nephcorr1,tottest{1},'.',xydat,xydat,'k-')
% figure,plot(thrsmps,nephcorr1,'b.-',thrsmps,tottest{1},'g.-')
% figure,plot(thrsmps,nephcorr1'./(nephcorr1'+bapav(:,2)*1e6),'b.-')
