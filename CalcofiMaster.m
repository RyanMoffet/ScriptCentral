% % Ryan M's Calcofi Master Script.
% -2.310e-007*X^3+3.212e-004*X^2-1.552e-001*X+2.619e+001
% NewCalParams=[2.619e+001,-1.552e-001,3.212e-004,-2.310e-007,275,480];
% ChangeDa(NewCalParams);


% % These are the scattering calibration parameters
% SaaSlope=8.891e-011;
% SaaInt=-1.606e-009;
% SbaSlope=2.993e-011;
% SbaInt=-2.117e-009;
% 

% % Process the scattering data from Manuels Art2a run...wetss=class5
% [a2aC5a_Out,a2aC5a_Raw]=ProcScattDat(FineDualMatch_RG_PID{5},SaaSlope,SaaInt...
%     ,'saarea',[.25 2.7],.05)
% [a2aC5b_Out,a2aC5b_Raw]=ProcScattDat(FineDualMatch_RG_PID{5},SbaSlope,SbaInt...
%     ,'sbarea',[.25 2.7],.05)

% % Process the scattering data from Manuels Art2a run...dryss=class1
% [a2aC1a_Out,a2aC1a_Raw]=ProcScattDat(FineDualMatch_RG_PID{1},SaaSlope,SaaInt...
%     ,'saarea',[.25 2.7],.05)
% [a2aC1b_Out,a2aC1b_Raw]=ProcScattDat(FineDualMatch_RG_PID{1},SbaSlope,SbaInt...
%     ,'sbarea',[.25 2.7],.05)

% % Process the scattering data from Manuels Art2a run...wetss=class5
% [a2aC6a_Out,a2aC6a_Raw]=ProcScattDat(FineDualMatch_RG_PID{6},SaaSlope,SaaInt...
%     ,'saarea',[.25 2.7],.05)
% [a2aC6b_Out,a2aC6b_Raw]=ProcScattDat(FineDualMatch_RG_PID{6},SbaSlope,SbaInt...
%     ,'sbarea',[.25 2.7],.05)
% 
% save calcofi_workspace.mat

% for i=1:10
%     [a2aOutA{i},a2aRawA{i}]=ProcScattDat(FineDualMatch_RG_PID{i},SaaSlope,SaaInt...
%         ,'saarea',[.1 3],.05)
%     title(sprintf('CALCOFI Cluster %g PMT A Scattering',i))
%     FileName = sprintf('ScattA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     [a2aOutB{i},a2aRawB{i}]=ProcScattDat(FineDualMatch_RG_PID{i},SaaSlope,SaaInt...
%         ,'sbarea',[.1 3],.05)
%     title(sprintf('CALCOFI Cluster %g PMT B Scattering',i))
%     FileName = sprintf('ScattB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% save calcofi_workspace.mat
% 
% clear i 

% for i=1:24
%     [CalcRiSiA{i},CalcRhoSiA{i},CalcSqErrSiA{i},CalcTDatSiA{i},CalcR2SiA{i}] = ParamFit(a2aOutA{i},.1,3,[1.4,1.5],1); % Fit the experimental cross sections to theory
%     [CalcRiSiB{i},CalcRhoSiB{i},CalcSqErrSiB{i},CalcTDatSiB{i},CalcR2SiB{i}] = ParamFit(a2aOutB{i},.1,3,[1.4,1.5],1); % Fit the experimental cross sections to theory
% end
% save calcofi_workspace.mat
% for i=1:24
%     [CalcRiDuA{i},CalcRhoDuA{i},CalcSqErrDuA{i},CalcTDatDuA{i},CalcR2DuA{i}] = ParamFit(a2aOutA{i},.1,3,[1.4,1.5],2); % Fit the experimental cross sections to theory
%     [CalcRiDuB{i},CalcRhoDuB{i},CalcSqErrDuB{i},CalcTDatDuB{i},CalcR2DuB{i}] = ParamFit(a2aOutB{i},.1,3,[1.4,1.5],2); % Fit the experimental cross sections to theory
% end
% save calcofi_workspace.mat

% ------------ Process Data Using Upper Limit Script -----------------

% [DosMajResA,DosMajResARaw]=ProcConsUL(Dos,CalTulSlpe(2),CalTulInt(2),'saarea',[.2 1.55],8,100);
% [DosMajResB,DosMajResBRaw]=ProcConsUL(Dos,CalTulSlpe(4),CalTulInt(4),'sbarea',[.2 1.55],8,100);

% Aslpe=2.648*10^-11;
% Bslpe=6.191*10^-12;
% 
% for i=11:24
%     [a2aTulOutA{i},a2aTulRawA{i}]=ProcConsUL(FineDualMatch_RG_PID{i},Aslpe,0,...
%         'saarea',[.1 3],8,100)
%     title(sprintf('CALCOFI Cluster %g PMT A Scattering',i))
%     FileName = sprintf('ScattA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     [a2aTulOutB{i},a2aTulRawB{i}]=ProcConsUL(FineDualMatch_RG_PID{i},Bslpe,0,...
%         'sbarea',[.1 3],8,100)
%     title(sprintf('CALCOFI Cluster %g PMT B Scattering',i))
%     FileName = sprintf('ScattB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% save CalA2aTul.mat
% 
% for i=11:24
%     [CalcTulRiDuA{i},CalcTulRhoDuA{i},CalcTulSqErrDuA{i},CalcTulTDatDuA{i},CalcTulR2DuA{i}] = ParamFit(a2aTulOutA{i},.1,3,[1.4,1.5],2); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     [CalcTulRiDuB{i},CalcTulRhoDuB{i},CalcTulSqErrDuB{i},CalcTulTDatDuB{i},CalcTulR2DuB{i}] = ParamFit(a2aTulOutB{i},.1,3,[1.4,1.5],2); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
% end
% save CalA2aTul.mat

% for i=15:24
%     PlotRawThProc(CalcTulTDatDuA{i},a2aTulRawA{i},a2aTulOutA{i},CalcTulRhoDuA{i},CalcTulRiDuA{i})
%     title(sprintf('CALCOFI Cluster %g PMT A Scattering',i))
%     FileName = sprintf('RawThProc_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
% %     close
%     
%     PlotRawThProc(CalcTulTDatDuB{i},a2aTulRawB{i},a2aTulOutB{i},CalcTulRhoDuB{i},CalcTulRiDuB{i})
%     title(sprintf('CALCOFI Cluster %g PMT B Scattering',i))
%     FileName = sprintf('RawThProcB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
% %     close    
% end

% **************** Export temporals *******************************
% tic
% ClusterTempPlot('02-Nov-2004 00:00:00', '20-Nov-2004 00:00:00', 60, 'ClusterTemps1_24',FineDualMatch_RG_PID,24)
% toc

% QCString={'hits' 'misses'};
% QCPid{1} = run_query('InstCode == ELD and hit == 1 and Time = [2-Nov-2004T0:00:00 20-Nov-2004T0:0:00]');
% QCPid{2} = run_query('InstCode == ELD and hit == 0 and Time = [2-Nov-2004T0:00:00 20-Nov-2004T0:0:00]');
% ClusterTempPlot('02-Nov-2004 00:00:00', '20-Nov-2004 00:00:00', 60,'HitsAndMissesTemp' ...
%     ,QCPid,2);



% Try edge finder with a constant number of particles in each bin

% for i=1:20
%     [a2aTulOutA{i},a2aTulRawA{i}]=TraceUpperLimit(FineDualMatch_RG_PID{i},Aslpe,0,'saarea',[.3 3],0.04,25);
%     title(sprintf('CALCOFI Cluster %g PMT A Scattering',i))
%     FileName = sprintf('CtulA_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
%     
%     [a2aTulOutB{i},a2aTulRawB{i}]=TraceUpperLimit(FineDualMatch_RG_PID{i},Bslpe,0,'sbarea',[.3 3],0.04,25);
%     title(sprintf('CALCOFI Cluster %g PMT B Scattering',i))
%     FileName = sprintf('CtulB_C%g.fig',i); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end
% save CalA2aTul.mat
% 
% *********************Working on Absorption******************************
% tic
% AbsClasses=[6,7,8,11,13,15,18,20,21,23];
% InitalGusses(1,:)=[1.6,1.5,1.5,1.48,1.48,1.48,1.48,1.53,1.48,1.45];
% InitalGusses(2,:)=[1.7,1.6,1.6,1.35,1.35,1.35,1.35,2.6,1.35,1.55];
% InitalGusses(3,:)=[0.5,0.05,.05,0.015,0.015,0.015,0.015,0.01,0.015,0.001];
% idx=1;
% for i=AbsClasses
%     [CalcTulParamsA{i},CalcTulSqErrDuA{i},CalcTulTDatDuA{i},CalcTulR2DuA{i}] = ParamFit(a2aTulOutA{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],3); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     [CalcTulParamsB{i},CalcTulSqErrDuB{i},CalcTulTDatDuB{i},CalcTulR2DuB{i}] = ParamFit(a2aTulOutB{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],3); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     idx=idx+1;
% end
% clear idx
% toc

% Keep density constant and find n and k
% Try now for the upper bounds in density 
% tic
% AbsClasses=[6,7,8,11,13,15,18,20,21,23];
% InitalGusses(1,:)=[1.5,1.5,1.5,1.48,1.48,1.48,1.48,1.53,1.48,1.45]; % n
% InitalGusses(2,:)=[1.7,1.7,1.7,1.7,1.7,2.6,1.7,2.6,2.6,1.55];% rho
% InitalGusses(3,:)=[0.5,0.05,.05,0.015,0.015,0.015,0.015,0.01,0.015,0.001];%k 
% idx=1;
% for i=AbsClasses
%     [CalcTulParamsAUp{i},CalcTulSqErrDuAUp{i},CalcTulTDatDuAUp{i},CalcTulR2DuAUp{i}] = ParamFit(a2aTulOutA{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],4); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     [CalcTulParamsBUp{i},CalcTulSqErrDuBUp{i},CalcTulTDatDuBUp{i},CalcTulR2DuBUp{i}] = ParamFit(a2aTulOutB{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],4); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     idx=idx+1;
% end
% clear idx
% 
% 
% % Now for the lower bounds in effective density
% InitalGusses(1,:)=[1.5,1.5,1.5,1.48,1.48,1.48,1.48,1.53,1.48,1.45]; % n
% InitalGusses(2,:)=[0.77,0.77,0.77,0.77,0.77,1.0,0.77,1.38,1.0,1.0];% rho
% InitalGusses(3,:)=[0.5,0.05,.05,0.015,0.015,0.015,0.015,0.01,0.015,0.001];%k 
% idx=1;
% for i=AbsClasses
%     [CalcTulParamsALo{i},CalcTulSqErrDuALo{i},CalcTulTDatDuALo{i},CalcTulR2DuALo{i}] = ParamFit(a2aTulOutA{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],4); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     [CalcTulParamsBLo{i},CalcTulSqErrDuBLo{i},CalcTulTDatDuBLo{i},CalcTulR2DuBLo{i}] = ParamFit(a2aTulOutB{i},.1,3,[InitalGusses(1,idx),InitalGusses(2,idx),InitalGusses(3,idx)],4); % Fit the experimental cross sections to theory
%     save CalA2aTul.mat
%     idx=idx+1;
% end
% clear idx
% toc


% for i=AbsClasses
%      ParamTable(i,1)=i;
%     for j=2:4
%         ParamTable(i,j)=CalcTulParamsB{i}(1,j-1);
%     end
%     ParamTable(i,5)=CalcTulR2DuB{i}(1,2);
% end
% ParamTable
% 
% ** Testing Constrained Least Squares **

%  UpBd=[1.7,.5];LoBd=[1.4,0];
% % 
%  [nkDens,TDat,r2]=ConParamFit(a2aTulOutA{7},.1,3,[1.25,0.77,0.125],LoBd,UpBd,4)

%[TomCompPar,TomCompErr,TomCompTDat,TomCompR2] = ParamFit(a2aTulOutA{7},.1,3,[1.5,0.77,0.05],4);

% % ** Benchmarking Compiled MieFunction **
% tic
% [BMSiz,BMResp]=ATOFMSScattFunGen(.1,3,500,.532,1.55,0);
% toc
% tic
% [BMSiz1,BMResp1]=ThDatGen(.1,3,500,.532,1.55,0);
% toc

% [ExpErrC7krho] = exploreError(a2aTulOutA{7},[1.55,0,0.77],[1.55,.6,2],.532,3);
% [rx,ry,rz]=experr(a2aTulOutA{7},[1.33,0,.77],[2,.6,.77],.532,1)
% save CalA2aTul.mat
[nx,ny,nz]=experr(a2aTulOutA{7},[1.55,0,.77],[1.55,.6,2],.532,2)
save CalA2aTul.mat
% [kx,ky,kz]=experr(a2aTulOutA{7},[1.33,0,.77],[2,0,2],.532,3)
% save CalA2aTul.mat
