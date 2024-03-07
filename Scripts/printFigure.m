%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Written by: Rafael Heeb                                               %
% Contact: rafael.heeb@bristol.ac.uk                                    %
% Version: v2.230209                                                    %
% Documentation: gatorcell.rmhaerospace.com                             %
% (c)2023 by RMH Aerospace                                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% CHANGELOG
% v1.230209: - Initial version
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% SKRIPT
function printFigure(fig,name,Options)
    dir_name = "FIGURES";
    if isempty(dir(dir_name))
        mkdir(dir_name);
    end
    if ~exist("Options","var")
        Options.pdf.PrintMethod = "Matlab";
    end
    name_pdf = sprintf("%s/%s.pdf",dir_name,name);
    name_eps = sprintf("%s/%s.eps",dir_name,name);
    name_svg = sprintf("%s/%s.svg",dir_name,name);
    name_fig = sprintf("%s/%s.fig",dir_name,name);
    savefig(name_fig);  
    print(fig,name_eps,'-vector','-depsc2','-r0');
    print(fig,name_svg,'-vector','-dsvg','-r0');
    if Options.pdf.PrintMethod == "MikTex"
        system(sprintf('epstopdf %s --outfile %s',name_eps,name_pdf));
    elseif Options.pdf.PrintMethod == "Matlab"
        set(fig,'Units','Inches');
        pos = get(fig,'Position');
        set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
        print(fig,name_pdf,'-vector','-dpdf','-r0');
    else
        warning("Option.pdf.PrintMethod %s is not an option. It must either be " + ...
            "Matlab or MikTex.");
    end
end