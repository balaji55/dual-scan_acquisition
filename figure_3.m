%% Display parameters for the plots
font_size = 18;
linewidth = 2;

%% Scanning parameters
M = 256;     % samples per scan
d = 10;      % spin density, in arbitrary units
sigma_N = 1; % noise standard deviation, in arbitrary units

%% Simulation parameters
simulations = 20;     % how many simulations per value of Gamma
Gamma_steps = 10;     % how many values of Gamma to try across the range
initializations = 10; % how many initial guesses to make at Gamma while fitting

%% Range of linewidths suitable for tumor oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
tumor.Gamma_min = 0.356; %  0 mmHg O2
tumor.Gamma_max = 0.460; % 15 mmHg O2
tumor.Gamma = linspace(tumor.Gamma_min, tumor.Gamma_max, Gamma_steps);

%% Scanning parameters for tumor oximetry, optimized single-scan
tumor.single.B_m     = 1.61; % modulation amplitude, in Gauss
tumor.single.Delta_B = 3.24; % sweep width, in Gauss
tumor.single.scans   = 1;    % number of scans

%% Predicted results for tumor oximetry, optimized single-scan
tumor.single.predicted_mean_std = crlb_on_mean_std( ...
	[tumor.single.B_m; tumor.single.Delta_B], tumor.single.scans, d, ...
	sigma_N, M, tumor.Gamma_min, tumor.Gamma_max, Gamma_steps ...
);

%% Simulated results for tumor oximetry, optimized single-scan
tumor.single.simulated_std = zeros(size(tumor.Gamma)); % preallocate
for i=1:length(tumor.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(tumor.single.scans, M);
	Y = zeros(tumor.single.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:tumor.single.scans
			B(k,:) = ...
				linspace(-tumor.single.Delta_B(k)/2, ...
					tumor.single.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d tumor.Gamma(i) tumor.single.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(tumor.single.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(tumor.Gamma_min, tumor.Gamma_max, ...
				tumor.single.scans, Y, B, initializations, tumor.single.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	tumor.single.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
tumor.single.simulated_mean_std = mean(tumor.single.simulated_std);

%% Scanning parameters for tumor oximetry, optimized dual-scan
tumor.dual.B_m     = [0.65 3.17]; % modulation amplitudes, in Gauss
tumor.dual.Delta_B = [1.38 4.68]; % sweep widths, in Gauss
tumor.dual.scans   = 2;           % number of scans

%% Predicted results for tumor oximetry, optimized dual-scan
tumor.dual.predicted_mean_std = crlb_on_mean_std( ...
	[tumor.dual.B_m; tumor.dual.Delta_B], tumor.dual.scans, d, ...
	sigma_N, M, tumor.Gamma_min, tumor.Gamma_max, Gamma_steps ...
);

%% Simulated results for tumor oximetry, optimized dual-scan
tumor.dual.simulated_std = zeros(size(tumor.Gamma)); % preallocate
for i=1:length(tumor.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(tumor.dual.scans, M);
	Y = zeros(tumor.dual.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:tumor.dual.scans
			B(k,:) = ...
				linspace(-tumor.dual.Delta_B(k)/2, ...
					tumor.dual.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d tumor.Gamma(i) tumor.dual.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(tumor.dual.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(tumor.Gamma_min, tumor.Gamma_max, ...
				tumor.dual.scans, Y, B, initializations, tumor.dual.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	tumor.dual.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
tumor.dual.simulated_mean_std = mean(tumor.dual.simulated_std);

%% Range of linewidths suitable for tissue oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
tissue.Gamma_min = 0.356; %  0 mmHg O2
tissue.Gamma_max = 0.564; % 30 mmHg O2
tissue.Gamma = linspace(tissue.Gamma_min, tissue.Gamma_max, Gamma_steps);

%% Scanning parameters for tissue oximetry, optimized single-scan
tissue.single.B_m     = 1.90; % modulation amplitude, in Gauss
tissue.single.Delta_B = 3.84; % sweep width, in Gauss
tissue.single.scans   = 1;    % number of scans

%% Predicted results for tissue oximetry, optimized single-scan
tissue.single.predicted_mean_std = crlb_on_mean_std( ...
	[tissue.single.B_m; tissue.single.Delta_B], tissue.single.scans, d, ...
	sigma_N, M, tissue.Gamma_min, tissue.Gamma_max, Gamma_steps ...
);

%% Simulated results for tissue oximetry, optimized single-scan
tissue.single.simulated_std = zeros(size(tissue.Gamma)); % preallocate
for i=1:length(tissue.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(tissue.single.scans, M);
	Y = zeros(tissue.single.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:tissue.single.scans
			B(k,:) = ...
				linspace(-tissue.single.Delta_B(k)/2, ...
					tissue.single.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d tissue.Gamma(i) tissue.single.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(tissue.single.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(tissue.Gamma_min, tissue.Gamma_max, ...
				tissue.single.scans, Y, B, initializations, tissue.single.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	tissue.single.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
tissue.single.simulated_mean_std = mean(tissue.single.simulated_std);

%% Scanning parameters for tissue oximetry, optimized dual-scan
tissue.dual.B_m     = [0.74 3.96]; % modulation amplitudes, in Gauss
tissue.dual.Delta_B = [1.65 5.56]; % sweep widths, in Gauss
tissue.dual.scans   = 2;           % number of scans

%% Predicted results for tissue oximetry, optimized dual-scan
tissue.dual.predicted_mean_std = crlb_on_mean_std( ...
	[tissue.dual.B_m; tissue.dual.Delta_B], tissue.dual.scans, d, ...
	sigma_N, M, tissue.Gamma_min, tissue.Gamma_max, Gamma_steps ...
);

%% Simulated results for tissue oximetry, optimized dual-scan
tissue.dual.simulated_std = zeros(size(tissue.Gamma)); % preallocate
for i=1:length(tissue.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(tissue.dual.scans, M);
	Y = zeros(tissue.dual.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:tissue.dual.scans
			B(k,:) = ...
				linspace(-tissue.dual.Delta_B(k)/2, ...
					tissue.dual.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d tissue.Gamma(i) tissue.dual.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(tissue.dual.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(tissue.Gamma_min, tissue.Gamma_max, ...
				tissue.dual.scans, Y, B, initializations, tissue.dual.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	tissue.dual.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
tissue.dual.simulated_mean_std = mean(tissue.dual.simulated_std);

%% Range of linewidths suitable for broad-range oximetry with a LiNc-BuO probe
% These are HWHM linewidths, in Gauss
broad.Gamma_min = 0.356; %   0 mmHg O2
broad.Gamma_max = 1.465; % 160 mmHg O2
broad.Gamma = linspace(broad.Gamma_min, broad.Gamma_max, Gamma_steps);

%% Scanning parameters for broad-range oximetry, optimized single-scan
broad.single.B_m     = 4.36; % modulation amplitude, in Gauss
broad.single.Delta_B = 8.95; % sweep width, in Gauss
broad.single.scans   = 1;    % number of scans

%% Predicted results for broad-range oximetry, optimized single-scan
broad.single.predicted_mean_std = crlb_on_mean_std( ...
	[broad.single.B_m; broad.single.Delta_B], broad.single.scans, d, ...
	sigma_N, M, broad.Gamma_min, broad.Gamma_max, Gamma_steps ...
);

%% Simulated results for broad-range oximetry, optimized single-scan
broad.single.simulated_std = zeros(size(broad.Gamma)); % preallocate
for i=1:length(broad.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(broad.single.scans, M);
	Y = zeros(broad.single.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:broad.single.scans
			B(k,:) = ...
				linspace(-broad.single.Delta_B(k)/2, ...
					broad.single.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d broad.Gamma(i) broad.single.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(broad.single.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(broad.Gamma_min, broad.Gamma_max, ...
				broad.single.scans, Y, B, initializations, broad.single.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	broad.single.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
broad.single.simulated_mean_std = mean(broad.single.simulated_std);

%% Scanning parameters for broad-range oximetry, optimized dual-scan
broad.dual.B_m     = [1.78  9.50]; % modulation amplitudes, in Gauss
broad.dual.Delta_B = [4.14 13.36]; % sweep widths, in Gauss
broad.dual.scans   = 2;            % number of scans

%% Predicted results for broad-range oximetry, optimized dual-scan
broad.dual.predicted_mean_std = crlb_on_mean_std( ...
	[broad.dual.B_m; broad.dual.Delta_B], broad.dual.scans, d, ...
	sigma_N, M, broad.Gamma_min, broad.Gamma_max, Gamma_steps ...
);

%% Simulated results for broad-range oximetry, optimized dual-scan
broad.dual.simulated_std = zeros(size(broad.Gamma)); % preallocate
for i=1:length(broad.Gamma)

	% Preallocate
	Gamma_hat = zeros(1, simulations);
	B = zeros(broad.dual.scans, M);
	Y = zeros(broad.dual.scans, M);

	for j=1:simulations

		% Create noisy scans
		for k=1:broad.dual.scans
			B(k,:) = ...
				linspace(-broad.dual.Delta_B(k)/2, ...
					broad.dual.Delta_B(k)/2, M);
			Y(k,:) = ...
				f([d broad.Gamma(i) broad.dual.B_m(k)], B(k,:)) + ...
				sigma_N*sqrt(broad.dual.scans)*randn(1, M);
		end

		% Estimate parameters from the scans
		theta_hat = ...
			estimate_parameters(broad.Gamma_min, broad.Gamma_max, ...
				broad.dual.scans, Y, B, initializations, broad.dual.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	broad.dual.simulated_std(i) = std(Gamma_hat);
end

% Average across the range
broad.dual.simulated_mean_std = mean(broad.dual.simulated_std);

%% New figure window
figure();

%% One plot with twelve bars
bar([
	tumor.single.predicted_mean_std  tumor.single.simulated_mean_std;
	tumor.dual.predicted_mean_std    tumor.dual.simulated_mean_std;
	tissue.single.predicted_mean_std tissue.single.simulated_mean_std;
	tissue.dual.predicted_mean_std   tissue.dual.simulated_mean_std;
	broad.single.predicted_mean_std  broad.single.simulated_mean_std;
	broad.dual.predicted_mean_std    broad.dual.simulated_mean_std;
]);
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
set(gca(), 'Xticklabel', {'Single' 'Dual' 'Single' 'Dual' 'Single' 'Dual'});
xlim([0.5 6.5]);
xlabel({'' 'Number of scans'});
ylabel('Mean \Gamma std. (G)'); % add a hat above Gamma in post-processing
legend('Predicted', 'Simulated', 'Location', 'Northwest');
line([2.5 2.5], ylim(), ...
	'Linewidth', linewidth, 'Linestyle', '-', 'Color', 'black');
line([4.5 4.5], ylim(), ...
	'Linewidth', linewidth, 'Linestyle', '-', 'Color', 'black');
brighten(1); % brighten colors

% This will need cleaned up in post-processing
my_axis = axis();
text(1, my_axis(4)*1.04, '0-15 mmHg', 'Fontsize', font_size);
text(3, my_axis(4)*1.04, '0-30 mmHg', 'Fontsize', font_size);
text(5, my_axis(4)*1.04, '0-160 mmHg', 'Fontsize', font_size);

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);
