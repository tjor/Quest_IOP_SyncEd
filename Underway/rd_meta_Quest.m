function out = rd_meta_Quest(fn)

	# columns in csv file: 1. time,2. latitude,3.longitude, 4.Cor_Wind_Dir, 5. Cor_Wind_speed,6. Pressure, 7. Humidity, 8. Air_T,9. Dew_T,10. Chlor,11. CDOM,12. Turb,13. Sea_Temperature,14. Conductivity,15. Salinity,16. Inlet_Temperature,17. Transmittance,18. Oxygen,  19. PAR
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
	    hours(i-3) = str2num(cell2mat(d_time(i))(12:13))+1;	 # accounts for logger in BST
	    mins(i-3) = str2num(cell2mat(d_time(i))(15:16));	
	    secs(i-3) = str2num(cell2mat(d_time(i))(18:19));		
	  end

	  date_vector = [year, month, day, hours, mins, secs];% Y, M ,D ,H ,M ,S
	  
	  out.time = datenum(date_vector)       
          out.wind_speed = d(:,4);
	  out.wind_dir = d(:,5);
	  out.pressure = d(:,6);
  	  out.humidity = d(:,7);
	  out.air_temp = d(:,8);
	  out.dew_temp = d(:,9);
  	  out.chlor = d(:,10);
	  out.cdom = d(:,11);
	  out.turb = d(:,12);
	  out.sst = d(:,13);
	  out.conductivty = d(:,14);
	  out.salinity = d(:,15);
	  out.inlet_temp = d(:,16);
	  out.trasmittance = d(:,17)
	  out.oxygen = d(:,18)
	  out.par = d(:,19)
	  
	  # typical AMT fields (AMT 22 used as example)
	  
	  # out.smg = d(:,7);  
	  # out.cmg = d(:,8);
	  # out.heading = d(:,9);
	  # out.log = d(:,10);
	  # out.uncdepth = d(:,11);
	  # out.cordepth = d(:,12);
	  # out.sst = d(:,13);
	  # out.conductivty = d(:,14);
	  # out.sal = d(:,15);
	  # out.fluo = d(:,16);
	  # out.trans = d(:,17);
	  # out.air_temp = d(:,18);
	  # out.pressure = d(:,19);
	  # out.humidity = d(:,20);
	  # out.ptir = d(:,21);
	  # out.stir = d(:,22);
	  # out.ppar = d(:,23);
	  # out.spar = d(:,24);
	  
	  out
	  
endfunction
