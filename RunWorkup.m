%% Apportionment of Scattering and Absorption

%% Classes: SS, Dust, C, Misses...Need to find a way to not deal with overwhelming amount of misses
%% Need to break up misses temporally.

% %% pid for missed partices is called miss (go figure)
% 
% start=datenum('08-Nov-2004 07:00:00')-datenum(0,0,0,8,0,0);
% stop=datenum('08-Nov-2004 11:00:00')-datenum(0,0,0,8,0,0);
% stop=datenum('19-Nov-2004 08:00:00')-datenum(0,0,0,8,0,0);
% res=datenum('4:00:00');
% nbin=(stop-start)/res;
% 
% startt=start;
% stopt=start+res;
% for i=1:length(nbin)
%     TempMiss{i}=run_query(sprintf('InstCode == ELD and Time = [%f %f]',startt,stopt));
%     [ProcTMissA{i},RawTMissA{i}]=ProcMsb(TempMiss{i},SaaSlope,SaaInt...
%         ,'saarea',[0.1,1.7;1.9,2.5],.05); 
%     [ProcTMissB{i},RawTMissB{i}]=ProcMsb(TempMiss{i},SbaSlope,SbaInt...
%         ,'sbarea',[0.1,1.7;1.9,2.5],.05);   
%     [ABProc{i}]=ABProcErr(ProcTMissA{i},ProcTMissB{i});
%     [SSAB{i}]=ABProcErr(a2aOutAmn{1},a2aOutBmn{1});
%     errorbar(ABProc{i}(:,1),ABProc{i}(:,2),ABProc{i}(:,3)),hold on,
%     errorbar(SSAB{i}(:,1),SSAB{i}(:,2),SSAB{i}(:,3),'r-');
%     startt=stopt;
%     stopt=stopt+res;
% end
% 
% [SSAB{i}]=ABProcErr(a2aOutAmn{1},a2aOutBmn{1});


% %_____________________________________________________________________________________________________
% %________________________ This shows that that hits have more scattered intensity _____________________
% [SSAB{i}]=ABProcErr(a2aOutAmn{1},a2aOutBmn{1});
% [CrapER{i},CrapSqErr{i},CrapTD{i},r2]=ParamFit1(SSAB{i},0.1,1.5,[1.33,1.4,0,0.001,0.7,1.5],3)
% [CrapER{i},CrapSqErr{i},CrapTD{i}]=CoatParamFit1(SSAB{i},0.1,1.5,[1.7,0.5,1.33,0,0.5,1],0)


% figure,errorbar(corrsiz(:),ABProc{i}(:,2),ABProc{i}(:,3)),hold on,
% errorbar(SSAB{1}(:,1),SSAB{1}(:,2),SSAB{1}(:,3),'r-')
%     figure,plot(CrapTD{i}(:,1),CrapTD{i}(:,2)),hold on,...
%         errorbar(ABProc{i}(:,1),ABProc{i}(:,2),ABProc{i}(:,3))



%%_____________________________________________________________________________________________

%% Need to work up lumped classes: SS, Dust, Carbon and Misses.
%% "class{:}" is taken from Calcofi\scripts\CalMast.m

clear lumptype
lumptype{1}=class{1} % SeaSalt
for I = [2,3,4,5,6,12,13,14,7,11];
    lumptype{1} = union(class{I},lumptype{1});
end

lumptype{2}=class{8} % Dust
for I = [9,10,21];
    lumptype{2} = union(class{I},lumptype{2});
end

lumptype{3}=class{22} % Carbon
for I = [20,17,18,19,25,23,24,15,16];
    lumptype{3} = union(class{I},lumptype{3});
end

lumptype{4}=class{17} % EC + "Secondaries"
for I = [19,22,25];
    lumptype{3} = union(class{I},lumptype{3});
end

lumptype{5}=miss;

range{1}=[.1,1.7;1.96,3];
range{2}=[.1,1.7;1.96,3];
range{3}=[.1,1.7];
range{4}=[.1,1.7];

lumpstr={'Sea Salt','Dust','Carbon'};
for i=1:length(lumpstr)
    [LumpProcA{i},LumpRawA{i}]=ProcMsb(lumptype{i},SaaSlope,SaaInt...
         ,'saarea',range{i},.05)
    title(sprintf('CALCOFI lumptype %g, %s PMT A',i,lumpstr{i}))
    FileName = sprintf('ScattA_Lump%g.fig',i); % Names the file (differently) for each cluster
    saveas (gcf,FileName, 'fig');
    close
    
    [LumpProcB{i},LumpRawB{i}]=ProcMsb(lumptype{i},SbaSlope,SbaInt...
         ,'sbarea',range{i},.05)
    title(sprintf('CALCOFI lumptype %g, %s PMT B',i,lumpstr{i}))
    FileName = sprintf('ScattA_Lump%g.fig',i); % Names the file (differently) for each cluster
    saveas (gcf,FileName, 'fig');
    close
    save LumpWorkup.mat
    [LumpProcAB]=ABProcErr(LumpProcA{i},LumpProcB{i})
    jobcount=jobcount+1
end





