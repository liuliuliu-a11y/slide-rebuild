function plot_soc(outputDir)
%PLOT_SOC Reproduce the fictional SOC plot used in the public example.
% Edit data.json, then call plot_soc to regenerate SVG and 300 dpi PNG.
% The exported graph is an independent image in PowerPoint, not a native chart.
if nargin < 1
    outputDir = fileparts(mfilename('fullpath'));
end
sourceDir = fileparts(mfilename('fullpath'));
data = jsondecode(fileread(fullfile(sourceDir, 'data.json')));
if ~exist(outputDir, 'dir'), mkdir(outputDir); end
x = 0:4:20;
y = 100 * data.soc_series(:)';
assert(numel(y) == numel(x) && all(y >= 0 & y <= 100));
fig = figure('Visible','off','Color','white','Units','inches', ...
    'Position',[1 1 6.5 2.73], 'PaperUnits','inches', ...
    'PaperPosition',[0 0 6.5 2.73], 'PaperSize',[6.5 2.73]);
cleanup = onCleanup(@() close(fig));
ax = axes(fig,'Position',[0.135 0.18 0.83 0.74]);
plot(ax,x,y,'-o','Color',[7 140 149]/255,'LineWidth',1.8, ...
    'MarkerFaceColor',[7 140 149]/255,'MarkerSize',6);
hold(ax,'on');
plot(ax,x(4),y(4),'o','Color',[239 147 29]/255, ...
    'MarkerFaceColor',[239 147 29]/255,'MarkerSize',7);
ax.FontName = 'Microsoft YaHei'; ax.FontSize = 12;
ax.XLim = [-0.7 20.7]; ax.YLim = [0 100];
ax.XTick = x; ax.XTickLabel = data.times;
ax.YTick = [0 50 100]; ax.YTickLabel = {'0%','50%','100%'};
ax.Box = 'off'; ax.TickDir = 'out'; ax.TickLength = [0.005 0.005];
ax.XColor = [22 50 79]/255; ax.YColor = [22 50 79]/255;
ax.XGrid = 'on'; ax.YGrid = 'on'; ax.GridLineStyle = '--';
ax.GridColor = [0.6 0.7 0.78]; ax.GridAlpha = 0.35;
for k=1:numel(x)
    labelColor=[22 50 79]/255;
    if k==4, labelColor=[239 147 29]/255; end
    text(ax,x(k),y(k)+5,sprintf('%g%%',y(k)), ...
        'HorizontalAlignment','center','VerticalAlignment','bottom', ...
        'FontName','Microsoft YaHei','FontSize',11,'Color',labelColor);
end
print(fig,fullfile(outputDir,'soc-curve.png'),'-dpng','-r300');
print(fig,fullfile(outputDir,'soc-curve.svg'),'-dsvg','-painters');
fprintf('Exported fictional SOC plot: %s\n',outputDir);
end
