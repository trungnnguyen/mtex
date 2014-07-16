classdef orientationMapping < handle
  %ORIENTATIONMAPPING Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    CS1 = symmetry % crystal symmetry
    CS2 = symmetry % crystal symmetry of a second phase for misorientations
    colorPostRotation = rotation(idquaternion)
  end
  
  methods
    
    function oM = orientationMapping(ebsd,varargin)
      if isa(ebsd,'EBSD') || isa(ebsd,'GrainSet')
        oM.CS1 = ebsd.CS;
      elseif isa(ebsd,'symmetry')
        oM.CS1 = ebsd;
      end      
    end
            
    function plot(oM,varargin)
      % plot an color bar

      [S3G,S2G,sec] = plotSO3Grid(oM(1).CS1,oM(1).CS2,varargin{:});

      [s1,s2,s3] = size(S3G);

      d = oM.orientation2color(S3G);
      if numel(d) == length(S3G)
        rgb = 1;
        varargin = [{'smooth'},varargin];
      else
        rgb = 3;
        varargin = [{'surf'},varargin];
      end
      d = reshape(d,[s1,s2,s3,rgb]);

      sectype = get_flag(varargin,{'alpha','phi1','gamma','phi2','sigma'},'phi2');
      [symbol,labelx,labely] = sectionLabels(sectype);

      if strcmp(sectype,'sigma')
        varargin = [{'innerPlotSpacing',10},varargin];
      else
        varargin = [{'projection','plain',...
          'xAxisDirection','east','zAxisDirection','intoPlane',...
          'innerPlotSpacing',35,'outerPlotSpacing',35},varargin];
      end
      
      fprintf(['\nPlotting colormap as ',sectype,' sections, range: ',...
        xnum2str(min(sec)/degree),mtexdegchar,' - ',xnum2str(max(sec)/degree),mtexdegchar,'\n']);

      % make new plot
      mtexFig = mtexFigure(varargin{:});

      setappdata(gcf,'sections',sec);
      setappdata(gcf,'SectionType',sectype);
      
      % plot
      if check_option(varargin,{'contour3','surf3','slice3'})
  
        [x,y] = polar(S2G);

        v = get_option(varargin,{'surf3','contour3'},10,'double');
        contour3s(x(1,:)./degree,y(:,1)'./degree,sec./degree,d,v,varargin{:},...
          'xlabel',labely,'ylabel',labelx,'zlabel',['$' symbol '$']);

      else
    
        % predefines axes?
        paxes = get_option(varargin,'parent');
  
        for i = 1:length(sec)
    
          if isempty(paxes), ax = mtexFig.nextAxis; else ax = paxes(i); end
    
          S2G.plot(squeeze(d(:,:,i,:)),'TR',[int2str(sec(i)*180/pi),'^\circ'],...
            'xlabel',labelx,'ylabel',labely,...
            'colorRange',[min(d(:)),max(d(:))],'smooth',...
            'parent',ax,varargin{:});
                 
        end
  
        mtexFig.drawNow;
      end
    end        
  end
  
  methods (Abstract = true)
    c = orientation2color(oM,ori,varargin)
  end
end
