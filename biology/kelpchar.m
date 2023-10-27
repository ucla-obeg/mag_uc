function kelp = kelpchar(kelp,param,farm)
%----------------------------------------------------------------------
% Calculate biological characteristics from Nf, Ns (known)
%
% OUTPUT:  
%   Q (## UNITS ###) mg N / g-dry of biomass
%   Biomass (## UNITS ###) g-dry of biomass
%   depth resolved surface_area-to-biomass (## UNITS ###) sa2b [m^2/g(wet)]
%   height: total height (m)
%   frBlade, fractional biomass that is blade = blade:frond (unitless)
%
% NOTES:
% Q is integrated across depth, Rassweiler et al. (2018) found that N content does
% not vary with depth. This can be interpreted as translocation occuring on
% the scale of hours (Parker 1965, 1966, Schmitz and Lobban 1976). 
% Side note: Ns is redistributed after uptake as a function of fractional Nf.
% This is how the model "translocates" along a gradient of high-to-low
% uptake. Mathematically, this keeps Q constant with depth. -> There may be
% more recent work coming out of SBC LTER that indicates N varies along
% the frond, particularly in the canopy in a predictable age-like matter
% (e.g., what tissues are doing most of the photosynthesis) (T. Bell pers.
% comm.)
%
% Biomass calculation from Hadley et al. (2015), Table 4 [g(dry)/dz]
%                
% Surface area to biomass
%
% Blade-to-stipe ratio derived from Nyman et al. 1993 Table 2
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Calculate DERIVED variables on a per frond basis

% KNOWN STATE VARIABLES
% Ns, Nf 

% DERIVED VARIABLES
    
% First set NaN values to zeros in the temporary arrays
 temp_Ns = nan2zero(kelp.Ns);
 temp_Nf = nan2zero(kelp.Nf);
 
% Calculates the nutrient quota Q (excess stored nutrients, unitless)
 kelp.Q = param.Qmin .* (1 + sum(farm.dz .* temp_Ns) / sum(farm.dz .* temp_Nf));
 kelp.B = kelp.Nf ./ param.Qmin; % grams-dry m-3
 
 %----------------------------------------------------------------------
 % Defines surface-area to biomass conversion (depth resolved)
 % sa2b [m2/g(wet)]
 % Note: canopy forming has more surface area in canopy
 % Two cases:
 % (1) Canopy is present: uses two conversion factors:
 %     - surface area of canopy
 %     - surface area of plant below the canopy
 % (2) Canopy not present, all plant submerged
 %     - surface area of submerged plant
 % DB : Based on the following there is an abrupt discontinuity
 %      in sa2b as soon as the plant reaches canopy height. 
 %      To-do: change to a continuous transition.
 % DB : Note: in the following "-farm.canopy" has been changed to "param.z_canopy"
 %      to consistently use the canopy thickness from kelp parameters
 kelp.sa2b = NaN(farm.nz,1);
 if any(kelp.Nf(farm.z_arr > param.z_canopy) > 0)
    % (1) Canopy is present: uses two conversion factors 
    kelp.sa2b(farm.z_arr >= param.z_canopy) = param.Biomass_surfacearea_canopy;
    kelp.sa2b(farm.z_arr < param.z_canopy)  = param.Biomass_surfacearea_watercolumn;
 else
    % (2) Canopy not present, all plant submerged
    kelp.sa2b(1:farm.nz) = param.Biomass_surfacearea_subsurface;
 end
 
 % First set NaN values to zeros in the temporary array temp_B
 % temp_B = biomass (B) with NaNs set to 0
 temp_B = nan2zero(kelp.B);
 tmp = sum(farm.dz .* temp_B)/1e3;
 kelp.height = param.Hmax * tmp / (param.Kh + tmp);
 clear tmp
 
 %----------------------------------------------------------------------
 % Blade to Stipe for blade-specific parameters
 % Note: B:S is defined along the normalized length of the plant.
 % Here, for the canopy layer, takes the average B:S of the canopy
 % forming plant segment. 
 % Generate a fractional height
 % Max plant lenght = kelp.height (positive, length)
 % Cultivation starts at farm.z_cult (negative, depth below surface)
 % Note: both farm.z_arr and farm.z_cult are negative depths
 z_frac = (farm.z_arr - farm.z_cult) / kelp.height;
 % Uses empirical relationship with fractional height
 % Note that for ALL canopy forming layers, uses analytical
 % average over the kelp canopy fractional length 
 BtoS = param.Blade_stipe(1) - ...
        param.Blade_stipe(2) .* z_frac + ...
        param.Blade_stipe(3) .* z_frac.^ 2;
 zf0 = z_frac(farm.icanopy);
 zf1 = 1;
 BtoS_canopy = param.Blade_stipe(1) - ...
               1/2*param.Blade_stipe(2) .* (zf1+zf0) + ...
               1/3*param.Blade_stipe(3) .* (zf1^2+zf1*zf0+zf0^2); 
 BtoS(farm.icanopy:end) = BtoS_canopy;
 
 kelp.frBlade = BtoS ./ (BtoS + 1);
     
 %----------------------------------------------------------------------
 % biomass per m (for growth)
 % (shape function (## UNITS ###)
 kelp.b_per_m = make_Bm(kelp.height,param,farm);

end
