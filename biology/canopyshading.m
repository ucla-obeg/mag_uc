function PARz = canopyshading(kelp,param,farm,envt,envt_counter)
%----------------------------------------------------------------------
% Bio-optical model, calculates the attenuation of light due to water,
% chl-a (from ROMS) and nitrogen-specific shading. Incoming PAR from ROMS.
% 
% Input: Nf (per m3; not per frond) * already smoothed at canopy
%        envt, farm, step (ENVT data)
% 
% Output: PAR as a function of depth across the entire farm regardless of
% whether there is kelp present in a given area or not.
%
% DB 10/28/22: Check attenuation of light profile
%              seems light attenuate *faster* below the canopy -- should it be the other
%              way around?
%----------------------------------------------------------------------

% Canopy Shading; Nf

%----------------------------------------------------------------------
% Canopy shading depends on fixed nitrogen units
 Nf = kelp.Nf;

%----------------------------------------------------------------------
% Redistribute amount of Nf at surface 
 canopyHeight = kelp.height - farm.z_cult; 

% Here, redistribute amount of Nf at surface, assuming that the canopy can spread
% horizontally so that seld-shading by canopy does not reflect the total canopy
% biomass, but is spread out over a broader area.
% DB: unclear which of the following should be used; top: Christina's; bottom: Daniel's
%     also, to define the canopy height, unclear if param.z_canopy or farm.canopy should
%     be used because the "param.z_canopy" area is canopy
%     NOTE: in the following, changed "farm.canopy" to "param.z_canopy" (note different sign)
 canopyHeight = kelp.height-(farm.z_cult+param.z_canopy); 
%canopyHeight = kelp.height - farm.z_cult;

% Below "canopy" is defined as depths less than "param.z_canopy" depht, in meters
 if canopyHeight<abs(param.z_canopy)
    % Avoids packing canopy in too thin a layer:
    canopyHeight = abs(param.z_canopy);
 end

 % Canopy biomass here is "redistributed" assuming plant spreads horizontally, rather than
 % being packed vertically in the same surface area.
 % Finds indices that belong to canopy:
 ind_can = find(farm.z_arr > param.z_canopy);   
 Nf(ind_can) = Nf(ind_can) ./ canopyHeight;

 % Replacement of NaN with zero for safety reasons;
 % (although there shouldn't be any NaN)
 Nf(isnan(Nf)) = 0;

%----------------------------------------------------------------------
 % Attenuation of PAR with depth
 % PAR0, incoming, at the surface of the ocean
 PAR0 = envt.PAR0(1,envt_counter);

 % preallocate space
 PARz = NaN(farm.nz,1);

 % Calculate attenuation coefficents and resulting PAR from surface to
 % cultivation depth

 % First gets array of irradiance attenuation
 % coefficient K (1/m) within each layer of the farm
 % Attenuate irradiance with sum of three contributions
 % Note: this should follow BEC's approach
 K = param.PAR_Ksw + ...
     param.PAR_Kchla * envt.chla(:,envt_counter) + ... 
     param.PAR_KNf * Nf(:);

 % Initialize light at the top farm level boundary:
 PAR_out = PAR0;

 % Propagates light vertically. Calculates average light
 % within each layer with Lambert-Beer's equation
 % Note, the following loop could be optimized
 % The following equations for the PAR at the bottom of the
 % layer and for the average par within the layer are used
 % based on analytical solution of the Lambert-Beer's equation:
 % PAR_out = Par_in * e^(-K*dz)
 % PAR_mean = PAR_in/(K*dz) * [1 - e^(-Kdz)];
 for indz = farm.nz:-1:1
    PAR_in = PAR_out;
    kdz = K(indz) * farm.dz(indz);
    PAR_out = PAR_in * exp(-kdz);
    PARz(indz) = (PAR_in - PAR_out)/kdz;
    clear kdz
 end
