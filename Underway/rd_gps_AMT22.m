function out = rd_gps_AMT22(fn)

    # columns 1-6 are:  index, year, jday, hour, min sec: e.g. 900, 12.00000    288.00000      9.00000     45.34836    -18.94421  
    

   #d = csvread(fn,1,0)
    
   d(1201:1440,26)=nan

   date_vector = [(2000 + d(:,2)), ones(length(d),1)*month(d(1,3)), day(d(:,3)), zeros(length(d),1) ,[0:1439]',  zeros(length(d),1)];% Y, M ,D ,H ,M ,S
   out.time = datenum(date_vector)       
   
   out.lat = d(:,5); # col 5 is lat
   out.lon = d(:,6);   # col 6 is lon
      

endfunction
