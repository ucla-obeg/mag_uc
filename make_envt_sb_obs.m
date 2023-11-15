function envt = make_envt_sb_ROMS(farm,setup,time);
%----------------------------------------------------------------------
% Environmental Input Data from LTER timeseries dataset
% INPUT: farm, time, directories for ROMS/LTER dataset and WAVE data
% OUTPUT: envt.()
%   NO3; daily Nitrate in seawater (from LTER); [umol/m3] 
%   NH4; daily ROMS Ammonium in seawater (still use ROMS output for now); [umol/m3]
%   DON; daily ROMS DON, dissolved organic nitrogen (still use ROMS output for now); [mmol N/m3]
%   T; daily LTER Temperature; [Celcius]
%   magu; magnitude velocity from daily LTER measurments of Uo,Vo,Wo Seawater velocity, [m/h]
%   PAR; daily LTER PAR, photosynthetically active radiation; incoming PAR; [W/m2]
%   chla; adily ROMS chl-a: sum of DIAZ+DIAT+SP (small phytoplankton); [mg-chla/m3]
%   Tw; daily LTER Wave period; [h]
%   Hs; daily LTER Significant wave height; [m]
%
% The ROMS simulations and LTER dataset have been pre-processed and saved as mat files for
% use by MAG.
%% Note that pre-processing LTER dataset is still ongoing (there are a lot of missing data for us to be able to run a full year)
% Data is 1-m bins from surface to bottom depth.
% Interpolate (Repeat data from the surface to the bottom depth) to the farm z-array.
%
% 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Load input file
 tmp = load([setup.in_dir '/' setup.in_file]);
% Package input structure into "roms" structure
 tmpnames = fieldnames(tmp);
 roms = tmp.(tmpnames{1});
 clear tmp tmpnames
%----------------------------------------------------------------------
           
% SBC farm site; offshore Mohawk; 60-m water depth

 roms_start = datenum(roms.datetime(1));
 time_start = datenum(time.start);
 
% Checks that ROMS and MAG start time are the same
% (This can be updated to be more flexible) 
 if ~(roms_start==time_start)
    error(['make_envt_sb_obs.m: Mismatch between obs and MAG start time']);
 end
    
%----------------------------------------------------------------------
% Uses the following to interpolate between ROMS and MAG (farm) grids
% Depths follow physical convention: negative, from deepest to shallowest
 z_farm = farm.z_arr;
 % DB: Apparently only first 60 depths used -- this needs t be corrected
 z_roms = -flipud(roms.depth(1:60)');
 nt_roms = length(roms.datetime);
%----------------------------------------------------------------------
% Repeat data from the surface to the bottom for now
 roms_vars = {'u','v','NO3','PAR','temp','wavemeanHS','wavemeanTP','urea','NH4'}; 
 roms_nvar = length(roms_vars);
 clear envt
 for indv=1:roms_nvar
    % ROMS variable need to be size of [nz,nt]
    tmp1 = flipud(transpose(roms.(roms_vars{indv}))); 
    % Fills current variable in "envt" structure
    envt.(roms_vars{indv}) = tmp1;
 end
 
% For now fills in ROMS output assuming daily time-step
% Interpolates betweeen ROMS depth grid and MAG farm grid
 roms_vars = {'SPCHL','DIATCHL'}; 
 roms_nvar = length(roms_vars);
 for indv=1:roms_nvar
    % ROMS variable need to be size of [nz,nt]
    tmp0 = flipud(transpose(roms.(roms_vars{indv})));
    tmp1 = interp1(z_roms,tmp0,z_farm); 
    % Fills current variable in "envt" structure
    envt.(roms_vars{indv}) = tmp1;
 end


%----------------------------------------------------------------------
% Postprocesses some of the inputs
 %envt.DON = 16/106 * envt.DOC;
 envt.DON = 5*envt.urea;
 envt.chla = envt.SPCHL + envt.DIATCHL;
 envt.chla(:,366) = [];
 envt = rmfield(envt,{'SPCHL','DIATCHL'});
% Converts velocities from m/s to m/h
 envt.u = envt.u * 3600;
 envt.v = envt.v * 3600;
% Magnitude of (horizontal) velocity vector
 envt.magu = sqrt(envt.u.^2 + envt.v.^2);
 %envt.magu(:,366) = envt.magu(:,365);
 envt = rmfield(envt,{'u','v'});
% Renames temp to T
 envt.T = envt.temp;
 envt = rmfield(envt,{'temp'});



 
% PAR0 is the PAR at the surface; for now uses ROMS at first layer
 envt.PAR0 = roms.PAR(:,1)'/5 % ;(µmol m-2) to w/m2
 
 %envt.PAR0(isnan(envt.PAR0)) = nanmean(roms.PAR(:,1)'/5);
% Note, depth-dependent PAR not needed, here removes it
% (But could keep it for comparison purposes)
 if isfield(envt,'PAR');
    envt = rmfield(envt,{'PAR'});
 end

% Removes other variables not needed:
 envt = rmfield(envt,{'urea'});
 
% Adds need variables (temporary - this should be from an input file)

% Wave period
 %envt_Tw = 7.56/3600; % [h]
 envt.Tw = envt.wavemeanTP./3600;
 %envt.Tw = repmat(envt_Tw,1,nt_roms);
% Significant wave height
 %envt_Hs = 0.86; % [m]
 %envt.Hs = repmat(envt_Hs,1,length(time.timevec_Gr));
 envt.Hs = envt.wavemeanHS;
 envt = rmfield(envt,{'wavemeanTP','wavemeanHS'});


% Do here any additional postprocessing (included for testing)
% To get default, uncomment the following; set to default values:
%envt.NO3 = envt.NO3 * 0 + 1.6;		% 1.6
%envt.NH4 = envt.NH4 * 0 + 0.01;	% 0.01
%envt.DON = envt.DON * 0 + 3.0;		% 3.0
%envt.T = envt.T * 0 + 14.5;		% 14.5
%envt.magu = envt.magu * 0 + 516;	% 516
%envt.chla = envt.chla * 0 + 0.4;	% 0.4
%envt.PAR0 = envt.PAR0 * 0 + 86;	% 86
%envt.Tw = envt.Tw * 0 + 0.00216;	% 0.00216
%envt.Hs = envt.Hs * 0 + 0.86;		% 0.86
 
%----------------------------------------------------------------------
% If needed makes a multi-panel plot of env. variables 
 if (0)
    figure
    tiledlayout('flow')
    vname = fieldnames(envt);
    nvar = length(vname);
    for indv=1:nvar
       nexttile
       plot(mean(envt.(vname{indv}),1),'-','linewidth',3)
       hold on
       tmp0 = mean(mean(envt.(vname{indv}),1),2);
       tmp1 = repmat(tmp0,[1 nt_roms]);
       plot(tmp1,'r-','linewidth',3)
       title(vname{indv});
    end 
 end
%----------------------------------------------------------------------



