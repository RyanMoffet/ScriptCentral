% %%% Re-analyze Scattering data after finding that calibration based on hits
% %%% is more correct than a calibration based on all scatters. 
% 
% %%% Initialize key variables and size calibration parameters...
% load C:\yaada\user\LightScattering\Calcofi\scripts\cal051117 class
% load C:\yaada\user\LightScattering\Calcofi\scripts\cal051117 FineDualMatch_RG_PID FineDualMatch_RG_WM
% NewCalParams=[20.9063038,-0.11243757113,2.071067196E-4,-1.30493278E-7,250,550];
% ChangeDa(NewCalParams);
% TulSlp = [2.65e-011,6.192e-12];
% TulInt = [0,0]


%%% Deal with MS Chemical Composition Data
% % subplot_art2aMilagro(1, 100, FineDualMatch_RG_PID{1}, FineDualMatch_RG_PID, FineDualMatch_RG_WM, [0 250],...
% %     '08-Nov-2004 07:00:00', '19-Nov-2004 08:00:00','CalCOFI')
    %%% Plot WMs in IGOR for paper.
% ClAvPos = FineDualMatch_RG_WM(1:75,1:350);
% ClAvNeg = FineDualMatch_RG_WM(1:75,351:end);
% ExportAvgMsIgor(ClAvPos,ClAvNeg,'C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\','AvgMS')




% %%% getting scattering columns for all particle classes (raw art2a
% %%% results)
% 
% for i = 1:100
%     [ScattRaw{i}(:,1),ScattRaw{i}(:,2),ScattRaw{i}(:,3),ScattRaw{i}(:,4)] = get_column(FineDualMatch_RG_PID{i},...
%         'Time','Da','Saarea','Sbarea');
% end
% 
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% for i = 1:98
%     ScattPDat{i}(:,1) = ScattRaw{i}(:,1);
%     ScattPDat{i}(:,2) = ScattRaw{i}(:,2);
%     for k = 1:2
%         ScattPDat{i}(:,k+2) = TransformPulses(ScattRaw{i}(:,k+2),...
%             TulSlp(k),TulInt(k));
%     end
% end
% 
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 

% hold off,
% plot(ScattPDat{6}(:,2),ScattPDat{6}(:,3),'b.','MarkerSize',2),hold on,
% plot(ScattPDat{40}(:,2),ScattPDat{40}(:,3),'r.','MarkerSize',5),
% xlabel('D_{a} (\mum)','FontSize',32)
% ylabel('R (cm^{2}/particles','FontSize',32)
% set(gca,'FontSize',24)
% set(gcf,'PaperPosition',[1,2.5,4,3])
% xlim([0.1,2])
% hold off,
% CompScatt(ScattPDat{1}(:,2),ScattPDat{1}(:,4),AllCalEC(:,1),AllCalEC(:,2),...
%     {'8a','8b'},0)
% PhdCompare(ScattPDat{1}(:,3),ScattPDat{1}(:,2),ScattPDat{7}(:,3),ScattPDat{7}(:,2),...
%     [0.55,0.65],20,{'Cluster39','err','Cluster6','err'},0.6e-8)



% for i = 3%1:40
%     [ScattTULOutA{i}]=TULMatrixDat(ScattPDat{i}(:,2),ScattPDat{i}(:,3),[0.1,3.5],0.05,20);
% %     [ScattTulDatB{i}]=TULMatrixDat(ScattPDat{i}(:,2),ScattPDat{i}(:,4),[0.1,3.5],0.05,20);
% end
% CompScatt(ScattTulDatB{8}(:,1),ScattTulDatB{8}(:,2),ScattTULOutA{8}(:,1),ScattTULOutA{8}(:,2),...
%     {'8b','8a'},0)

% [Scattnkr,Scattsq_err,ScattTh,Scattr2]=ParamFit1(ScattTULOutA{1},0.6,1.5,[1.33,1.45,0,0,0.7,2.15],2,2);
% PlotRawThAB(ScattPDat{3}(:,2),ScattPDat{3}(:,4),ScattTulDatB{3}(:,1),ScattTulDatB{3}(:,2),Scattnkr(3),[Scattnkr(1),0]);
% PlotMeasThCot(ScattPDat{39}(:,[2,4]),1.70,1.85,0.71,1.43,0,0.1,0.3,0,1.5)

%%% Overview figures
%%% _______________________________________________________________________
%%% _______________________________________________________________________
% PlotRawThProc(ScattTh,ScattPDat{1}(:,[2,4]),ScattTULOut{1},Scattnkr(3),Scattnkr(1))
% PlotRawThProc(ScattPDat{3}(:,[2,3]),ScattTULOutA{3},Scattnkr(3),Scattnkr(1))
% PlotMultMeasThRaw(ScattPDat{1}(:,[2,3]),[1.45,0,1.5],1.5,[1.35,0])
 PlotMultThMeas(ScattPDat{1}(:,[2,3]),ScattTULOutA{1},Scattnkr,[1.35,0,1.1],[1.36,0,1.2],[1.37,0,1.3],[1.38,0,1.4])
% Scattnkr(3),Scattnkr(1)
%%%


% 
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% for i = 1:97
%     PlotRawThAB(ScattPDat{i}(:,2),ScattPDat{i}(:,4),ScattPDat{i}(:,2),ScattPDat{i}(:,3),1.84,[1.44,0],[1.4,0]);
%     title(sprintf('CALCOFI A2AClass %g',i))
%     FileName = sprintf('ScattA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% 
% [ScattTULOut]=ABProcErr(ScattTulDatA,ScattTulDatB);
% 
% figure,PlotRawTh(ScattTULOut(:,1),ScattTULOut(:,2),1.2,[1.33,0])

% [Scattnkr,Scattsq_err,ScattTh,Scattr2]=ParamFit1(ScattTULOut,0.1,1.3,[1.33,1.55,0,0,0.7,2.2],2,2);
% PlotMeasTh(ScattTULOut(1:32,:),Scattr2,ScattTh,Scattnkr,'CalCOFI Scatt')
% PlotRawThProc(ScattTh,[ScattPDat(:,2),ScattPDat(:,3)],ScattTULOut,Scattnkr(3),1.49)
% PlotMultMeasTh(ScattTULOut(1:32,:),Scattnkr,1,[1.33,0])


%%%% Combine All EC for coated spheres plot.

% AllCalEC = [ScattPDat{39}(:,[2,4]);
%     ScattPDat{11}(:,[2,4]);
%     ScattPDat{8}(:,[2,4]);
%     ScattPDat{7}(:,[2,4]);
%     ScattPDat{6}(:,[2,4])];
% PlotMeasThCot(AllCalEC,1.7,1.85,0.71,1.43,0,0.1,0.3,0,3,1)

% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat

%%%% Analyze EC particles

% [AllECPhdDatB] = CompAmbPslPhdMultSiz(AllCalEC,Sizes,20,PslPhdDatB)
% [AllSSPhdDatB] = CompAmbPslPhdMultSiz(ScattPDat{1}(:,[2,4]),Sizes,20,PslPhdDatB)
% [AllSSPhdDatB] = CompAmbPslPhdMultSiz(ScattPDat{1}(:,[2,4]),Sizes,20,PslPhdDatB)

% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat

%% Size Distributions

% SizBin = logspace(-1,log10(3),50);
% figure,
% colors={'k.-','g.-','b.-','c.-','m.-','y.-','r.-'};
% eclegend = {'C6','C7','C8','C11','C39'};
% count=1;
% for i=[6,7,8,11,39]
%     [histout]=hist(ScattPDat{i}(:,2),SizBin);
%     [dndd]=givedndd(SizBin,histout,'number',1)
%     semilogx(SizBin,dndd,colors{count},'MarkerSize',15,'LineWidth',2),hold on,
%     count=count+1;
% end
% ylabel('dN/dlog10D_{a}','FontSize',24)
% xlabel('D_{a} (\mum)','FontSize',24)
% legend(eclegend)
% hold off


%%% Load APS and SMPS distributions from
%%% C:\yaada...\Calcofi\scripts\Neph\MakeIntegrationMatrix.m
% clear  totvoldist totalsiz
% load C:\yaada\user\LightScattering\Calcofi\scripts\Neph\LumpWorkup.mat APSSize APSConc smpssiz chrsmps thrsmps
% 
% % % [apsvoldist]=givedndd(APSSize,(APSConc'/5000),'dVdlogDp from dN',1);
% % % [smpsvoldist]=givedndd(smpssiz/1000,(chrsmps'),'dVdlogDp from dN',1);
% % % totvoldist=[smpsvoldist,apsvoldist(:,3:end)];
% 
% [apsnumdist]=givedndd(APSSize,(APSConc'/5000),'dNdlogDp from dN',1);
% [smpsnumdist]=givedndd(smpssiz/1000,(chrsmps'/1.5),'dNdlogDp from dN',1);
% totnumdist=[smpsnumdist,apsnumdist(:,3:end)];


% totalsiz=[smpssiz/1000,APSSize(3:end)];
% 
% semilogx(totalsiz,nanmean(totvoldist(stidx:spidx,:)))
% semilogx(totalsiz,totnumdist(210:230,:))
% 
% stidx = find(thrsmps > datenum('08-Nov-2004 11:00:00') & thrsmps < datenum('08-Nov-2004 12:00:00'))
% spidx = find(thrsmps > datenum('19-Nov-2004 7:00:00') & thrsmps < datenum('19-Nov-2004 8:00:00'))
% % % % [sqerr,finalpar]=LogNFit([totalsiz',nanmean(totvoldist(stidx:spidx,:))'],[-1,1,.1,2,35,20],'bimodal');
% 
% [sqerrNum,finalparNum]=LogNFit([totalsiz',nanmean(totnumdist(stidx:spidx,:))'],[-1,1,.1,2,35,20],'monomod');
% 
% ApsSmpsNumDist=LogNFuncGen(totalsiz,finalparNum,'monomod');
% 
% figure,
% semilogx(totalsiz,ApsSmpsNumDist),hold on,
% semilogx(totalsiz,nanmean(totnumdist(stidx:spidx,:)),'bx'),hold off,
% 
% 

% start=datenum('08-Nov-2004 07:00:00')-datenum(0,0,0,8,0,0);
% stop=datenum('19-Nov-2004 08:00:00')-datenum(0,0,0,8,0,0);
% 
% hitpid = run_query(sprintf('Time = [%s %s] and Hit == 1',start,stop));
% [hitsiz] = get_column(hitpid,'Da');
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% [hithist]=hist(hitsiz,totalsiz);
% [hitdndd]=givedndd(totalsiz,hithist,'dNdlogDp from dN',1);
% semilogx(totalsiz,hithist),hold on,
% semilogx(totalsiz,ApsSmpsDist,'bx')
% 
% satofms = ApsSmpsDist'./(hitdndd);
% figure,
% loglog(totalsiz,satofms);
% 
% figure,
% colors={'k.-','g.-','b.-','c.-','m.-','y.-','r.-'};
% eclegend = {'C6','C7','C8','C11','C39'};
% count=1;
% for i=[6,7,8,11,39]
%     [histout{i}]=hist(ScattPDat{i}(:,2),totalsiz);
%     [dndd]=(givedndd(totalsiz,histout{i},'dNdlogDp from dN',1).*satofms);
%     semilogx(totalsiz,dndd.*totalsiz.^3,colors{count},'MarkerSize',15,'LineWidth',2),hold on,
%     count=count+1;
% end
% ylabel('dM/dlog10D_{a}','FontSize',24)
% xlabel('D_{a} (\mum)','FontSize',24)
% legend(eclegend)
% hold off
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat

% PlotSSASize_MultSamp(0.2,[0.1,2],1.80,0.71,[1.43,1.49,1.43],[0,0,0],100,{'SOARII','MILAGRO','CalCOFI'})

% PlotSSASize_MultCor([0.1,0.2,0.3],[0.1,2],1.80,0.71,1.43,0,100,...
%     {'D_{core} = 0.1 \mum','D_{core} = 0.2 \mum','D_{core} = 0.3 \mum'})


% SootSearch{1}=run_query('Area{18} > 100'); % NH4
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{2}=run_query('Area{-46} > 100 or Area{-62} > 100'); %NO2
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{3}=run_query('Area{-97} > 100 or Area{-80} > 100'); %HSO4
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{4}=run_query('Area{-89} > 100'); %COOHCOO
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{5}=run_query('Area{43} > 100'); %C2H3O
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{6}=run_query('Area{23} > 100'); %% Na
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearch{7}=run_query('Area{39} > 100'); %% K
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% 
% SootSearchString={'NH4' 'NO_' 'SO_' 'C2O4H' 'C2H3O' 'Na' 'K'};

% counter = 1;
% for i = [6,7,8,11,39]
%     CompPid{counter}=FineDualMatch_RG_PID{i};
%     counter=counter+1;
% end
% ECclassstr = {'ECShortNoNeg' 'ECShortNitrate' 'ECOCK' 'ECKOC' 'ECFresh'}
% MixComparisonAbs = compare_secs(CompPid,SootSearch, ECclassstr, SootSearchString);
% ComparePlot(MixComparisonAbs,SootSearchString,ECclassstr)
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\ScattReAnalyze.mat
% [rho]=RetreiveDo(ScattTULOut{4},0.1,1,7,'LongEC',[1.85,0.71],[1.45,0]);
% CalCOFIEeMix=MixComparisonAbs;
% save C:\yaada\user\LightScattering\Calcofi\results\ScatteringReAnalysis\CalCOFIEcMix.mat CalCOFIEeMix

% for i = [6,7,8,11,39]
%     length(FineDualMatch_RG_PID{i})
% end

%%% Try Separating on RH


% load C:\yaada\user\LightScattering\Calcofi\scripts\Neph\LumpWorkup.mat neph

% plot(neph(:,1),neph(:,end))
% datetick('x','yy/mm/dd','keepticks')