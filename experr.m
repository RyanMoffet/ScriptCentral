function [x,y,z]=experr(ExpDat,init,fin,lambda,flag)
global lambda ExpDat

% this script will plot the error space for the two parameter
% light scattering fits.
%
% ExpDat is the matrix [size,Ratofms]
% init is the inital values for refractive index and density
%      i.e. [ninit,kinit,rhoinit]
% fin is the matrix of final values 
%     i.e. [nfinal,kfinal,rhofinal]
% lambda=wavelength=0.532um
% flag tells the script what parameters to vary
%      flag=1 vary n and k
%      flag=2 vary k and rho
%      flag=3 vary n and rho
% x=x(i) is a vector containing the values for the first
%        parameter
% y=y(j) is a vector containig the values for the second
%        parameter
% z=z(j,i) contains the value the squared error for the 
%          combination x(i),y(j).
%
% Ryan Moffet 10/05

ns=32;
span=fin-init;

if flag==1 % n and k
    for i=1:ns
        for j=1:ns
            x(i)=init(1)+span(1)*((i-1)/ns);
            y(j)=init(2)+span(2)*((j-1)/ns)^2;
            z(j,i)=FitNK([x(i),y(j),init(3)]);
        end
    end
elseif flag==2 % k and rho
    for i=1:ns
        for j=1:ns
            x(i)=init(2)+span(2)*((i-1)/ns)^2;
            y(j)=init(3)+span(3)*((j-1)/ns);
            z(j,i)=FitNK([init(1),x(i),y(j)]);
        end
    end
elseif flag==3 % n and rho
    for i=1:ns
        for j=1:ns
            x(i)=init(1)+span(1)*((i-1)/ns);
            y(j)=init(3)+span(3)*((j-1)/ns);
            z(j,i)=FitNK([x(i),init(2),y(j)]);
        end
    end
end

figure,mesh(x,y,z);

clear global lambda ExpDat

return
% ____________________________________________________________
function [SSqFun] = FitNK(NK)

global lambda ExpDat

for i=1:length(ExpDat(:,1))
    Fun(i)=(ExpDat(i,2)-mc(1,NK(1),NK(2),lambda,scdp(ExpDat(i,1),NK(3)),1))^2;
end

SSqFun=sum(Fun);
fprintf(1, 'm = %g + %g *i   rho = %g   error = %E\n', NK(1), NK(2), NK(3), SSqFun);

return
