function PlotSSASize(CoreSize,Range,nc,kc,nm,km,npts)

Dp=10.^(linspace(log10(Range(1)),log10(Range(2)),npts));
% Dp=linspace(Range(1),Range(2),npts);

for i=1:length(Dp)
    if Dp(i)<CoreSize
        [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nc,kc,Dp(i),Dp(i));
    else
        [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nm,km,CoreSize,Dp(i));
    end
end

SSA=qsca./qext;

figure,
semilogx(Dp,SSA,'b.-'),hold on,

xlabel('D_{p} (\mum)');
ylabel('SSA');

for i=1:length(Dp)
    [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nc,kc,Dp(i),Dp(i));
end

SSA=qsca./qext;

semilogx(Dp,SSA,'k.-'),hold on,

for i = 1:length(Dp)
    if Dp(i)<CoreSize
        [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nc,kc,Dp(i),Dp(i));
    else
        dsh=Dp(i)-CoreSize;
        nvw=nm*(dsh^3/Dp(i)^3)+nc*(CoreSize^3/Dp(i)^3);
        kvw=km*(dsh^3/Dp(i)^3)+kc*(CoreSize^3/Dp(i)^3);
        [qsca(i),qext(i)]=MatBHC(1,0.532,nvw,kvw,nvw,kvw,CoreSize,Dp(i));
    end 
end

SSA=qsca./qext;

semilogx(Dp,SSA,'r.-'),hold on,

[qscaCO,qextCO]=MatBHC(1,0.532,nc,kc,nc,kc,CoreSize,CoreSize);
for i = 1:length(Dp)
    if Dp(i)<CoreSize
        [qsca(i),qext(i)]=MatBHC(1,0.532,nc,kc,nc,kc,Dp(i),Dp(i));
    else
        dsh=Dp(i)-CoreSize;
        [qscaS(i),qextS(i)]=MatBHC(1,0.532,nm,km,nm,km,dsh,dsh);
        qsca(i)=qscaS(i)+qscaCO;
        qext(i)=qextS(i)+qextCO;
    end 
end

SSA=qsca./qext;

semilogx(Dp,SSA,'g.-')

legend('Core-Shell','Pure Soot','Homogenous','External Mixture');