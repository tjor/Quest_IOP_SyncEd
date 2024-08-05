% This file contains all the variables that should be modified at beginning of every cruise
%-----------------------------
 
struct_levels_to_print(0);

warning("off");

# set octave"s graphics_toolkit to the one that works...
graphics_toolkit("gnuplot");

%-----------------------------
CRUISE = "Quest24";

% Variables to be changed during cruise according to specific setups and user needs
%
% 
% Set date interval to be processed (format is "yyyymmdd")
% (this will have to be changed each time the scripts are run)
% first day of cruise = 20180925, jday=268: "With_AC9/"  
% day of switch to default config = 20180927, jday=270: "/" 
% day of ACS switch = 20181019, jday=292": "With_AC9_Without_ACS/"% end day 301
# last day is 20181028
% dates
 
# default config # ACS 167 system
#inidate = "20242307"; #  jday = 204
#enddate = "20242307"; #

inidate = "20220623"; # use for testdata only
enddate = "20220623"; 


WAP_ROOT = strcat('quest24_') # 
dh8_instruments = {"acs", "bb3"}; #
dh8_ports = {3,1}; # note - a dh4 was actually used in this deployment (dh8 label is retained)
dh8_serialnumber = {167,1173}; 
WAPhour = "09"; # typical WAP hours will be between 09-13
ACS_CAL_FILE_NAME = "acs122.dev"


% Underway subdirectory where to find special wapped data
% Leave with simple / if no special case
UWAY_WAP_SUBDIR = "/"; 

% Parameters specific for Underway plotting/processing
% (this will change depending on specific section fo the cruise)
% Setup to automatically change based on UWAY_WAP_SUBDIR
%

if strcmp (UWAY_WAP_SUBDIR, "with_ACS167/") == 1 % # case with 2 acs instruments - start of cruise
     # dh8_instruments = {"bb3", "ctd", "acs", "acs2"};  - full instrument list
      dh8_instruments = {"bb3", "ctd", "acs", }; # - neglecting 167, as it was not used for rest of cruise
     % Ports must corresponds to same ports as in dh8_instruments
     # dh8_ports = {1,2,5,7}; - full port list
      dh8_ports = {1,2,5};  # - neglecting 167, as it was not used for rest of cruise
     % Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
     # dh8_serialnumber = {1173, [], 122, 167};
     dh8_serialnumber = {1173, [], 122};
elseif strcmp(UWAY_WAP_SUBDIR, "dark_counts_BB3/") == 1 % 
     dh8_instruments = {"bb3", "ctd", "acs"};
     # Ports must corresponds to same ports as in dh8_instruments
     dh8_ports = {1,2,5}; 
     # Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
     dh8_serialnumber = {1173, [], 122}; 
elseif strcmp(UWAY_WAP_SUBDIR, "/") == 1 % tjor: this is the `default" config (i.e. without subdirectories inside WAP_extracted) ### EDIT THIS SECTION IN SYNC_ED
     dh8_instruments = {"bb3", "ctd", "acs"};
     % Ports must correspond to same ports as in dh8_instruments
      dh8_ports = {1,2,5}; 
     % Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
     dh8_serialnumber = {1173, [], 122}; 
endif


%-----------------------------
% Paths
MAIN_PATH = "/data/datasets/cruise_data/active/SyncED_Quest/";
PATH_DATA = [MAIN_PATH, "Data/"];        % Directory with all raw and wapped data
PATH_SOURCE = [MAIN_PATH, "Source/"];% Directory with all source code
OUT_PROC = [MAIN_PATH, "Processed/"];    % Output directory for processed oct and mat files
OUT_FIGS = [MAIN_PATH, "Figures/"];      % Output directory for figures
addpath([PATH_SOURCE]);

%-----------------------------
% Each directory will contain a series of subdirectories for each instrument
% (e.g. Underway, Optics_rig, BB3_ctd etc. etc.)
UWAY_DIR = ""; # blank for AMT 22 (different directory srtucture to other cruises).
% Specific data subdirectories
DATA_WAPPED = "Optics/WAP_extracted/";
DATA_RAW = "Raw/";
DATA_FLOW = "Flow/";

%-----------------------------
% calibration file dir 
D_CAL_FILES = '/data/datasets/cruise_data/active/SyncED_Quest/Data/Cal_files/'

%-----------------------------
% Ship"s system directories
PATH_SHIP = [PATH_DATA, 'Ship_data/']

#----------------------------
# Input parameters for ship"s underway data

# NOTE for AMT22 GPS and META data are read from a single text file. For consistency with the newer cruises
# this file is read via 2 separate functions for GPS and META.

# here we assume that the ship"s uway data are always stored in daily folders called YYYYDOY (e.g., 2018290) 
addpath([MAIN_PATH, "Source/Underway/"]) # location where @rd_gps_AMT22 @rd_meta_AMT22 are stored
# DIR_GPS =  [PATH_SHIP, '/underway_daily/']; # 
# DIR_GPS = '/data/datasets/cruise_data/active/AMT24/Ship_data/Compress/Compress/days/seatex-gga/' # hard-coded for amt 24
DIR_GPS = [PATH_SHIP]; #
GLOB_GPS = "2024";
FN_GPS = "daily_gps_meta.csv";
FNC_GPS = @rd_gps_Quest; # this function should be inside Source/Underway

DIR_METDATA = [PATH_SHIP]; #
GLOB_METDATA = "2024";
FN_METDATA = "daily_gps_meta.csv";
FNC_METDATA = @rd_meta_Quest; # this function should be inside Source/Underway

#----------------------------

# Path-related variables for step2
global DIR_STEP1 = [OUT_PROC UWAY_DIR "Step1/"];
global DIR_STEP2 = [OUT_PROC UWAY_DIR "Step2/"];
global DIR_STEP3 = [OUT_PROC UWAY_DIR "Step3/"];
global FN_ROOT_STEP2 = [DIR_STEP2 "proc_optics_" lower(CRUISE) "_"];
global acs_wv = [400:2:750];

% Create path for saving figures
#   global fig_dir = [OUT_FIGS, UWAY_DIR];
global DIR_FIGS = [OUT_FIGS, UWAY_DIR];

% Create directories if they do not exists
   if ~exist(DIR_FIGS, "dir")
      mkdir(DIR_FIGS);
   endif

   if ~exist(DIR_STEP2, "dir")
      mkdir(DIR_STEP2);
   endif

%-----------------------------
% Parameters specific for Optics rig plotting/processing
%
% Wether cdt is saved as ASCII format (false for AMT26; true for AMT27)
ctdASCII = true;
% Limits for temperature and salinity profiles
Tlim = [0 20];
Slim = [33 35];
% Limits for absorption and attenuation profiles
alim = [0.1 0.4];
clim = [0.05 0.6];
chlac9lim = [0 5];
%-----------------------------

% Processors to be used by parcellfun in run_step1par.m
NProc = nproc() - 1;

% Name of processed file to be saved
fproc_name = ["optics_" lower(CRUISE) "_"];

% Limits for time-series plots
acs_raw_lim = [-0.03 0.1]; % acs
flow_lim = [20 45];        % flow rate
bb3_lim = [50 140];       % backscattering
SST_lim = [15 20];         % CTD temperature
SSS_lim = [35 36.5];        % CTD salinity
% Limits for step2 time series
acs_lim = [-0.05 0.3];
ac9_lim = acs_lim;
bb_opt_lim = [70 150];
cstar_lim = [0.75 0.85];
spectra_alim = [0.03];
spectra_clim = [1];
chl_lim = [0.01 5];

%-----------------------------
% Parameters specific for BB3 plotting/processing
%
% Limits for bb3 profiles
bb3lim = [50 300];
%-----------------------------

%-----------------------------
% Parameters specific for underway transect
%
latlim = 54;
trans_SST = [01 30];
trans_SSS = [33 38];
trans_chl = [0.01 5];
trans_cp650 = [0.01 0.3];
%-----------------------------

%-----------------------------
% useful functions
movavg = inline("filter(1/mavgwd*ones(1, mavgwd), 1, x)", "x", "mavgwd"); % this is equivalent to a standard moving average with a window size of mavgwd
%-----------------------------





