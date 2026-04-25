%% --- Clear workspace ---
clc;
clear;
addpath("functions");

%% --- Common setup ---
% Define any quantity you need for this part in here
params.fileName = "veldata.txt";
params.samplingFreq = 20e3;
params.plot.fontSize = 14;
params.plot.legendFontSize = 12;
params.plot.insetFontSize = 10;
params.plot.lw = 1.5;
params.plot.lwsmall = 1.2;

[u, U] = load_data(params.fileName, Inf);

params.t = (1:length(u))/params.samplingFreq;

%% --- Frozen flow hypothesis ---
params.U = U;
params.x = params.U*params.t;
% Assume 5 meters of distance from grid to hotwire
params.L = 5;

fprintf("Mean velocity U: %0.4f m/s \n", params.U)

%% --- Plot A ---
plotA = figure();
hold on; grid on;
% Range of x-axis is the distance from grid to hotwire
% Window is arbitrarely taken at around halftime of the original dataset
x0 = params.x(floor(length(u))/2);
xlim([x0, x0 + params.L])
plot(params.x, u + params.U, 'LineWidth', 1);
xticks(x0:x0 + params.L);
xticklabels(0:params.L);

yline(params.U, ...
     'Interpreter', 'latex', 'fontsize', params.plot.fontSize, ...
     'LineWidth', params.plot.lw, ...
     'LabelVerticalAlignment', 'top', 'HandleVisibility', 'off', ...
     'LabelHorizontalAlignment', 'left');

xlabel('$x\;[m]$', 'Interpreter', 'latex', ...
    'FontSize', params.plot.fontSize);
ylabel('$u_\mathrm{tot}(x)\;[m/s]$', 'Interpreter', 'latex', ...
    'FontSize', params.plot.fontSize);

saveas(plotA, 'figures/part1-plotA.png')

%% --- Turbulence intensity ---
params.I = sqrt(mean(u.^2))/U;

fprintf("Turbulence intensity I: %0.4f \n", params.I)