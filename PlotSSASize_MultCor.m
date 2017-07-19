function PlotSSASize_MultCor(CoreSize,Range,nc,kc,nm,km,npts,legendstr)

Dp=10.^(linspace(log10(Range(1)),log10(Range(2)),npts));
% Dp=linspace(Range(1),Range(2),npts);
figure,
% clrstr = {'r.-','g.-','k.-','c.-','m.-'};
LineType={'k-','k--','k:','k-.'};

for j = 1:length(CoreSize)
    for i=1:length(Dp)
        if Dp(i)<CoreSize(j)
            qsca(i)=NaN;qext(i)=NaN;%%[qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nc,kc,Dp(i),Dp(i));
        else
            [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nm,km,CoreSize(j),Dp(i));
        end
    end
    SSA=qsca./qext;
    semilogx(Dp,SSA,LineType{j},'LineWidth',3),hold on,
    
end


xlabel('D_{p} (\mum)');
ylabel('SSA');
set(gca,'XLim',[0.1,2]);
set(gca,'XTickLabel',{'0.1','','','','','','','','','1'});

legend(legendstr);