clear
clc

totdata = [];
sdir='../D_UTC/';
% sdir='../D_LST/';
tmp=load([sdir, 'fname.txt']);
dim1=size(tmp);
fid=fopen([sdir, 'fname.txt']);

for kk=1:1:dim1(1,1)
% kk     
fnm=fscanf(fid,'%s',[1]);
ifile=[sdir fnm]

data = load(ifile);

% interval of time-average: if 1 minute average: itvm=1
itvm=1;
itvl=itvm/60/24;

outdata = [];
tmpwda = [];
radiation=[];
meteorology=[];
dim=size(data);

year=data(:,1);
month=data(:,2);
day=data(:,3);
hour=data(:,4);
min=data(:,5);
sec=data(:,6);

jdy = datenum(year,month,day,hour,min,sec) - datenum(2003,12,31,0,0,0);
sjdy=fix(jdy(1));
ejdy=fix(jdy(dim(1,1)))+1;

k=1;
kk=0;
i=0;
idwd=15;
id=6;
avgwd=0;
for j=sjdy:itvl:ejdy-itvl
    i=i+1;
        n = find((jdy > j) & (jdy < j+itvl));
        if any(n)
            avgdata = mean(data(n,:),1);
        else
            avgdata = zeros(1, dim(1,2)).*NaN;
        end
        
% For average of wind direction         --- start !!
        dimwd=size(n);
        if dimwd(1,1) >1
        for iw=2:dimwd(1,1)
            if data(n(iw-1),idwd)-data(n(iw),idwd) > 180
                data(n(iw),idwd)=data(n(iw),idwd)+360;
            elseif data(n(iw-1),idwd)-data(n(iw),idwd) < -180
                data(n(iw-1),idwd)=data(n(iw-1),idwd)+360;
            end
        end
        
        avgwd = mean(data(n,idwd));
        if avgwd >= 360
            avgwd=avgwd-360;
        end
        avgdata(10)=avgwd;
        end
% For average of wind direction         --- end !!


% Julian day --> date
pdate = datevec(datenum(2003,12,31,0,0,0)+j);
avgdata(1)=pdate(:,1);                          % year
avgdata(2)=pdate(:,2);                          % month
avgdata(3)=pdate(:,3);                          % day
avgdata(4)=pdate(:,4);                          % Hour
avgdata(5)=pdate(:,5);                          % minute
avgdata(6)=pdate(:,6);                          % second
time=hour+min/60+sec/3600;

    totdata = [totdata; j avgdata];
    outdata = [outdata; j avgdata];
    radiation=[radiation; j avgdata(id+1) avgdata(id+2) avgdata(id+3) avgdata(id+4) avgdata(id+5) avgdata(id+6) avgdata(id+7) avgdata(id+8)];
    meteorology=[meteorology; j avgdata(id+9) avgdata(id+10) avgdata(id+11) avgdata(id+12) avgdata(id+13) avgdata(id+14)];
end

        savefile1=[sdir,'AVE/' fnm(1:9) '_' int2str(itvm) 'min.out'];
        savefile2=[sdir,'AVE/' fnm(1:9) '_' int2str(itvm) 'min.rad'];
        savefile3=[sdir,'AVE/' fnm(1:9) '_' int2str(itvm) 'min.met'];        
      
        save (savefile1, 'outdata',  '-ascii');
        save (savefile2, 'radiation',  '-ascii');
        save (savefile3, 'meteorology',  '-ascii');        

% plot(outdata(:,1),outdata(:,16),'k');
% hold on;
% plot(D_UTC/AVEwda(:,1),D_UTC/AVEwda(:,2),'bs');

end
% end
        savefile=[sdir,'/AVE/totavg.txt'];
        save (savefile, 'totdata',  '-ascii');
