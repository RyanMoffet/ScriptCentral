function [babs]=AethBabs(nephin,aethin,meastimes)

%% corrbabs(:,1) returns a vector of times
%% corrbabs(:,2) returns a corrected babs (m^-1)
%% nephin(:,1) returns a vector of times
%% nephin(:,2) returns a vector of corrected bsp (m^-1)
%% aethin(:,1) returns a vector of times
%% aethin(:,4) returns a vector of [BC] (ng/m^3) at 520nm 
%% meastimes{1,1} returns a cell array of date/time strings
%%                indicating aethelometer measurement start times
%% meastimes{2,1} returns a cell array of date/time strings
%%                indicating aethelometer measurement stop times
%% 
%% This algorithm is developed following the work of Arnott et. al
%% Aerosol Sci. Technol. 39:17-29,2005
%%
%% Ryan Moffet Dec '05

alpha=0.0523;
sg=28.07;
M=3.688;
tau=0.2338;
V=5e-3;            %% flowrate in m^3/min
dt=5;              %% measurement time in min
A=1.67e-4;         %% spotsize in m^2

res=datenum(0,0,0,0,5,0);
meastart=datenum(meastimes{1,1})+datenum(0,0,0,8,0,0);  %% Careful here!!!!!!!!!!!!!!!!!!!!!!!!!!
meastop=datenum(meastimes{2,1})+datenum(0,0,0,8,0,0);   %% Added 8hrs for calcofi

bapidx=1;
for i=1:length(meastart)
    nephidx=find(nephin(:,1)==meastart(i));
    aethidx=find(aethin(:,1)==meastart(i));
    if isempty(nephidx) | isempty(aethidx)
        continue
    else
        nbins=(meastop(i)-meastart(i))/res;
        babs(bapidx,1)=aethin(aethidx,1);
        babs(bapidx,2)=(sg*aethin(aethidx,4)*1e-9-alpha*nephin(nephidx,2))/M;
        bapidx=bapidx+1;
        startidx=bapidx;        
        for j=1:nbins
            aethidx=aethidx+1;
            nephidx=nephidx+1;
            babs(bapidx,1)=aethin(aethidx,1);
            babs(bapidx,2)=(sg*aethin(aethidx,4)*1e-9-alpha*nephin(nephidx,2))/M...  %% Eq. 27 in Arnott et. al.
                *sqrt(1+(((V*dt)/A)*sum(babs(startidx:bapidx-1,2)))/tau);
            bapidx=bapidx+1;
        end
    end
end

