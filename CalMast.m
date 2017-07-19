% % Ryan M's Calcofi Master Script.
% % -2.310e-007*X^3+3.212e-004*X^2-1.552e-001*X+2.619e+001
% NewCalParams=[20.371,-0.10954,2.016E-4,-1.2681E-7,250,550];
% NewCalParams=[26.18768,-0.15515588,3.2115626E-4,-2.310467E-7,250,550];
% ChangeDa(NewCalParams);
% % 
% % 
% These are the scattering calibration parameters
% SaaSlope=8.9e-011;
% SaaInt=-1.4e-9;
% SbaSlope=3.2e-011;
% SbaInt=-2.2e-9;
% 
% WMLook(1,200,FineDualMatch_RG_WM,FineDualMatch_RG_PID,100,[1 250],'C:\yaada\user\LightScattering\Calcofi\results\ManuelArt2a\ClusterFigs','WMCalcofi');
% % This groups clusters according to the discussion with manuel and from his
% % script bind_calcofi_2.m
clear class
class{1}=FineDualMatch_RG_PID{1}; % mixed_ss
for I = [3,12,14,26];
    class{1} = union(FineDualMatch_RG_PID{I},class{1});
end
class{2}=union(FineDualMatch_RG_PID {2},FineDualMatch_RG_PID {17}); % pure_ss. changed 14 and 17 
class{3}=FineDualMatch_RG_PID{51};% pure_ss_51
class{4}=FineDualMatch_RG_PID{55};% pure_ss_55
class{5}=FineDualMatch_RG_PID{5};% pos_ss
class{6}=FineDualMatch_RG_PID{16}; % mg/ss/ca
class{7}=FineDualMatch_RG_PID{24};%NaK
class{8}=FineDualMatch_RG_PID{9} % dust_Ca
for I = [32,33,56,109,139];
    class{8} = union(FineDualMatch_RG_PID{I},class{8});
end
class{9}=FineDualMatch_RG_PID{20} % dust_Si
for I = [76,53,54,64,77];
    class{9} = union(FineDualMatch_RG_PID{I},class{9});
end
class{10}=FineDualMatch_RG_PID{47}; % dust_Fe
class{11}=FineDualMatch_RG_PID{36} % S_rich
for I = [44,157,165];
    class{11} = union(FineDualMatch_RG_PID{I},class{11});
end
class{12}=union(FineDualMatch_RG_PID {19},FineDualMatch_RG_PID {35});% Mg_rich
class{13}=FineDualMatch_RG_PID {41};% MgCl
class{14}=FineDualMatch_RG_PID {45};%MgNOx
class{15}=FineDualMatch_RG_PID{81}; % V_rich
for I = [117,128,124];
    class{15} = union(FineDualMatch_RG_PID{I},class{15});
end
class{16}=FineDualMatch_RG_PID{97};%V_97
class{17}=union(FineDualMatch_RG_PID{6},FineDualMatch_RG_PID{7},FineDualMatch_RG_PID{37});%C_fresh
class{18}=FineDualMatch_RG_PID{8}; % C_mix removed class 21
class{19}=union(FineDualMatch_RG_PID{11},FineDualMatch_RG_PID {27},FineDualMatch_RG_PID{48});% ECSOx
class{20}=union(FineDualMatch_RG_PID{18},FineDualMatch_RG_PID{21}); % CK added class21
class{21}=union(FineDualMatch_RG_PID{15},FineDualMatch_RG_PID{28})% k_only
class{22}=union(FineDualMatch_RG_PID {13},FineDualMatch_RG_PID {38});% CKSOx
class{23}=FineDualMatch_RG_PID{23} % C_ox added 29
for I = [31,34,29];
    class{23} = union(FineDualMatch_RG_PID{I},class{23});
end
class{24}=FineDualMatch_RG_PID {52};% C_52
class{25}=FineDualMatch_RG_PID{39} % EC
for I = [40,105,107,114];
    class{25} = union(FineDualMatch_RG_PID{I},class{25});
end
save cal051117.mat
% _______________________________________________________________________________________________________________________________
% This processes the scattering data
% clstr={'mixed ss' 'pure ss' 'pure ss 51' 'pure ss 55' 'pos ss' 'aged ss' 'NaK' 'dust Ca'...
%         'dust Si' 'dust Fe' 'S rich' 'Mg rich' 'MgCl' 'MgNOx' 'V rich' 'V 97' 'C fresh'...
%         'C mix' 'ECSOx' 'CK' 'k only' 'CKSOx' 'C ox' 'C 52' 'EC'};
% jobcount=1
% for i=1:length(class)
%     [a2aOutA{i},a2aRawA{i}]=ProcScattDat(class{i},SaaSlope,SaaInt...
%         ,'saarea',[.1 3],.05)
%     title(sprintf('CALCOFI Class %g, %s PMT A',i,clstr{i}))
%     FileName = sprintf('ScattA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     [a2aOutB{i},a2aRawB{i}]=ProcScattDat(class{i},SbaSlope,SbaInt...
%         ,'sbarea',[.1 3],.05)
%     title(sprintf('CALCOFI Class %g, %s PMT B',i,clstr{i}))
%     FileName = sprintf('ScattB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     save cal051117.mat
%     jobcount=jobcount+1
% end
% ____________________________________________________________________________________________________________________________________
% clear i 
% jobcount1=1
% for i=1:length(class)
%     [CalcRiSiA{i},CalcSqErrSiA{i},CalcTDatSiA{i},CalcR2SiA{i}] = ParamFit1(a2aOutA{i},.1,3,[1.4,0,1.5],0); % Fit the experimental cross sections to theory
%     [CalcRiSiB{i},CalcSqErrSiB{i},CalcTDatSiB{i},CalcR2SiB{i}] = ParamFit1(a2aOutB{i},.1,3,[1.4,0,1.5],0); % Fit the experimental cross sections to theory
%     jobcount1=jobcount1+1
% end
% save cal051117.mat
% jobcount2=1
% for i=1:length(class)
%     [CalcRiDuA{i},CalcSqErrDuA{i},CalcTDatDuA{i},CalcR2DuA{i}] = ParamFit1(a2aOutA{i},.1,3,[1.4,0,1.5],2); % Fit the experimental cross sections to theory
%     [CalcRiDuB{i},CalcSqErrDuB{i},CalcTDatDuB{i},CalcR2DuB{i}] = ParamFit1(a2aOutB{i},.1,3,[1.4,0,1.5],2); % Fit the experimental cross sections to theory
%     jobcount2=jobcount2+1
% end
% save cal051117.mat
% 
% jobcount2=1
% for i=1:length(class)
%     [CalcRiTrA{i},CalcSqErrTrA{i},CalcTDatTrA{i},CalcR2TrA{i}] = ParamFit1(a2aOutA{i},.1,3,[1.4,0.01,1.5],3); % Fit the experimental cross sections to theory
%     [CalcRiTrB{i},CalcSqErrTrB{i},CalcTDatTrB{i},CalcR2TrB{i}] = ParamFit1(a2aOutB{i},.1,3,[1.4,0.01,1.5],3); % Fit the experimental cross sections to theory
%     jobcount2=jobcount2+1
%     save cal051117.mat
% end
% 
% partab(clstr,a2aOutA,CalcRiTrA,CalcRiTrB,CalcR2TrA,CalcR2TrB,'nrkAB',3)
% partab(clstr,a2aOutA,CalcRiDuA,CalcRiDuB,CalcR2DuA,CalcR2DuB,'nrAB',2)
% partab(clstr,a2aOutA,CalcRiSiA,CalcRiSiB,CalcR2SiA,CalcR2SiB,'nAB',1)

% ______________________________________________________________________________________________________________________________________________________________
% % Now try getting rid of the notch
% 
% notchvec=[1 5 7 8 17 18 19 20 22 23 25];
% for i=1:length(notchvec)
%     clstrmn{i}=clstr{notchvec(i)};
% end
% range{1}=[.1,1.7;1.9,3];
% range{5}=[.1,1.7;1.9,3];
% range{7}=[.1,1.7;1.96,3];
% range{8}=[.1,1.7;1.91,3];
% range{17}=[.1,1.7];
% range{18}=[.1,1.7];
% range{19}=[.1,1.7;1.9,3];
% range{20}=[.1,1.7];
% range{22}=[.1,1.7];
% range{23}=[.1,1.7];
% range{25}=[.1,1.7];
% 
% 
% jobcount=1
% for i=notchvec
%     [a2aOutAmn{jobcount},a2aRawAmn{jobcount}]=ProcMsb(class{i},SaaSlope,SaaInt...
%         ,'saarea',range{i},.05)
%     title(sprintf('CALCOFI Class %g, %s PMT A',i,clstr{i}))
%     FileName = sprintf('mnScattA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     [a2aOutBmn{jobcount},a2aRawBmn{jobcount}]=ProcMsb(class{i},SbaSlope,SbaInt...
%         ,'sbarea',range{i},.05)
%     title(sprintf('CALCOFI Class %g, %s PMT B',i,clstr{i}))
%     FileName = sprintf('mnScattB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     save cal051117.mat
%     jobcount=jobcount+1
% end
% 
% clear i 
% jobcount1=1
% for i=1:length(a2aOutBmn)
%     [CalcRiSiAmn{i},CalcSqErrSiAmn{i},CalcTDatSiAmn{i},CalcR2SiAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,[1.4,0,1.0],0,1); % Fit the experimental cross sections to theory
%     [CalcRiSiBmn{i},CalcSqErrSiBmn{i},CalcTDatSiBmn{i},CalcR2SiBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,[1.4,0,1.0],0,1); % Fit the experimental cross sections to theory
%     jobcount1=jobcount1+1
% end
% save cal051116.mat
% jobcount2=1
% for i=1:length(a2aOutBmn)
%     [CalcRiDuAmn{i},CalcSqErrDuAmn{i},CalcTDatDuAmn{i},CalcR2DuAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,[1.4,0,1.5],2); % Fit the experimental cross sections to theory
%     [CalcRiDuBmn{i},CalcSqErrDuBmn{i},CalcTDatDuBmn{i},CalcR2DuBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,[1.4,0,1.5],2); % Fit the experimental cross sections to theory
%     jobcount2=jobcount2+1
% end
% save cal051117.mat
% 
% jobcount3=1
% for i=1:length(a2aOutBmn)
%     [CalcRiTrAmn{i},CalcSqErrTrAmn{i},CalcTDatTrAmn{i},CalcR2TrAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,[1.4,0.01,1.5],3); % Fit the experimental cross sections to theory
%     [CalcRiTrBmn{i},CalcSqErrTrBmn{i},CalcTDatTrBmn{i},CalcR2TrBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,[1.4,0.01,1.5],3); % Fit the experimental cross sections to theory
%     jobcount3=jobcount3+1
%     save cal051117.mat
% end
% 
% partab(clstrmn,a2aOutAmn,CalcRiTrAmn,CalcRiTrBmn,CalcR2TrAmn,CalcR2TrBmn,'nrkABmn',3)
% partab(clstrmn,a2aOutAmn,CalcRiDuAmn,CalcRiDuBmn,CalcR2DuAmn,CalcR2DuBmn,'nrABmn',2)
% partab(clstrmn,a2aOutAmn,CalcRiSiAmn,CalcRiSiBmn,CalcSqErrSiAmn,CalcSqErrSiBmn,'nABmn',1)
% for i=1:length(CalcRiTrAmn)
%     PlotMeasTh(a2aOutAmn{i},CalcR2SiAmn{i},CalcTDatSiAmn{i},CalcRiSiAmn{i},clstrmn{i});
%     FileName = sprintf('SimnMeasThA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     PlotMeasTh(a2aOutBmn{i},CalcR2SiBmn{i},CalcTDatSiBmn{i},CalcRiSiBmn{i},clstrmn{i});
%     FileName = sprintf('SimnMeasThB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end


% % Now constrain fits
% 
% 
% ConstrainedParameters{1}=[1.33,1.53,0,1E-8,.99,2.17];%mixed_ss
% ConstrainedParameters{2}=[1.33,1.53,0,1E-8,.99,2.17];%pure ss
% ConstrainedParameters{3}=[1.33,1.53,0,1E-8,.99,2.17];%pure ss 51
% ConstrainedParameters{4}=[1.33,1.53,0,1E-8,.99,2.17];%pure ss 55
% ConstrainedParameters{5}=[1.33,1.53,0,1E-3,.99,2.17];%pos ss
% ConstrainedParameters{6}=[1.33,1.53,0,1E-8,.99,2.17];%aged ss
% ConstrainedParameters{7}=[1.33,1.53,0,1E-8,.99,2.17];%NaK
% ConstrainedParameters{8}=[1.33,2.17,0,0.001,.99,2.17];%dust Ca
% ConstrainedParameters{9}=[1.33,2.00,0,0.0015,1.0,2.6];%dust Si
% ConstrainedParameters{10}=[1.33,2.00,0,0.01,1.0,2.6];%dust Fe
% ConstrainedParameters{11}=[1.33,1.45,0,0.01,.99,2.17];%S rich
% ConstrainedParameters{12}=[1.33,1.45,0,0.01,.99,2.17];%Mg rich
% ConstrainedParameters{13}=[1.33,1.45,0,0.01,.99,2.17];%MgCl
% ConstrainedParameters{14}=[1.33,1.45,0,0.01,.99,2.17];%MgNOx
% ConstrainedParameters{15}=[1.33,1.45,0,0.01,.9,1.55];%V rich
% ConstrainedParameters{16}=[1.33,1.45,0,0.01,.9,1.55];%V 97
% ConstrainedParameters{17}=[1.33,1.45,0,0.01,0.9,1.7];%C fresh
% ConstrainedParameters{18}=[1.33,1.45,0,0.01,0.9,1.7];%C mix
% ConstrainedParameters{19}=[1.33,1.45,0,0.01,0.9,1.4];%ECSOx
% ConstrainedParameters{20}=[1.33,1.45,0,0.01,0.9,1.4];%CK
% ConstrainedParameters{21}=[1.33,1.45,0,0.01,0.9,1.4];%k only
% ConstrainedParameters{22}=[1.33,1.45,0,0.01,0.9,1.55];%CKSOx
% ConstrainedParameters{23}=[1.33,1.45,0,0.01,0.9,1.7];%C ox
% ConstrainedParameters{24}=[1.33,1.45,0,0.01,0.9,1.55];%C 52
% ConstrainedParameters{25}=[1.33,1.45,0,0.01,0.9,1.7];%EC
% 
% 
% jobcount2=1
% for i=1:length(class)
%     [CalcRiDuA{i},CalcSqErrDuA{i},CalcTDatDuA{i},CalcR2DuA{i}] = ParamFit1(a2aOutA{i},.1,3,ConstrainedParameters{i},2,2); % Fit the experimental cross sections to theory
%     [CalcRiDuB{i},CalcSqErrDuB{i},CalcTDatDuB{i},CalcR2DuB{i}] = ParamFit1(a2aOutB{i},.1,3,ConstrainedParameters{i},2,2); % Fit the experimental cross sections to theory
%     jobcount2=jobcount2+1
% end
% save cal051117.mat
% 
% jobcount3=1
% for i=1:length(class)
%     [CalcRiTrA{i},CalcSqErrTrA{i},CalcTDatTrA{i},CalcR2TrA{i}] = ParamFit1(a2aOutA{i},.1,3,ConstrainedParameters{i},3,2); % Fit the experimental cross sections to theory
%     [CalcRiTrB{i},CalcSqErrTrB{i},CalcTDatTrB{i},CalcR2TrB{i}] = ParamFit1(a2aOutB{i},.1,3,ConstrainedParameters{i},3,2); % Fit the experimental cross sections to theory
%     jobcount3=jobcount3+1
%     save cal051117.mat
% end
% 
% partab(clstr,a2aOutA,CalcRiTrA,CalcRiTrB,CalcSqErrTrA,CalcSqErrTrB,'nrkAB',3)
% partab(clstr,a2aOutA,CalcRiDuA,CalcRiDuB,CalcSqErrDuA,CalcSqErrDuB,'nrAB',2)
% % 
% % % do constrained fits w/o notch.
% 
% jobcount2=1
% for i=1:length(a2aOutBmn)
%     [CalcRiDuAmn{i},CalcSqErrDuAmn{i},CalcTDatDuAmn{i},CalcR2DuAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,ConstrainedParameters{notchvec(i)},2,2); % Fit the experimental cross sections to theory
%     [CalcRiDuBmn{i},CalcSqErrDuBmn{i},CalcTDatDuBmn{i},CalcR2DuBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,ConstrainedParameters{notchvec(i)},2,2); % Fit the experimental cross sections to theory
%     jobcount2=jobcount2+1
%     save cal051117.mat
% end
% 
% jobcount3=1
% for i=1:length(a2aOutBmn)
%     [CalcRiTrAmn{i},CalcSqErrTrAmn{i},CalcTDatTrAmn{i},CalcR2TrAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,ConstrainedParameters{notchvec(i)},3,2); % Fit the experimental cross sections to theory
%     [CalcRiTrBmn{i},CalcSqErrTrBmn{i},CalcTDatTrBmn{i},CalcR2TrBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,ConstrainedParameters{notchvec(i)},3,2); % Fit the experimental cross sections to theory
%     jobcount3=jobcount3+1
%     save cal051117.mat
% end
% 
% partab(clstrmn,a2aOutAmn,CalcRiTrAmn,CalcRiTrBmn,CalcSqErrTrAmn,CalcSqErrTrBmn,'nrkABmn',3)
% partab(clstrmn,a2aOutAmn,CalcRiDuAmn,CalcRiDuBmn,CalcSqErrDuAmn,CalcSqErrDuBmn,'nrABmn',2)
% for i=1:length(CalcTDatTrAmn)
%     PlotMeasTh(a2aOutAmn{i},CalcR2TrAmn{i},CalcTDatTrAmn{i},CalcRiTrAmn{i},clstrmn{i});
%     FileName = sprintf('mnMeasThA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     PlotMeasTh(a2aOutBmn{i},CalcR2TrBmn{i},CalcTDatTrBmn{i},CalcRiTrBmn{i},clstrmn{i});
%     FileName = sprintf('mnMeasThB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% for i=1:length(CalcRiTrA)
%     PlotMeasTh(a2aOutA{i},CalcR2TrA{i},CalcTDatTrA{i},CalcRiTrA{i},clstr{i});
%     FileName = sprintf('MeasThA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     PlotMeasTh(a2aOutB{i},CalcR2TrB{i},CalcTDatTrB{i},CalcRiTrB{i},clstr{i});
%     FileName = sprintf('MeasThB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% for i=1:length(CalcTDatTrAmn)
%     PlotMeasTh(a2aOutAmn{i},CalcR2DuAmn{i},CalcTDatDuAmn{i},CalcRiDuAmn{i},clstrmn{i});
%     FileName = sprintf('DumnMeasThA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     PlotMeasTh(a2aOutBmn{i},CalcR2DuBmn{i},CalcTDatDuBmn{i},CalcRiDuBmn{i},clstrmn{i});
%     FileName = sprintf('DumnMeasThB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end

% PhdGenerator
% save cal051127.mat

% % now try constraining density to the values obtained on 11/22
% 
% densvecA=[1,1,1,1,1.28,1.21,0.90,1.19,1.22,1.28,1.39];
% densvecB=[1,1,1,1,0.99,1.04,1.03,1.24,1.22,0.90,1.33];
% 
% for i=5:length(a2aOutBmn)
%     [CDRiAmn{i},CalcSqErrCDAmn{i},CalcTDatCDAmn{i},CalcR2CDAmn{i}] = ParamFit1(a2aOutAmn{i},.1,3,[1.4,1.6,0,0.5,densvecA(i)],4,2); % Fit the experimental cross sections to theory
%     [CDRiBmn{i},CalcSqErrCDBmn{i},CalcTDatCDBmn{i},CalcR2CDBmn{i}] = ParamFit1(a2aOutBmn{i},.1,3,[1.4,1.6,0,0.5,densvecB(i)],4,2); % Fit the experimental cross sections to theory
%     jobcount3=jobcount3+1
%     save cal051122.mat
% end
% partab(clstrmn,a2aOutAmn,CDRiAmn,CDRiBmn,CalcSqErrCDAmn,CalcSqErrCDBmn,'CDABmn',3)
% for i=1:length(CalcTDatTrAmn)
%     if isempty(CDRiAmn{i})
%         continue
%     end
%     PlotMeasTh(a2aOutAmn{i},CalcR2CDAmn{i},CalcTDatCDAmn{i},CDRiAmn{i},clstrmn{i});
%     FileName = sprintf('CDmnMeasThA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     PlotMeasTh(a2aOutBmn{i},CalcR2DuBmn{i},CalcTDatCDBmn{i},CDRiBmn{i},clstrmn{i});
%     FileName = sprintf('CDmnMeasThB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end

% PlotMultMeasTh({a2aOutA{notchvec(4)}},{[1.33,.005,1.1858]},{1.42})

% % function CompareWithTheory(procin,retrivedpars,tstdens,varargin)

% CompareWithTheory(a2aOutAmn{5},CalcRiTrAmn{5},[CalcRiTrAmn{5}(1,3)],[1.33,0],[1.33,0.001],[1.33,0.01],[1.33,0.1])
