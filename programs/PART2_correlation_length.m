%% --- Clear workspace ---
clc;
clear;
addpath("functions/");

%% --- Common setup ---
% Define any quantity you need for this part in here
params.fileName = "veldata.txt";
params.samplingFreq = 20e3;
params.L = 5;
params.plot.fontSize = 14;
params.plot.legendFontSize = 12;
params.plot.insetFontSize = 10;
params.plot.lw = 1.5;
params.plot.lwsmall = 1.2;

[u, U] = load_data(params.fileName, Inf);

params.t = (1:length(u))/params.samplingFreq;
params.U = U;
params.x = params.U*params.t;

%% --- Correlation length ---
dl = params.x(2) - params.x(1); % Distance between two measurements, constant.

lmax_autocorr = 1000;
Cl = autocorrelation(u, dl, lmax_autocorr);

% Length vectors
l = 0:dl:(dl*(length(Cl) - 1));

% Find intersections
Lc_idx = find(Cl < 1/exp(1),1);
params.Lc = l(Lc_idx);

fprintf("Correlation length Lc: %0.4f m \n", params.Lc)

%% --- Plot B ---
lmax_plot = params.L;
lmax_idx = find(l >= lmax_plot, 1);
if isempty(lmax_idx)
    lmax_idx = length(l);
end

plotB = figure();
hold on; grid on;
plot(l(1:lmax_idx), Cl(1:lmax_idx), 'LineWidth', params.plot.lw);
xlim([0,lmax_plot])

xlabel('$l\;[m]$', 'Interpreter', 'latex', 'FontSize', params.plot.fontSize);
ylabel('$C(l)$', 'Interpreter', 'latex', 'FontSize', params.plot.fontSize);

xline(params.Lc, ...
     'Interpreter', 'latex', 'fontsize', params.plot.insetFontSize, ...
     'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');

saveas(plotB, 'figures/part1-plotB.png')

%% --- Integral scale ---

params.Lint = trapz(l,Cl); % TO FIX

fprintf("Integral scale Lint: %0.4f m \n", params.Lint)
