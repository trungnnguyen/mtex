function q = maxpdf( odf,h, varargin)
% returns the maximum orientation in a polefigure
%
%% Input
% @ODF - an odf
% @Miller - a crystal direction
%
%%
%

argin_check(h,'Miller');
h = ensureCS(odf(1).CS,{h});

for k=1:numel(h)
  
  res = 5*degree;
  
  % try to find the maximum value for P(h,r)
  S2 = S2Grid('equispaced','resolution',res);
  
  while res/2 > 0.25*degree
    
    res = res/2;
    f = pdf(odf,h(k),S2);
    
    [a, i] = max(f);
    
    %local search
    v = vector3d(S2(i));
    S2 = hr2quat(zvector,v)*S2Grid('equispaced','maxtheta',4*res,'resolution',res);
    
  end
  
  % choose the maximum density of the fibre G(h,r)
  g = fibre2quat(h(k),v,'resolution',0.25*degree);
  f = eval(odf,g);
  
  [a, i] = max(f);
  q(k) = g(i);
  
end
