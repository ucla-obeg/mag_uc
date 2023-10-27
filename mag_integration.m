function [mag] = mag_integration(mag)
%----------------------------------------------------------------------
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Time integration of mag model
%
%       Computes growth and mortality
%       Updates kelp structures
%       Fills in output structure
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Daniele Bianchi, UCLA, Feb 2023
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Unwraps mag structures for convenience. All structures are updated within "mag" 
% at the end in case they are modified by integration subroutine.
% NOTE: For consistency, use the following order preferentially when calling these 
%       structures in other functions.
 kelp  = mag.kelp;
 param = mag.param;
 farm  = mag.farm;
 envt  = mag.envt;
 time  = mag.time;
 out   = mag.out;

%----------------------------------------------------------------------
% Begins time-stepping
% MAG growth -> set up as dt_Gr loop for duration of simulation
 for sim_hour = [time.dt_Gr:time.dt_Gr:time.duration]; %time.duration % [hours]
    gr_counter = sim_hour / time.dt_Gr; % growth counter
    envt_counter = ceil(gr_counter*time.dt_Gr/time.dt_ROMS); % ROMS counter

    %% DERIVED BIOLOGICAL CHARACTERISTICS
    kelp = kelpchar(kelp,param,farm);
   
    %% DERIVED ENVT
    envt.PARz  = canopyshading(kelp,param,farm,envt,envt_counter);
   
    %% GROWTH MODEL
    % updates Nf, Ns with uptake, growth, mortality, senescence
    % calculates DON and PON
    kelp = mag_growth(kelp,param,farm,envt,time,envt_counter);
   
    %%% FROND INITIATION
    %kelp = frondinitiation(kelp,envt,farm,time,gr_counter);
    %kelp = frondsenescence(kelp,time,sim_hour);  

    % Wrap up output variables into Out structure
    out.Nf(:,gr_counter) = kelp.Nf;
    out.Ns(:,gr_counter) = kelp.Ns;
    temp_Nf = nan2zero(kelp.Nf);
    out.kelp_b(1,gr_counter) = sum(temp_Nf .* farm.dz)./param.Qmin./1e3; % kg-dry/m2
    out.kelp_h(1,gr_counter) = kelp.height;
    out.Bm(:,gr_counter) = kelp.b_per_m;
    clear temp_Nf
 end

%----------------------------------------------------------------------
% Wraps up structures for output
% In case they have been modified by integration
 mag.param = param;
 mag.time  = time;
 mag.farm  = farm;
 mag.envt  = envt;
 mag.kelp  = kelp;
 mag.out   = out;

