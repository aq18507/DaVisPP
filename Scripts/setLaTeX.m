function setLaTeX(FontSize)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v1.230209                                                    %
% Documentation: gatorcell.rmhaerospace.com                             %
% (c)2023 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.230209: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
set(findall(gcf,'-property','FontSize'),'FontSize',FontSize)
set(0,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
end