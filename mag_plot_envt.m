 function mag_plot(mag,varargin)
%----------------------------------------------------------------------
% Process inputs (varargin)
A.fig = 1;	% (1) new figure; (0) current figure
A.mode = 1;	% (1) simple plot
A.layer = nan;  % NaN -- plots average over farm
A.print = 0;    % 0 to print figures as jpeg
A.fname = 'fig_mag';    % default filename, will append "envt"
A = parse_pv_pairs(A, varargin);
%----------------------------------------------------------------------
addpath additional_functions
%----------------------------------------------------------------------
 
 if A.fig==1
    figure;
 end

 envt = mag.envt;
 time = mag.time;

 % Vertical and time grids
 tday = [time.dt_Gr:time.dt_Gr:time.duration]/24;

 tt = tiledlayout('flow');
 vname = fieldnames(envt);
 % Here remove any variable not needed for plot
 vname = setdiff(vname,'PARz','stable'); 
 nvar = length(vname);
 for indv=1:nvar
    axv = nexttile;
    if ~isnan(A.layer)
       vplot = envt.(vname{indv})(A.layer,:);
    else
       vplot = mean(envt.(vname{indv}),1);
    end
    plot(tday,vplot,'-','linewidth',3)
    hold on
    tmp0 = mean(vplot,2);
    tmp1 = repmat(tmp0,[1 length(tday)]);
    plot(tday,tmp1,'r-','linewidth',3)
    title(vname{indv});
    xlim([tday(1) tday(end)]);
    ylim([min(vplot)*0.9 max(vplot)*1.1]);
    xlabel('day');
 end

 if A.print==1
    mprint_fig('name',[A.fname '_envt.jpeg'],'for','jpeg','sty','nor1');
 end

