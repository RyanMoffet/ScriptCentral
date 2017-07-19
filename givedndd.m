function [dndd]=givedndd(c,conc,distype,dens)

%% c is a vector of bin centers
%% conc is a matrix of conctentrations with size going
%% in the columns
%% distype is the type of distribution output
%% dens is density in g/cm^3

dens=dens*1e6;

c=log10(c);     % take log of centers

dc=diff(c);     % get difference of logDp (centers)

% b(1)=c(1)-dc(1)/2; % initiate calculation of boundries

% for i=1:length(c)
%     b(i+1)=c(i)+avgdc/2; % calculate the rest of the boundries
% end

for i=1:length(c)-1
    bb(i)=c(i)-(c(i+1)-c(i))/2;
    if c(i+1)==c(end)
       bb(i+1)=c(i+1)-(c(i+1)-c(i))/2;
       bb(i+2)=c(i+1)+(c(i+1)-c(i))/2;
   end
end

% b=10.^bb;     % give boundries
dd=diff(bb);  % take difference of boundries

% conc=conc';

for i=1:length(conc(:,1))
    for j=1:length(conc(1,:))
        switch distype
        case 'volume'
            dndd(i,j)=(conc(i,j)/dd(j))*(10^c(j))^3 ...
                *10^-12*(pi/6);                           %% this has units of m^3/m^3
        case 'mass'
            dndd(i,j)=(conc(i,j)/dd(j))*(10^c(j))^3 ...
                *10^-12*(pi/6)*dens;
        case 'area'
            dndd(i,j)=(conc(i,j)/dd(j))*(10^c(j))^2;
        case 'number'
            dndd(i,j)=(conc(i,j)/dd(j));        
        end
    end
end

% dndd=dndd';
