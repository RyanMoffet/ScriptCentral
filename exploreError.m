function [result] = exploreError(ExpDat, LoB, UpB, lambda, FitFlag)

% This generates error space.

global lambda ExpDat
refmed=1;
da=ExpDat(:,1)';
refre=LoB(1);
refim=LoB(2);
dens=LoB(3);
clear X Y Z result
step = 1;
saved = 0;
result =  zeros(0,3);
if FitFlag ==1 % vary n and k
    while (step<32)
        for pren = 0:step;
            n = pren * (UpB(1)-LoB(1))/step + LoB(1);
            for prek = 0:step;
                k = prek^2 * (UpB(2)-LoB(2))/(step^2) + LoB(2);
                if( ( mod(pren,2)~=0) || (mod(prek,2) ~=0) )
                    saved = saved +1;
                    FUNCTION_VALUE = FitNK([n k dens]);
                    fprintf(1,'n=%f   k=%f   Err=%e\n', n, k, FUNCTION_VALUE);
                    result(saved,:) = [n k FUNCTION_VALUE];
%                     save ERROR_EXPLORED_SO_FAR result
                end
            end
        end
        step = 2 * step;
        [X,Y,Z] = rremake(result);
        mesh(X,Y,Z);
    end
elseif FitFlag==2 % vary n and rho
    while (step<32)
        for pren = 0:step;
            n = pren * (UpB(1)-LoB(1))/step + LoB(1);
            for predens = 0:step;
                rho = predens * (UpB(2)-LoB(2))/step + LoB(2);
                if( ( mod(pren,2)~=0) || (mod(predens,2) ~=0) )
                    saved = saved +1;
                    FUNCTION_VALUE = FitNdens([n refim rho]);
                    fprintf(1,'n=%f   dens=%f   Err=%e\n', n, rho, FUNCTION_VALUE);
                    result(saved,:) = [n rho FUNCTION_VALUE];
%                     save ERROR_EXPLORED_SO_FAR result
                end
            end
        end
        step = 2 * step;
        [X,Y,Z] = rremake(result);
        mesh(X,Y,Z);
    end
elseif FitFlag==3 % vary rho and k
    while (step<32)
        for predens = 0:step;
            rho = predens * (UpB(3)-LoB(3))/step + LoB(3);
            for prek = 0:step;
                k = prek^2 * (UpB(2)-LoB(2))/(step^2) + LoB(2);
                if( ( mod(prek,2)~=0) || (mod(predens,2) ~=0) )
                    saved = saved +1;
                    FUNCTION_VALUE = FitNK([refre k rho]);
                    fprintf(1,'k=%f   dens=%f   Err=%e\n', k, rho, FUNCTION_VALUE);
                    result(saved,:) = [rho k FUNCTION_VALUE];
%                     save ERROR_SPACE_C7_krho result_C7_krho
                end
            end
        end
        step = 2 * step;
        [X,Y,Z] = rremake(result);
        mesh(X,Y,Z);
    end
end
% ndens = [n dens k];
clear global lambda ExpDat
return
%======================================================================

function [SSqFun] = FitNK(NK)

% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global lambda ExpDat

% if FitFlag==1 % vary n and k
    for i=1:length(ExpDat(:,1))
        Fun(i)=(ExpDat(i,2)-mc(1,NK(1),NK(2),lambda,scdp(ExpDat(i,1),NK(3)),1))^2;
    end
% elseif FitFlag==2 % vary n and rho
%     for i=1:length(da)
%         Fun(i)=(ExpDat(i,2)-mc(1,NK(1),0,lambda,scdp(da(i),NK(3)),1))^2;
%     end
% elseif FitFlag==3 % vary k and rho
%     for i=1:length(da)
%         Fun(i)=(ExpDat(i,2)-mc(1,refre,NK(1),lambda,scdp(da(i),NK(3)),1))^2;
%     end   
% end    

% x=0;
% n=NK(1);
% if(n<1.3)
%     x=1.3-n;
% end
% if(n>2)
%     x=n-2;
% end
% k=NK(2);
% y=0
% if(k<0)
%     y=-k;
% end
% if(k>0.5)
%     y=k-.5;
% end
% 
SSqFun=sum(Fun);
% SSqFun=sum(Fun)+1e-14*(x^2+y^2);
fprintf(1, 'm = %g + %g *i   rho = %g   error = %E\n', NK(1), NK(2), NK(3), SSqFun);
return
