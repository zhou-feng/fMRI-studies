function h = fillsteplot(dat, colors, linewid, linez, xrange)
% function h = fillsteplot(dat,linewid,linez,condnames,xrange,colorcycle)

%
% Plots a mean vector (mean of each column of dat)
% surrounded by a fill with standard err bars
%
% If dat has 3 dimensions, then
% the diff between dat(:,:,1) and dat(:,:,2) is
% used as the difference for computing standard err
% (as in repeated measures)
%
% if behavior is entered as optional argument, removes it before plotting
% lines.

if nargin<3 || isempty(linewid);
    linewid=2;
end
if nargin<4 || isempty(linez);
    linez='-';
end

if nargin<5;
    xrange=1:size(dat,ndims(dat));
end


if ~iscell(linez);
    for c=1:size(dat,2);
        liner{c}=linez;
    end
    linez=liner;
end


if ndims(dat)==3;
    
    
for c=1:size(dat,2);
    
    m=squeeze(nanmean(dat(:,c,:)));
    
    hold on; 
    h(c)=plot(xrange,m,'color',colors,'LineWidth',linewid,'linestyle',linez{c});
    
    d = squeeze(dat(:,c,:));
   
%    md = nanmean(d);
    fill_around_line(m,ste(d),colors,xrange);
   
end
% legend(h,condnames,'location','SouthEast');
% legend(h,condnames,'location','BestOutside');
% NorthEast');
legend boxoff;

elseif ismatrix(dat);
   m=squeeze(nanmean(dat));
    
    hold on; 
    plot(m,'color',colors,'LineWidth',2,'linestyle',linez{1});
       
%    md = nanmean(d);
    fill_around_line(m,ste(dat),colors);
end
    
    

return