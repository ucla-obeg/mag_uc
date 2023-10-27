function [Bm_out] = make_Bm(Hp,param,farm) 
%----------------------------------------------------------------------
% Create analytical form of biomass per meter (Bm)
% that are normalized so they integrate to 1
% Bm(z) depends on kelp height and a canopy threshold
% Hp : height of the plant (m)
%----------------------------------------------------------------------

 % Declare an empty b_per_m array
 Bm = NaN(farm.nz,1);

 % Here, defines different canopy shapes, based on "Bmmode" input mode

 switch param.Bmmode
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'original'}
    alpha = 2; %scale of vertical transition from subsurface to canopy
    height_plant = Hp;
    % Get depth of top of the plant in water column
    z_p = farm.z_cult + height_plant;
    % Check if z_p exceeds surface
    if z_p>0
       z_p = 0;
    end
 
    %Create Bm
 
    %Subsurface Case
    if z_p < param.z_canopy
           for k=1:length(Bm)
           %this first if is not necessary in matlab code 
           % b/c depths do not go below farm itself
           if farm.z_arr(k)<farm.z_cult
              Bm(k) = 0;
           %In farm, below plant height
           elseif farm.z_arr(k)<=z_p
              Bm(k) = farm.z_arr(k)^2;
           %In farm, above plant height
           else
              Bm(k) = 0;
           end
       end
    end
 
    %Canopy Case
    if z_p>=param.z_canopy
       for k=1:length(Bm)
           % this first if is not necessary in matlab code 
           % b/c depths do not go below farm itself
           if farm.z_arr(k)<farm.z_cult
              Bm(k) = 0;
           else
               Bm(k) = (1 / abs(farm.z_cult)) + exp((farm.z_arr(k) - param.z_canopy)/alpha);
           end
           %Not in canopy
           %elseif farm.z_arr(k)<=param.z_canopy
           %   Bm(k) = param.B0;
           %In canopy
           %else
           %   Bm(k) = exp(farm.z_arr(k));
           %end
       end
    end
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'powerlaw'}
    amass = param.amass; % Input parameter: exponent controlling biomass shape as
                         % a function of normalized plant length
    
    % Depth array starting at the base of the plant and ending 
    % at ocean surface. 
    % Note: both z_arr and z_cult are negative depths (below the surface)
    zloc = farm.z_arr - farm.z_cult;
    % Top of water column starting from z_cult
    ztop = 0 - farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = param.Hc;
   
    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    % Case in which plant is completely submerged 
    Bm = (amass+1)/Hp * (zloc/Hp).^amass;
   
    % Add excess biomass re-distributed exponentially
    % with scale dictated by canopy thickenss
    if Hp>ztop 
       % Note: exponential is just an approximation, assuming Hc<<ztop;
       %       normalization takes care of any residual error
       Bm_exc = (1-(ztop/Hp)^(amass+1)) * exp((zloc-ztop)/Hc) / Hc;
       Bm = Bm + Bm_exc;
    end
    Bm = Bm .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'ddauhajre'}
    % Should move the following to input parameters
    z0 = -0.5;
    B0 = 0.25;
    a = 0.2;
    b = 0.7;
   
    % Depth array starting at the base of the plant and ending 
    % at ocean surface
    zloc = farm.z_arr - farm.z_cult;

    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    zreal = farm.z_arr;
   
    % Case in which plant is completely submerged 
    Bm = B0 + a * exp(-(farm.z_cult+zreal)) + b * exp((zreal-z0)/abs(z0));
   
    Bm = Bm .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'constant'}
    % Depth array starting at the base of the plant and ending 
    % at ocean surface
    zloc = farm.z_arr - farm.z_cult;
    % Top of water column starting from z_cult
    ztop = 0 - farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = param.Hc;
   
    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    Bm = 1 .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'inverse_linear'}
    % Depth array starting at the base of the plant and ending 
    % at ocean surface. 
    % Note: both z_arr and z_cult are negative depths (below the surface)
    zloc = farm.z_arr - farm.z_cult;
    % Top of water column starting from z_cult
    ztop = 0 - farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = param.Hc;
 
    % Define depth normalized by plant height
    zz = zloc/Hp;
 
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
 
    % Case in which plant is completely submerged 
    Bm = 2/Hp * (1-zloc/Hp);
 
    % Add excess biomass re-distributed exponentially
    % with scale dictated by canopy thickenss
    if Hp>ztop
       Bm_exc_tot = 1 - (2*ztop/Hp - (ztop/Hp)^2);
       % Note: exponential is just an approximation, assuming Hc<<ztop;
       %       normalization takes care of any residual error
       Bm_exc = Bm_exc_tot * exp((zloc-ztop)/Hc) / Hc;
       Bm = Bm + Bm_exc;
    end
    Bm = Bm .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'inverse_linear_plus'}
    % Depth array starting at the base of the plant and ending 
    % at ocean surface. 
    % Note: both z_arr and z_cult are negative depths (below the surface)
    zloc = farm.z_arr - farm.z_cult;
    % Top of water column starting from z_cult
    ztop = 0 - farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = param.Hc;
 
    % Define depth normalized by plant height
    zz = zloc/Hp;
 
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;

    % Defines the fraction of plant excess (Hp-ztop) relative
    % to the maximum possible plant excess (Hmax-ztop)
    if Hp<=ztop
       fexc = 0;
    else
       fexc = (Hp-ztop) ./ (param.Hmax-ztop);
    end

    % Here uses the plant excess to boost the % of plant in canopy
    % Based on observations compiled by C. Frieder that suggest a
    % linear increase of biomass fraction in canopy from 0% to 50%
    % as fexc goes from 0 to 1
    fcan = param.cmax * fexc;
    
    % Baseline profile, considering the excess redistribution potential
    Bm_noc = (2/Hp * (1-zloc/Hp)) * (1-fcan);

    % No-canopy section (linear), biomass function integral
    I_noc = (2*ztop/Hp - (ztop/Hp)^2) * (1-fcan);
    % Canopy section (exponential), biomass function integral 
    I_can = 1 - I_noc;

    % Canopy forming section is an exponential with scale Hc
    Bm_can = I_can/(Hc*(1-exp(-ztop))) * exp((zloc-ztop)/Hc);

    % Shape is given by sum of no-canopy (linear) and canopy (exponential)
    Bm = Bm_noc + Bm_can;
  
    % Important: mask removes non-pysical values above plant height
    Bm = Bm .* zmask;

 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 otherwise
    error('[make_Bm.m]: Bmmode not found');
 end

 % Final step of normalization; this is technically not needed analytically
 % but in practice it corrects errors due to numerical approximations 
 Bm_out = Bm ./ sum(Bm .* farm.dz); 


