clear;

path_old=pwd;                       
[name,path_f]=uigetfile('*.dat');           % choose the file
cd (path_old);  
fid=fopen(name,'r');                                % open the data file

 str=fgets(fid);                                    % omission of first 6 lines in the file
 disp(str)
 str=fgets(fid);
 disp(str)
 str=fgets(fid);
 disp(str)
 
 str=fgets(fid);
 i=0;
 while (str~=-1)
    i=i+1;
    x=str;
    serial(i)=str2num(x(1:5));                      % serial number
    year(i)=str2num(x(13:16));                      % year
    %year(i)=2003;                                   % milenium problem
    month(i)=str2num(x(7:8));                       % month
    day(i)=str2num(x(10:11));                       % day
    day0(i)=day(i);
    hour(i)=str2num(x(18:19));                      % hour
    hour0(i)=hour(i);
    minute(i)=str2num(x(21:22));                    % minute
    sec(i)=str2num(x(24:25));                       % secund
    %hour(i)=hour(i)+1/60*minute(i)+1/3600*sec(i);   % calculate hour in decimal
    aa=findstr(str,',');
    strend=aa(length(aa));
    str=str';
    X=str2num(str(27:strend)');
    
    lat(i)=X(1);                                    % latitude
    long(i)=X(2);                                   % longtitude
    alt(i)=X(3);                                    % altitude
    p(i)=X(4);                                      % pressure
    az(i)=X(5);                                     % sun azimuth angle
    m(i)=X(6);                                      % air mass
    dist(i)=X(7);                                   % Earth-sun distance ratio
    t(i)=X(8);                                      % temperature of microtops
    sig(i,:)=X(10:14);                              % signal
    std(i,:)=X(15:19);                              % standar deviation of signal
    R380_440(i)=X(20);
    R440_500(i)=X(21);                              % signal 440 to 500 ratio
    R500_670(i)=X(22);                              % signal 500 to 675 ratio
    R675_870(i)=X(23);                              % signal 675 to 870 ratio
    AOT(i,:)=X(24:28);                              % Aerosol optical depth

    str=fgets(fid);
 end
 disp('done getting data from file')
 
 disp('Set year to 2004')
 nd=datenum(year,month,day,hour,minute,sec)-datenum(2003,12,31,0,0,0);                 % calculate julian day
 %n=length(lat);                                     % number of records  
 
 data=[nd', lat', long', AOT, az', m'];
 % error corrections:
 dawn_dusk = find(az>80)
 data(dawn_dusk,:)=[];
 i=0;
 copydata = data;
 while (size(copydata,1) >=1)
     i=i+1;
     same_15min = find( abs(copydata(:,1)-copydata(1,1))<(15/60/24) );      % bin by 15 min. intervals
     if (length(same_15min) ~= 1)
         data_15min(i,[1 2 3 9 10]) = mean(copydata(same_15min,[1 2 3 9 10]),1); % average stats
         data_15min(i,4:8) = min(copydata(same_15min,4:8),[],1);                   % take min_val for AOTs
     end
     copydata(same_15min,:)=[];
 end
 disp('done binning data into 15min intervals')

 i=0;
 copydata = data_15min;
 while (size(copydata,1) >= 1 )
     i=i+1;
     same_2hr = find( abs(copydata(:,1)-copydata(1,1)) < (2/24) );
     data_2hr(i,1:10) = mean(copydata(same_2hr,1:10),1); % average all
     copydata(same_2hr,:)=[];
 end
 disp('done binning data into 2-hour averages')
 
 i=0;
 copydata = data_15min;
 while (size(copydata,1) >=1)
     i=i+1;
     same_day = find( abs(copydata(:,1)-copydata(1,1))<1 );      % bin by 15 min. intervals
     data_day(i,1:10) = mean(copydata(same_day,1:10),1); % average all
     copydata(same_day,:)=[];
 end
 disp('done binning data into daily averages')
 
 cd('C:\Documents and Settings\guillaume\Desktop')
 save aotng.dat data -ascii;
 plot(data_15min(:,1),data_15min(:,6),'b.',data_2hr(:,1),data_2hr(:,6),'r-',data_day(:,1),data_day(:,6),'g-');
 mintime=floor(2*min(data_15min(:,1)))/2;
 maxtime=ceil(2*max(data_15min(:,1)))/2;
 axis tight, set(gca,'xtick',mintime:0.5:maxtime), grid on,
 legend('single 15 min. measurements','2-hour averages','daily averages')
 xlabel('Day number'), title('Sunphotometer data'),
 ylabel('Aerosol Optical Depth at 500nm');
 
