%% Plotting spatially indexed EBSD data
% How to visualize EBSD data
%
%% Open in Editor
%
%%
% This section gives you an overview of the functionality MTEX offers to
% visualize spatial orientation data.
%
%% Contents
%

%% Phase Plots
% Let us first import some EBSD data with a [[matlab:edit mtexdata, script file]]

close all; plotx2east
mtexdata forsterite
csFo = ebsd('Forsterite').CS

%%
% By default, MTEX plots a phase map for EBSD data.

plot(ebsd)

%%
% You can access the color of each phase by

ebsd('Diopside').color

%%
% These values are RGB values, e.g. to make the color for diopside even
% more red we can do

ebsd('Diopside').color = [1 0 0];

plot(ebsd('indexed'))

%%
% By default, not indexed phases are plotted as white. To directly specify 
% a color for some EBSD data use the option |FaceColor|.

hold on
plot(ebsd('notIndexed'),'FaceColor','black')
hold off

%% Visualizing arbitrary properties
% Apart from the phase information, we can use any other property to
% colorize the EBSD data. As an example, we may plot the band contrast

plot(ebsd,ebsd.bc)

colormap gray % this makes the image grayscale

mtexColorbar

%% Visualizing orientations
% Actually, we can pass any list of numbers or colors as a second input
% argument to be visualized together with the ebsd data. In order to
% visualize orientations in an EBSD map, we have first to compute a
% color for each orientation. The most simple way is to assign to each
% orientation its rotational angle. This is done by the command

plot(ebsd('Forsterite'),ebsd('Forsterite').orientations.angle./degree)
mtexColorbar

%%
% Let's make things a bit more formal. Therefore we define first an
% orientation mapping that assigns to each orientation its rotational
% angle

oM = angleOrientationMapping(ebsd('Fo'))

%%
% now the color, which is actually the rotational angle, is computed by the
% command

color = oM.orientation2color(ebsd('Fo').orientations);

%%
% and we can visualize it by
plot(ebsd('Forsterite'),color)
mtexColorbar

%%
% While for the previous case this seems to be unnecessarily complicated it
% allows us to define the arbitrary complex color mapping. Consider for example
% the following standard color mapping that uses a colorization of the
% fundamental sector in the inverse pole figure to assign a color to each
% orientation

% this defines a color mapping for the Forsterite phase
oM = ipdfHSVOrientationMapping(ebsd('Forsterite'))

% this is the colored fundamental sector
plot(oM)

%%
% Now we can proceed as above

% compute the colors
color = oM.orientation2color(ebsd('Fo').orientations);

% plot the colors
close all
plot(ebsd('Forsterite'),color)

%%
% Orientation mappings usually provide several options to alter the
% alignment of colors. Let's give some examples

% we may interchange green and blue by setting
oM.colorPostRotation = reflection(yvector);

plot(oM)

%%
% or cycle of colors red, green, blue by
oM.colorPostRotation = rotation('axis',zvector,'angle',120*degree);

plot(oM)

%%
% Furthermore, we can explicitly set the inverse pole figure directions by

oM.inversePoleFigureDirection = zvector;

% compute the colors again
color = oM.orientation2color(ebsd('Forsterite').orientations);

% and plot them
close all
plot(ebsd('Forsterite'),color)


%%
% Besides the recommended orientation mapping,
% <ipdfHSVOrientationMapping.html ipdfHSVOrientationMapping> MTEX supports
% also a lot of other color mappings as summarized below
%
% * <TSLOrientationMapping.html TSLOrientationMapping>
% * <HKLOrientationMapping.html HKLOrientationMapping>
% * <BungeRGBOrientationMapping.html BungeRGBOrientationMapping>
% * <patalaOrientationMapping.html patalaOrientationMapping>
% * <axisAngleOrientationMapping.html axisAngleOrientationMapping>
%
%
%% Customizing the color
% In some cases, it might be useful to color certain orientations after
% one needs. This can be done in two ways, either to color a certain fibre
% or a certain orientation.

%% SUB: Coloring certain fibres
% To color a fibre, one has to specify the crystal direction *h* together
% with its RGB color and the specimen direction *r*, which should be marked.

% define a fibre
f = fibre(Miller(1,1,1,csFo),zvector);

% set up coloring
oM = ipdfCenterOrientationMapping(csFo);
oM.inversePoleFigureDirection = f.r;
oM.center = f.h;
oM.color = [0 0 1];
oM.psi = deLaValeePoussinKernel('halfwidth',7.5*degree);

plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations))

%%
% the option |halfwidth| controls half of the intensity of the color at a
% given distance. Here we have chosen the (111)[001] fibre to be drawn in blue,
% and at 7.5 degrees, where the blue should be only lighter.

plot(oM)
hold on
circle(f.h.project2FundamentalRegion,15*degree,'linewidth',2)

%%
% the percentage of blue colored area in the map is equivalent to the fibre
% volume

vol = volume(ebsd('fo').orientations,f,15*degree)

plotIPDF(ebsd('fo').orientations,zvector,'markercolor','k','marker','x','points',200)
hold off

%%
% we can easily extend the colorcoding

oM.center = [Miller(0,0,1,csFo),Miller(0,1,1,csFo),Miller(1,1,1,csFo),...
  Miller(11,4,4,csFo), Miller(5,0,2,csFo) , Miller(5,5,2,csFo)]

oM.color = [[1 0 0];[0 1 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];

close all;
plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations))

%%

plot(oM,'complete')

%% SUB: Coloring certain orientations
% We might be interested in locating some special orientation in our
% orientation map. The definition of colors for certain orientations is
% carried out similarly as in the case of fibres

oM = centerOrientationMapping(ebsd('Fo'));
oM.center = mean(ebsd('Forsterite').orientations,'robust');
oM.color = [0,0,1];
oM.psi = deLaValeePoussinKernel('halfwidth',20*degree);

plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations))

% and the correspoding colormap
figure(2)
plot(oM,'sections',9,'sigma')

%%
% the area of the colored EBSD data in the map corresponds to the volume
% portion (in percent)

vol = 100 * volume(ebsd('fo').orientations,oM.center,20*degree)

%%
% actually, the colored measurements stress a peak in the ODF

close all
odf = calcODF(ebsd('fo').orientations,'halfwidth',10*degree,'silent');
plot(odf,'sections',9,'silent','sigma')
mtexColorbar


%% Combining different plots
% Combining different plots can be done either by plotting only subsets of
% the EBSD data or via the option |'faceAlpha'|. Note that the option
% |'faceAlpha'| requires the renderer of the figure to be set to
% |'opengl'|.

close all;
plot(ebsd,ebsd.bc)
mtexColorMap white2black

oM = ipdfCenterOrientationMapping(csFo);
oM.inversePoleFigureDirection = zvector;
oM.center = Miller(1,1,1,csFo);
oM.color = [0 0 1];
oM.psi = deLaValeePoussinKernel('halfwidth',7.5*degree);

hold on
plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations),'FaceAlpha',0.5)
hold off

%%
% another example

close all;
plot(ebsd,ebsd.bc)
mtexColorMap black2white

hold on
plot(ebsd('fo'),'FaceAlpha',0.5)
hold off

