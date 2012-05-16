%% Display parameters for the plots
font_size = 18;
linewidth = 2;

%% Scanning parameters
M = 256;     % samples per scan
d = 10;      % spin density, in arbitrary units
sigma_N = 1; % noise standard deviation, in arbitrary units

%% Range of linewidths suitable for tissue oximetry with a LiNc-BuO probe
Gamma_min = 0.356; %  0 mmHg O2
Gamma_max = 0.564; % 30 mmHg O2
Gamma = linspace(Gamma_min, Gamma_max, 200); % in Gauss

%% Predicted results for single-scan, traditional
single_scan_traditional.B_m     = 1.83; % modulation amplitude, in Gauss
single_scan_traditional.Delta_B = 8.46; % sweep width, in Gauss
single_scan_traditional.scans   = 1;    % number of scans
single_scan_traditional.predicted_std = zeros(size(Gamma));
for i=1:length(Gamma)
	single_scan_traditional.predicted_std(i) = ...
		sqrt(crlb_on_var(...
			[single_scan_traditional.B_m; single_scan_traditional.Delta_B], ...
			single_scan_traditional.scans, d, Gamma(i), sigma_N, M ...
		));
end

%% Predicted results for single-scan, optimized
single_scan_optimized.B_m     = 1.90; % modulation amplitude, in Gauss
single_scan_optimized.Delta_B = 3.84; % sweep width, in Gauss
single_scan_optimized.scans   = 1;    % number of scans
single_scan_optimized.predicted_std = zeros(size(Gamma));
for i=1:length(Gamma)
	single_scan_optimized.predicted_std(i) = ...
		sqrt(crlb_on_var( ...
			[single_scan_optimized.B_m; single_scan_optimized.Delta_B], ...
			single_scan_optimized.scans, d, Gamma(i), sigma_N, M ...
		));
end

%% Predicted results for dual-scan, optimized, with equal time for each scan
dual_scan_optimized.B_m     = [0.74 3.96]; % modulation amplitudes, in Gauss
dual_scan_optimized.Delta_B = [1.65 5.56]; % sweep widths, in Gauss
dual_scan_optimized.scans   = 2;           % number of scans
dual_scan_optimized.predicted_std = zeros(size(Gamma));
for i=1:length(Gamma)
	dual_scan_optimized.predicted_std(i) = ...
		sqrt(crlb_on_var( ...
			[dual_scan_optimized.B_m; dual_scan_optimized.Delta_B], ...
			dual_scan_optimized.scans, d, Gamma(i), sigma_N, M ...
		));
end

%% Predicted results for three scans, optimized, with equal time for each scan
three_scans_optimized.B_m     = [0.78 4.43  9.66]; % modulation amplitudes
three_scans_optimized.Delta_B = [1.62 6.27 16.50]; % sweep widths, in Gauss
three_scans_optimized.scans   = 3;                 % number of scans
three_scans_optimized.predicted_std = zeros(size(Gamma));
for i=1:length(Gamma)
	three_scans_optimized.predicted_std(i) = ...
		sqrt(crlb_on_var( ...
			[three_scans_optimized.B_m; three_scans_optimized.Delta_B], ...
			three_scans_optimized.scans, d, Gamma(i), sigma_N, M ...
		));
end

%% New figure window
figure();

%% One plot with all four curves
hold('on');
plot(Gamma, single_scan_traditional.predicted_std, ...
	'r--', 'Linewidth', linewidth);
plot(Gamma, single_scan_optimized.predicted_std, ...
	'r-', 'Linewidth', linewidth);
plot(Gamma, dual_scan_optimized.predicted_std, ...
	'b-', 'Linewidth', linewidth);
plot(Gamma, three_scans_optimized.predicted_std, ...
	'g-', 'Linewidth', linewidth);
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
xlim([min(Gamma) max(Gamma)]);
ylim([0 1.5*max(single_scan_traditional.predicted_std)]);
xlabel('\Gamma (G)');
ylabel('\Gamma std. (G)'); % add a hat above Gamma in post-processing
legend( ...
	'A) Single-scan, traditional', ...
	'B) Single-scan, optimized', ...
	'C) Dual-scan, T_1 = T_2, optimized', ...
	'D) Three scans, T_1 = T_2 = T_3, optimized', ...
	'Location', 'Northwest');

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);
