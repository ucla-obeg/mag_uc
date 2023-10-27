function mprint_fig(varargin)
%-----------------------------------------------------------
% default arguments:
A.fig       = - 1;
A.sty       = 'nor';
A.name      = 'figure';
A.for       = 'jpeg';
A.verbose   = 1;
% Parse required variables, substituting defaults where necessary
A = parse_pv_pairs(A, varargin);
%-----------------------------------------------------------

if strcmp(A.for,'jpg')
   A.for = 'jpeg';
end

if strcmp(A.name,'figure')&A.fig~=-1
    A.name = ['figure' num2str(A.fig)];
end

if A.fig~=-1
   figure(A.fig);
end

if strcmp(A.sty,'nor') | strcmp(A.sty,'nor1')  
   set(gcf,'PaperPosition',[0.5 0.5 8.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor1b1') 
   set(gcf,'PaperPosition',[0.5 0.5 8.0 5.5],'Renderer','Painters');
elseif strcmp(A.sty,'nor1b2') 
   set(gcf,'PaperPosition',[0.5 0.5 8.0 4.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor1b') 
   set(gcf,'PaperPosition',[0.5 0.5 7.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor1c') 
   set(gcf,'PaperPosition',[0.5 0.5 16.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 8.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2b') 
   set(gcf,'PaperPosition',[0.5 0.5 10.0 14.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2c') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 14.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2d') 
   set(gcf,'PaperPosition',[0.5 0.5 1.5*6.0 4.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2e') 
   set(gcf,'PaperPosition',[0.5 0.5 2*6.0 4.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor2f') 
   set(gcf,'PaperPosition',[0.5 0.5 4.0 7.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor3') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 5.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor3b') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 4.5],'Renderer','Painters');
elseif strcmp(A.sty,'nor4') 
   set(gcf,'PaperPosition',[0.5 0.5 5.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor4b') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor4c') 
   set(gcf,'PaperPosition',[0.5 0.5 5.0 5.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor4d') 
   set(gcf,'PaperPosition',[0.5 0.5 4.0 4.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor4e') 
   set(gcf,'PaperPosition',[0.5 0.5 4.5 4.5],'Renderer','Painters');
elseif strcmp(A.sty,'nor5') 
   set(gcf,'PaperPosition',[0.5 0.5 4.0 3.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor6') 
   set(gcf,'PaperPosition',[0.5 0.5 3.0 4.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7') 
   set(gcf,'PaperPosition',[0.5 0.5 10.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7b') 
   set(gcf,'PaperPosition',[0.5 0.5 9.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7c') 
   set(gcf,'PaperPosition',[0.5 0.5 20.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7c1') 
   set(gcf,'PaperPosition',[0.5 0.5 16.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7c2') 
   set(gcf,'PaperPosition',[0.5 0.5 16.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7d') 
   set(gcf,'PaperPosition',[0.5 0.5 10.0 6.5],'Renderer','Painters');
elseif strcmp(A.sty,'nor7e1') 
   set(gcf,'PaperPosition',[0.5 0.5 14.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7g') 
   set(gcf,'PaperPosition',[0.5 0.5 12.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7f') 
   set(gcf,'PaperPosition',[0.5 0.5 12.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor7g') 
   set(gcf,'PaperPosition',[0.5 0.5 14.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8') 
   set(gcf,'PaperPosition',[0.5 0.5 9.0 10.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8b2') 
   set(gcf,'PaperPosition',[0.5 0.5 7.0 7.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8b') 
   set(gcf,'PaperPosition',[0.5 0.5 9.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8c') 
   set(gcf,'PaperPosition',[0.5 0.5 8.0 14.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8d') 
   set(gcf,'PaperPosition',[0.5 0.5 10.0 14.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor8e') 
   set(gcf,'PaperPosition',[0.5 0.5 12.0 14.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor9') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor10') 
   set(gcf,'PaperPosition',[0.5 0.5 15.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor11') 
   set(gcf,'PaperPosition',[0.5 0.5 9.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor12') 
   set(gcf,'PaperPosition',[0.5 0.5 11.0 9.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor13') 
   set(gcf,'PaperPosition',[0.5 0.5 9.0 12.0],'Renderer','Painters');
elseif strcmp(A.sty,'nor13b') 
   set(gcf,'PaperPosition',[0.5 0.5 12 13],'Renderer','Painters');
elseif strcmp(A.sty,'nor14') 
   set(gcf,'PaperPosition',[0.5 0.5 20.0 12.0],'Renderer','Painters');
elseif strcmp(A.sty,'sq1') 
   set(gcf,'PaperPosition',[0.5 0.5 6.0 4.8],'Renderer','Painters');
elseif strcmp(A.sty,'sq2') 
   set(gcf,'PaperPosition',[0.5 0.5 8.0 6.4],'Renderer','Painters');
elseif strcmp(A.sty,'sq3') 
   set(gcf,'PaperPosition',[0.5 0.5 12.0 10.5],'Renderer','Painters');
elseif strcmp(A.sty,'sq4') 
   set(gcf,'PaperPosition',[0.5 0.5 10.5 10.5],'Renderer','Painters');
elseif strcmp(A.sty,'pdf_land') 
   set(gcf,'PaperPosition',[0.2 3.0 8.0 6.0],'Renderer','Painters');
elseif strcmp(A.sty,'pdf_prof') 
   set(gcf,'PaperPosition',[0.0 0.0 9.0 11.5],'Renderer','Painters');
else 
  error(['invalid format']);
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if A.verbose==1;
    disp(['print -d' A.for ' ' A.name ]);
 end
 print(A.name,['-d' A.for]);

