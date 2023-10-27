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
    z_p = -farm.z_cult + height_plant;
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
           if farm.z_arr(k)<-farm.z_cult
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
           if farm.z_arr(k)<-farm.z_cult
              Bm(k) = 0;
           else
               Bm(k) = (1 / farm.z_cult) + exp((farm.z_arr(k) - param.z_canopy)/alpha);
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
 case {'dbianchi'}
    amass = param.amass; % Input parameter: exponent controlling biomass shape as
                         % a function of normalized plant length
    
    % Depth array starting at the base of the plant and ending 
    % at ocean surface
    zloc = farm.z_cult + farm.z_arr;
    % Top of water column starting from z_cult
    ztop = farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = abs(param.z_canopy);
   
    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    % Case in which plant is completely submerged 
    Bm = (amass+1)/Hp * (zloc/Hp).^amass;
   
    % Add excess biomass re-distributed exponentially
    % with scale dictaded by canopy thickenss
    if Hp>ztop 
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
    zloc = farm.z_cult + farm.z_arr;
   
    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    zreal = farm.z_arr;
   
    % Case in which plant is completely submerged 
    Bm = B0 + a * exp(-(zreal-farm.z_cult)) + b * exp((zreal-z0)/abs(z0));
   
    Bm = Bm .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 case {'constant'}
    % Depth array starting at the base of the plant and ending 
    % at ocean surface
    zloc = farm.z_cult + farm.z_arr;
    % Top of water column starting from z_cult
    ztop = farm.z_cult;
    % Thickness scale for canopy (m)
    Hc = abs(param.z_canopy);
   
    % Define depth normalized by plant height
    zz = zloc/Hp;
   
    % Plant mask: 1 if plant; 0 if water
    zmask = ones(size(zz));
    zmask(zz>1) = 0;
   
    Bm = 1 .* zmask;
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 otherwise
    error('[make_Bm.m]: Bmmode not found');
 end

 % Final step of normalization; this is technically not needed analytically
 % but in practice it corrects errors due to numerical approximations 
 Bm_out = Bm ./ sum(Bm .* farm.dz); 


