function time = simtime(duration)
%----------------------------------------------------------------------
% simulation time and intervals; unit is hours
% Input: duration as a vector [start; stop]
%        start = [year month day] 
%        stop  = [year month day] 
% Output: structure containing
%   start = datevec of simulation start
%   duration of simulation (hours)
%   dt_Gr = time step for growth (hours)
%   dt_ROMS = time step of environmental input
%   timevec is in matlab datenum format
%----------------------------------------------------------------------

 time.start      = duration(1,:);
 time.end        = duration(2,:);
 % Run duration in hiours = #days * (hours/day) (need to add 1 to have a full day even when date is the same)
 time.duration   = (datenum(duration(2,:))-datenum(duration(1,:)) + 1) * 24;
 time.dt_Gr      = 24; % solve growth every X hours
 time.dt_ROMS    = 24; % based on extracted ROMS files
  
 time.timevec_Gr =   [datenum(time.start) : time.dt_Gr/24   : datenum(time.start)+time.duration/24-1/24];
 time.timevec_ROMS = [datenum(time.start) : time.dt_ROMS/24 : datenum(time.start)+time.duration/24-1/24];

 % Number of timesteps
 time.ndt = length(time.timevec_Gr);
    
end  
