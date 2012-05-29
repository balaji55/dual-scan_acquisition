%% Display parameters for the plots
font_size = 18;
linewidth = 2;

%% Scanning parameters
M = 256;           % samples per scan
d = 10;            % spin density, in arbitrary units
sigma_N = 1;       % noise standard deviation, in arbitrary units
Gamma_steps = 100; % how many linewidths to try across the ranges

%% Range of linewidths suitable for tumor oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
tumor.Gamma_min = 0.356; %  0 mmHg O2
tumor.Gamma_max = 0.460; % 15 mmHg O2
tumor.Gamma = linspace(tumor.Gamma_min, tumor.Gamma_max, Gamma_steps);

%% Tumor oximetry, using optimized parameters for dual-scan
tumor.optim.B_m     = [0.65 3.17]; % modulation amplitudes, in Gauss
tumor.optim.Delta_B = [1.38 4.68]; % sweep widths, in Gauss
tumor.optim.scans   = 2;           % number of scans
tumor.optim.predicted = zeros(size(tumor.Gamma));
for i=1:length(tumor.Gamma)
	tumor.optim.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[tumor.optim.B_m; tumor.optim.Delta_B], ...
			tumor.optim.scans, d, tumor.Gamma(i), sigma_N, M ...
	));
end

%% Tumor oximetry, using guideline parameters for dual-scan
tumor.guide.B_m     = [1.22 6.46]*tumor.Gamma_max; % modulation amplitudes
tumor.guide.Delta_B = [2.74 8.99]*tumor.Gamma_max; % sweep widths, in Gauss
tumor.guide.scans   = 2;                           % number of scans
tumor.guide.predicted = zeros(size(tumor.Gamma));
for i=1:length(tumor.Gamma)
	tumor.guide.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[tumor.guide.B_m; tumor.guide.Delta_B], ...
			tumor.guide.scans, d, tumor.Gamma(i), sigma_N, M ...
	));
end

%% Average across the range
tumor.optim.mean_std = mean(tumor.optim.predicted);
tumor.guide.mean_std = mean(tumor.guide.predicted);

%% Range of linewidths suitable for tissue oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
tissue.Gamma_min = 0.356; %  0 mmHg O2
tissue.Gamma_max = 0.564; % 30 mmHg O2
tissue.Gamma = linspace(tissue.Gamma_min, tissue.Gamma_max, Gamma_steps);

%% Tissue oximetry, using optimized parameters for dual-scan
tissue.optim.B_m     = [0.74 3.96]; % modulation amplitudes, in Gauss
tissue.optim.Delta_B = [1.65 5.56]; % sweep widths, in Gauss
tissue.optim.scans   = 2;           % number of scans
tissue.optim.predicted = zeros(size(tissue.Gamma));
for i=1:length(tissue.Gamma)
	tissue.optim.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[tissue.optim.B_m; tissue.optim.Delta_B], ...
			tissue.optim.scans, d, tissue.Gamma(i), sigma_N, M ...
	));
end

%% Tissue oximetry, using guideline parameters for dual-scan
tissue.guide.B_m     = [1.22 6.46]*tissue.Gamma_max; % modulation amplitudes
tissue.guide.Delta_B = [2.74 8.99]*tissue.Gamma_max; % sweep widths, in Gauss
tissue.guide.scans   = 2;                            % number of scans
tissue.guide.predicted = zeros(size(tissue.Gamma));
for i=1:length(tissue.Gamma)
	tissue.guide.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[tissue.guide.B_m; tissue.guide.Delta_B], ...
			tissue.guide.scans, d, tissue.Gamma(i), sigma_N, M ...
	));
end

%% Average across the range
tissue.optim.mean_std = mean(tissue.optim.predicted);
tissue.guide.mean_std = mean(tissue.guide.predicted);

%% Range of linewidths suitable for broad-range oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
broad.Gamma_min = 0.356; %   0 mmHg O2
broad.Gamma_max = 1.465; % 160 mmHg O2
broad.Gamma = linspace(broad.Gamma_min, broad.Gamma_max, Gamma_steps);

%% Broad-range oximetry, using optimized parameters for dual-scan
broad.optim.B_m     = [1.78  9.50]; % modulation amplitudes, in Gauss
broad.optim.Delta_B = [4.14 13.36]; % sweep widths, in Gauss
broad.optim.scans   = 2;            % number of scans
broad.optim.predicted = zeros(size(broad.Gamma));
for i=1:length(broad.Gamma)
	broad.optim.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[broad.optim.B_m; broad.optim.Delta_B], ...
			broad.optim.scans, d, broad.Gamma(i), sigma_N, M ...
	));
end

%% Broad-range oximetry, using guideline parameters for dual-scan
broad.guide.B_m     = [1.22 6.46]*broad.Gamma_max; % modulation amplitudes
broad.guide.Delta_B = [2.74 8.99]*broad.Gamma_max; % sweep widths, in Gauss
broad.guide.scans   = 2;                           % number of scans
broad.guide.predicted = zeros(size(broad.Gamma));
for i=1:length(broad.Gamma)
	broad.guide.predicted(i) = ...
		sqrt(crlb_on_var( ...
			[broad.guide.B_m; broad.guide.Delta_B], ...
			broad.guide.scans, d, broad.Gamma(i), sigma_N, M ...
	));
end

%% Average across the range
broad.optim.mean_std = mean(broad.optim.predicted);
broad.guide.mean_std = mean(broad.guide.predicted);

%% New figure window
figure();

%% One plot with six bars
bar([
	 tumor.optim.mean_std  tumor.guide.mean_std;
	tissue.optim.mean_std tissue.guide.mean_std;
	 broad.optim.mean_std  broad.guide.mean_std;
]);
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
set(gca(), 'Xticklabel', {});
xlim([0.5 3.5]);
ylabel('Mean \Gamma std. (G)'); % add a hat above Gamma in post-processing
legend('Optimized', 'Guidelines', 'Location', 'Northwest');
line([1.5 1.5], ylim(), 'Linewidth', linewidth, ...
	'Linestyle', '-', 'Color', 'black');
line([2.5 2.5], ylim(), 'Linewidth', linewidth, ...
	'Linestyle', '-', 'Color', 'black');
brighten(1); % brighten colors

% This will need cleaned up in post-processing
my_axis = axis();
text(0.5, my_axis(4)*1.04, '0-15 mmHg', 'Fontsize', font_size);
text(1.5, my_axis(4)*1.04, '0-30 mmHg', 'Fontsize', font_size);
text(2.5, my_axis(4)*1.04, '0-160 mmHg', 'Fontsize', font_size);

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);
