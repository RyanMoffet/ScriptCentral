function [avint,sumdist] = PulseBsca(inid,scnum,sizbins1,timebins,sizbins,calpars,msmt)

%% this script calculates the scattering coefficient of several classes by averaging the pulse areas
%% converting them to cross section (cm^2), multiplies by concentration (#/m^3) to give bsca (m^-1)
%% inid is a cell array of inids
%% scnum is a cell array of scnum number concentrations (dN) with each cell corresponding 
%%       to an inid (in the same order) each cell is a matrix with rows of time and
%%       columns of size
%% sizbins1 are the size bins of the size distribution scnum
%% Time bins are the bins of time for each mesurement
%% sizbins are the size bins used in the bsca calculation
%% calpars are the scattering calibration parameters 
%% msmt is the yaada scattering column as a string 'saarea', 'sbarea' etc

res2=datenum('00:30:00');
for i=1:length(inid)
    [time,intens,siz]=get_column(inid{i},'Time',msmt,'Da');
    for j=1:length(timebins)
        timeidx=find(time>(timebins(j)-res2) & time<(timebins(j)+res2));
        for k=1:length(sizbins)-1
            sidx=find(siz>sizbins(k) & siz<sizbins(k+1));
            compidx=intersect(timeidx,sidx);
            if isempty(compidx)
                avint{i}(j,k)=0;
                sumdist{i}(j,k)=0;
            else
                finint=intens(compidx);
                avint{i}(j,k)=calpars(1)*nanmean(finint)+calpars(2);
                sidx1=find(sizbins1{i}>sizbins(k) & sizbins1{i}<sizbins(k+1));
                if isempty(sidx1)
                    sumdist{i}(j,k)=0;
                else
                    sumdist{i}(j,k)=nansum(scnum{i}(j,sidx1(1):sidx1(end)))*avint{i}(j,k)*100;
                    if sumdist{i}(j,k)<0 | isnan(sumdist{i}(j,k))
                        sumdist{i}(j,k)=0;
                    end
                end
            end
        end
    end
end