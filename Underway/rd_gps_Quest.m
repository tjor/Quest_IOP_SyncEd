function out = rd_gps_Quest(fn)

# columns in csv file: 1. time,2. latitude,3.longitude, 4.Cor_Wind_Dir, 5. Cor_Wind_speed,6. Pressure, 7. Humidity, 8. Air_T,9. Dew_T,10. Chlor,11. CDOM,12. Turb,13. Sea_Temperature,14. Conductivity,15. Salinity,16. Inlet_Temperature,17. Transmittance,18. 19 Oxygen,PAR
# UnitsUTC,degrees_north,degrees_east,degrees,m/s,h Pa,%,degC,degC,mg/m3,QSU,NTU,degC,s/m,PSU,degC,%,uM,uE/m2/s


  d = dlmread(fn,",",2,0) # reads non-time fields

  # reads time fields
  year = nan*ones(length(d),1) #
  month = nan*ones(length(d),1) #
  day = nan*ones(length(d),1) #
  hours = nan*ones(length(d),1) #
  mins = nan*ones(length(d),1) #
  secs = nan*ones(length(d),1) #

  d_time = textread(fn, '%s')
  for i = 4:length(year) + 3
    year(i-3) = str2num(cell2mat(d_time(i))(1:4));
    month(i-3) = str2num(cell2mat(d_time(i))(6:7));	
    day(i-3) = str2num(cell2mat(d_time(i))(9:10));	
    hours(i-3) = str2num(cell2mat(d_time(i))(12:13))+1; # accounts for logger in BST	
    mins(i-3) = str2num(cell2mat(d_time(i))(15:16));	
    secs(i-3) = str2num(cell2mat(d_time(i))(18:19));		
  end

  date_vector = [year, month, day, hours, mins, secs]; % Y, M ,D ,H ,M ,S
  out.time = datenum(date_vector)       
  out.lat = d(:,2);   # col 2 is lat
  out.lon = d(:,3);   # col 3 is lon
     


endfunction
