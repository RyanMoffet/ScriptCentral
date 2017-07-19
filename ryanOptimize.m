function [ndens] = ryanOptimize(ExpDat, RefKDens, LoB, UpB, lambda, FitFlag)

% This is Thomas's gradient search method
    %learningRate = size(w,1) / (sqrt(iterations)*size(Z,1)*sum(w));
    global refmed lambda da ExpDat dens
	refmed=1;
    da=ExpDat(:,1)';
    iterations = 30;
    kmax = 6;
    Z(1:3) = RefKDens(1:3);
%     Z(1) = RefKDens(1);
%     dens = RefKDens(2);
%     Z(2) = RefKDens(3);
    epsilon = .002 * Z + .00001;
    toofar = 40*epsilon;
    g = .38197;
    fprintf(1,'STARTING POINT\n');
    newStress = FitNK(Z);
    fcounter=1;
    for(iter=1:iterations)
		fprintf(1,'iteration %d 4 calls to get Z0, gradient and Z1   counter=%d\n',iter, fcounter);
        % Gets the gradient in N, K, rho
        NK0 = Z;
        SS0 = newStress;
        for zdim = 1: length(Z)
            NK = Z;
            NK(zdim) = NK(zdim) + epsilon(zdim);
            SS = FitNK(NK);
            fcounter = fcounter+1;
            zgradient(zdim) = (SS - SS0) / epsilon(zdim);
        end
        nf = norm(zgradient);
        if(nf==0)
            break;
        end
        zgradient = zgradient / nf;
        fprintf('current gradient %g + %g * i drho=%g   counter=%d\n', zgradient(1), zgradient(3), zgradient(2), fcounter);
        Z1 = Z - epsilon .* zgradient;
        SS1 = FitNK(Z1);
        fcounter = fcounter+1;
        Z0 = Z;
        SS2 = SS1*0.9999999999;
        Z2 = Z1;
        %up by octaves, 
        fprintf(1,'Finding too far     counter =%d\n', fcounter);
        toofar = sqrt(norm(epsilon)*toofar); 
        step0 = 0;
        step1 = epsilon;
        step2 = epsilon;
        while(SS2<SS1)
            Z0 = Z1;
            SS0 = SS1;
            step0 = step1;
            Z1 = Z2;
            step1 = step2;
            SS1 = SS2;
            toofar = 2*toofar;
            Z2 = Z - toofar .* zgradient;
            step2 = toofar;
            SS2 = FitNK(Z2);
            fcounter = fcounter+1;
        end
        % down by, well not quite fifths, but its pythagorean anyways
        larger =2;
        newZ = Z;
        fprintf(1,'Shrinking the interval      counter=%d\n', fcounter);
        for k=1:kmax
            if(larger==1)
                newStep = (1-g)*step1 + g*step0;
            else
                newStep = (1-g)*step1 + g*step2;
            end
            newZ = Z - newStep .* zgradient;
            newStress = FitNK(newZ);
            fcounter = fcounter+1;
            if(larger==1)                % New point cutting first segment
                if(newStress<SS1) % Keep 0, new, 1
                    step2 = step1;
                    Z2 = Z1;
                    SS2 = SS1;
                    step1 = newStep;
                    Z1 = newZ;
                    SS1 = newStress;
                else                     % Keep new, 1, 2
                    step0 = newStep;
                    Z0 = newZ;
                    SS0 = newStress;                   
                end
            else                         % New point cutting second segment
                if(newStress<SS1) % Keep 1, new, 2
                    step0 = step1;
                    Z0 = Z1;
                    SS0 = SS1;
                    step1 = newStep;
                    Z1 = newZ;
                    SS1 = newStress;                   
                else                     % Keep 0, 1, new
                    step2 = newStep;
                    Z2 = newZ;
                    SS2 = newStress;                   
                end
            end
            % what is the new larger segment now?
            if( norm(step1-step0)> norm(step2-step1) )
                larger =1;
            else
                larger = 2;
            end
        end % k loop of golden mean sections
        Z = newZ;
    end % iterations
%     ndens(1) = Z(1);
%     ndens(2) = dens;
%     ndens(3) = Z(2);
    ndens = Z;
return



function [SSqFun] = FitNK(NK)

% [CrossSection] = MieCalF(REFMED,n,k,WAVELEN,DIAMETER,LGEOM)
global refmed lambda da ExpDat dens
dens = NK(2);
for i=1:length(da)
    Fun(i)=((MieCalF(refmed,NK(1),NK(3),lambda,scdp(da(i),dens),1)-...
            MieCalF(refmed,NK(1),NK(3),lambda,scdp(da(i),dens),2))-ExpDat(i,2))^2;
%     Fun(i)=((MieCalF(refmed,NK(1),NK(2),lambda,scdp(da(i),dens),1)-...
%             MieCalF(refmed,NK(1),NK(2),lambda,scdp(da(i),dens),2))-ExpDat(i,2))^2;
end
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
%fprintf(1, 'm = %g + %g *i   rho = %g   error = %E\n', NK(1), NK(2), dens, SSqFun);
fprintf(1, 'm = %g + %g *i   rho = %g   error = %E\n', NK(1), NK(3), dens, SSqFun);
return
