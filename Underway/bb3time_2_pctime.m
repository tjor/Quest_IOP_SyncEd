function bb3time_2_pctime()

[msec_bb3 time_bb3 dat_bb3] = rd_ecobb3("/data/datasets/cruise_data/active/AMT24/DallOlmo/Uway/WAP_Extracted/amt24_14_292_22_ASCII.004");


[MM,DD,YY,hh,mm,ss, msec_pc] = rd_19("/data/datasets/cruise_data/active/AMT24/DallOlmo/Uway/WAP_Extracted/amt24_14_292_19_T_ASCII.004");

time_pc = datenum([2000+YY MM DD hh mm ss]);

%interpolate bb3time onto pc_time scale
time_bb3_i = interp1(msec_bb3, time_bb3,  msec_pc);

%compute difference
delta_t = time_pc - time_bb3_i

mean_delta_t = mean(delta_t(2:end))
keyboard

endfunction
