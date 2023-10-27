function mag = mag_run(varargin)
%----------------------------------------------------------------------
%  MAG - UC
%  Version 0.2, D. Bianchi
%      wrapped up code into individual functions
%  Version 0.1, A. Pham, D. Bianchi, D. Dauhajre, C. Fieder, C. Davis, October 2022
% 
%  mag - simplified model of macroalgal growth in 1-D
%  volume-averaged; not tracking fronds
%
% Structure components 
% NOTE: For consistency, use the following order preferentially when calling these 
%       structures in other functions.
%       mag.kelp	--> kelp state variables
%       mag.param	--> kelp parameters and constants
%       mag.farm	--> farm setup
%       mag.setup	--> simulation setup
%       mag.envt	--> environmental drivers
%       mag.time	--> time/timestepping information
%       mag.out		--> output information
%  "kelp" --> State Variables:
%    Ns, macroalgal stored nitrogen, [mg N/m3]
%    Nf, macroalgal fixed nitrogen, [mg N/m3]
%  "envt" --> Environmental input:
%    nitrate, ammonium, dissolved organic nitrogen: for uptake term (units
%    below)
%    seawater velocity (u: m/s) and wave period (Ts: seconds): for uptake term
%    temperature: for growth term (Celcius)
%    wave height: for mortality term (Hs: meters)
%    PAR (W/m2) and chla (mg Chl-a m-3): for light attenuation
%    magu: magnitude of horizontal velocity ### UNITS ### (m/s)
%  Driving biogeochemical variables
%    NO3, Concentration of nitrate in seawater, [mmol NO3/m3]
%    NO2, Concentration of nitrite in seawater, [mmol NO3/m3]
%    NH4, Concentration of ammonium in seawater, [mmol NH4/m3]
%    DON, dissolved organic nitrogen, [mmol N/m3]
%    PON, particulate organic nitrogen, [mg N/m3]
%  "farm" --> Farm Design: 1 dimensional (depth, z) [meters]
%    Note: depths are assumed to be negative (below the sirface at 0 m)
%    Farm array: z_cult:dz:0
%  Data Source:
%    TBD
%----------------------------------------------------------------------
addpath('./functions/');
addpath('./biology/');
%----------------------------------------------------------------------
% Allows to pass a list of parameter inputs using two arrays:
%     ParNames = {'param1','param2','param3',...}
%     ParVal   = [val1,val2,val2,...]
% Names and values will be changed in the corresponding structures:
%     setup : parameters controlling the run setup 
%     param : parameters controlling kelp biology
%     farm  : parameters controlling the farm setup
% Note: only single-valued parameters can be changed this way. 
%     The code can not handle parameters that are arrays with size different from [1 1]
%     or parameters that are non-numerical
% Note: parameters are substitued in any structure where the same field name is
%     found. This assumes different structures have non overlapping field names
% Process inputs (varargin)
A.ParNames = {};        % Pass parameter names that need to be modified from default values
A.ParVal = [];          % Pass parameter values, corresponding to ParNames
A = parse_pv_pairs(A, varargin);
%----------------------------------------------------------------------
% Initialize the model
 clear mag;
 mag = struct;

%----------------------------------------------------------------------
% Setup defaults for parameter structures "setup", "param", "farm"
% These contain default parameters that can be updated by user inputs
% as defined in the "ParNames" and "ParVal" inputs
%----------------------------------------------------------------------
% Initializes simulation setup
% This includes start and end time, timestep info, I/O info etc.
 mag.setup = mag_setup;

% Initializes biological parameters used by MAG
% Each species should have different parameters (will be included as option)
 mag.param = param_macrocystis;

% Design parameters of the 1-d farm
 mag.farm = farmdesign;
 
%----------------------------------------------------------------------
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% In case parameters are specified as inputs, e.g. by passing the
% cell arrays "ParNames" and "ParVal" then substitutes old parameter
% values with new one, by matching names and values.
% ParNames = {'par1';'par2';...}
% ParVal = [val1; val2; ...];
% % % % % % % % % % % % % % % % % % % % 
% Substitute parameters from input:
 if ~isempty(A.ParNames)
    for indp=1:length(A.ParNames)
       mag.setup = mag_change_input(mag.setup,A.ParNames{indp},A.ParVal(indp));
       mag.param = mag_change_input(mag.param,A.ParNames{indp},A.ParVal(indp));
       mag.farm  = mag_change_input(mag.farm,A.ParNames{indp},A.ParVal(indp));
    end
 end
%----------------------------------------------------------------------
% Here initializes setup, farm, kelp and environment and calculates
% any property derived by updated parameter structures
%----------------------------------------------------------------------

% Generate farm grid properties
 mag.farm = mag_setup_farm(mag.param,mag.farm);

% Seed the Farm (initialize biomass)
 mag.kelp = seedfarm(mag.param,mag.farm);
 
% Simulation setup and time stepping
 mag.time = simtime([mag.setup.year_start 1 1; mag.setup.year_end 12 31]); % start time and stop time of simulation

% Defines Environmental input for the run
%mag.envt = make_envt_testcase(mag.farm,mag.time); 
 mag.envt = make_envt_sb_ROMS(mag.farm,mag.setup,mag.time); 
     
% Initialize output structure
 mag = mag_init_output(mag);

%----------------------------------------------------------------------
% Integration subroutine
 [mag] = mag_integration(mag);

%----------------------------------------------------------------------
% Final cleanup and post-processing if needed
 if mag.setup.isave_envt==0
    mag = rmfield(mag,'envt');
 end
