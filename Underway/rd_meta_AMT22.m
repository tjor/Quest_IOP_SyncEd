function out = rd_gps_AMT22(fn)

  #    d = csvread(fn,1,0)
 
   d(1201:1440,26)=nan; #- fix for final day
 
   date_vector = [(2000 + d(:,2)), ones(length(d),1)*month(d(1,3)), day(d(:,3)), zeros(length(d),1) ,[0:1439]',  zeros(length(d),1)];% Y, M ,D ,H ,M ,S
   out.time = datenum(date_vector)
         
     #    smg,           cmg,            heading,    log,       uncdepth, cordepth,seatemp(DEG C),conductivity(S/m),         salinity(PSU),  fluo(V),     trans(V),       airtemp(DEG C), press(mbar),    humid,           ptir(mV),           stir(mV),       ppar(mV),       spar(mV),       trueWindSpeed(knots),   trueWindDir(DEG) - fields in order: column  7 == smg


# GPS Speed knots     GPS Course degs     Gyro Heading degs   SpeedThruWater      UncorrectedDepth    CorrectedDepth      SeaTemperature DegC Conductivty S/m     Salinity PSU        Fluoresence         Trans               AirTemp DegC        Pressure mbar       Humid %             PTIR WM2            STIR WM2            PPAR WM2            SPAR WM2         -           TrueWindSpd        TrueWindDir

    out.smg = d(:,7);  
    out.cmg = d(:,8);
    out.heading = d(:,9);
    out.log = d(:,10);
    out.uncdepth = d(:,11);
    out.cordepth = d(:,12);
    out.sst = d(:,13);
    out.conductivty = d(:,14);
    out.sal = d(:,15);
    out.fluo = d(:,16);
    out.trans = d(:,17);
    out.air_temp = d(:,18);
    out.pressure = d(:,19);
    out.humidity = d(:,20);
    out.ptir = d(:,21);
    out.stir = d(:,22);
    out.ppar = d(:,23);
    out.spar = d(:,24);
    out.wind_speed = d(:,25);
    out.wind_dir = d(:,26);

endfunction
