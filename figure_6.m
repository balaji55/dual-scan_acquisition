%% Display parameters for the plots
font_size = 18;
linewidth = 2;
marker_size = 20;

%% Global settings

% How many times each sample tube was scanned
scans_per_sample = 24;

% Expected range for our HWHM linewidths, in Gauss
Gamma_min = 0.356;
Gamma_max = 0.46;

% How many initializations for the curve fitting, to avoid local minima
tries = 20;

%% One scan, traditional

% Read in scan data
spectra{1} = csvread('data/s_1_traditional.csv');
spectra{2} = csvread('data/s_2_traditional.csv');

% Parameters
traditional.scans   = 1;      % number of scans
traditional.B_m     = 1.0013; % modulation amplitude, in Gauss
traditional.Delta_B = 6.0012; % sweep width, in Gauss
traditional.M       = 2048;   % samples per scan

% Preallocate
traditional.Gamma_hat_mean = zeros(size(spectra));
traditional.Gamma_hat_std = zeros(size(spectra));

for i=1:length(spectra)
	Gamma_hat = zeros(1, scans_per_sample);

	data = spectra{i};

	for j=1:scans_per_sample

		Y = data(:,j)';

		% Field values
		B = linspace(-traditional.Delta_B/2, traditional.Delta_B/2, ...
			traditional.M);

		% Estimate Gamma
		theta_hat = estimate_parameters(Gamma_min, Gamma_max, ...
			traditional.scans, Y, B, tries, traditional.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	% Calculate statistics
	traditional.Gamma_hat_mean(i) = mean(Gamma_hat);
	traditional.Gamma_hat_std(i) = std(Gamma_hat);
end

%% Single-scan, optimized

% Read in scan data
spectra{1} = csvread('data/s_1_single_scan.csv');
spectra{2} = csvread('data/s_2_single_scan.csv');

% Parameters
single_scan.scans   = 1;      % number of scans
single_scan.B_m     = 1.4157; % modulation amplitude, in Gauss
single_scan.Delta_B = 2.7623; % sweep width, in Gauss
single_scan.M       = 2048;   % samples per scan

% Preallocate
single_scan.Gamma_hat_mean = zeros(size(spectra));
single_scan.Gamma_hat_std = zeros(size(spectra));

for i=1:length(spectra)
	Gamma_hat = zeros(1, scans_per_sample);

	data = spectra{i};

	for j=1:scans_per_sample

		Y = data(:,j)';

		% Field values
		B = linspace(-single_scan.Delta_B/2, single_scan.Delta_B/2, ...
			single_scan.M);

		% Estimate Gamma
		theta_hat = estimate_parameters(Gamma_min, Gamma_max, ...
			single_scan.scans, Y, B, tries, single_scan.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	% Calculate statistics
	single_scan.Gamma_hat_mean(i) = mean(Gamma_hat);
	single_scan.Gamma_hat_std(i) = std(Gamma_hat);
end

%% Dual-scan, optimized

% Read in scan data
spectra{1} = csvread('data/s_1_dual_scan.csv');
spectra{2} = csvread('data/s_2_dual_scan.csv');

% Parameters
dual_scan.scans   = 2;               % number of scans
dual_scan.B_m     = [0.5592 2.5130]; % modulation amplitudes, in Gauss
dual_scan.Delta_B = [1.2634 4.1285]; % sweep widths, in Gauss
dual_scan.M       = 1024;            % samples per scan

% Preallocate
dual_scan.Gamma_hat_mean = zeros(size(spectra));
dual_scan.Gamma_hat_std = zeros(size(spectra));

for i=1:length(spectra)
	Gamma_hat = zeros(1, scans_per_sample);

	data = spectra{i};

	for j=1:scans_per_sample

		Y_1 = data(:,2*j-1)';
		Y_2 = data(:,2*j)';

		% Field values
		B_1 = linspace(-dual_scan.Delta_B(1)/2, dual_scan.Delta_B(1)/2, ...
			dual_scan.M);
		B_2 = linspace(-dual_scan.Delta_B(2)/2, dual_scan.Delta_B(2)/2, ...
			dual_scan.M);

		% Estimate Gamma
		theta_hat = estimate_parameters(Gamma_min, Gamma_max, ...
			dual_scan.scans, [Y_1; Y_2], [B_1; B_2], tries, dual_scan.B_m);
		Gamma_hat(j) = theta_hat(2);
	end

	% Calculate statistics
	dual_scan.Gamma_hat_mean(i) = mean(Gamma_hat);
	dual_scan.Gamma_hat_std(i) = std(Gamma_hat);
end

%% New figure window, bigger than usual
handle = figure();
set(handle, 'Position', [100 100 560 800], 'Paperpositionmode', 'auto');

%% Top plot: mean values with three standard deviations
handle_1 = subplot(2, 1, 1);

stds = 3; % how many standard deviations to show on each side

hold('on');
errorbar([1 1], traditional.Gamma_hat_mean, stds*traditional.Gamma_hat_std, ...
	' r.', 'Linewidth', linewidth, 'Markersize', marker_size);
errorbar([2 2], single_scan.Gamma_hat_mean, stds*single_scan.Gamma_hat_std, ...
	' g.', 'Linewidth', linewidth, 'Markersize', marker_size);
errorbar([3 3],   dual_scan.Gamma_hat_mean, stds*  dual_scan.Gamma_hat_std, ...
	' b.', 'Linewidth', linewidth, 'Markersize', marker_size);
% Fix error bar widths in post-processing

ylim([Gamma_min Gamma_max]);

set(gca(), 'Xticklabel', {});
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);

ylabel('\Gamma (G)'); % add a hat above Gamma in post-processing

line([1.5 1.5], ylim(), 'Linewidth', linewidth, 'Linestyle', '-', ...
	'Color', 'black');
line([2.5 2.5], ylim(), 'Linewidth', linewidth, 'Linestyle', '-', ...
	'Color', 'black');

% This will need cleaned up in post-processing
my_axis = axis();
text(1, my_axis(4)+(my_axis(4)-my_axis(3))*0.1, {'One scan,' 'traditional'}, ...
	'Fontsize', font_size, 'Horizontalalignment', 'center');
text(2, my_axis(4)+(my_axis(4)-my_axis(3))*0.1, {'One scan,' 'optimized'}, ...
	'Fontsize', font_size, 'Horizontalalignment', 'center');
text(3, my_axis(4)+(my_axis(4)-my_axis(3))*0.1, {'Dual-scan,' 'optimized'}, ...
	'Fontsize', font_size, 'Horizontalalignment', 'center');

% Add '(A)'
y_limits = ylim();
text(-0.05, y_limits(2), '(A)', 'Fontsize', font_size);

box('on');

%% Bottom plot: equivalent experiment times
handle_2 = subplot(2, 1, 2);

traditional.Gamma_hat_mean_std = mean(traditional.Gamma_hat_std);
single_scan.Gamma_hat_mean_std = mean(single_scan.Gamma_hat_std);
dual_scan.Gamma_hat_mean_std = mean(dual_scan.Gamma_hat_std);

traditional.equivalent_time = ...
	traditional.Gamma_hat_mean_std^2 / dual_scan.Gamma_hat_mean_std^2;
single_scan.equivalent_time = ...
	single_scan.Gamma_hat_mean_std^2 / dual_scan.Gamma_hat_mean_std^2;
dual_scan.equivalent_time = 1 + 0.1; % penalty time, to let system stabilize

hold('on');
bar([traditional.equivalent_time 0 0], 0.5, 'r');
bar([0 single_scan.equivalent_time 0], 0.5, 'g');
bar([0 0 dual_scan.equivalent_time], 0.5, 'b');

set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
set(gca(), 'Xticklabel', {});
xlim([0.5 3.5]);

ylabel('Experiment time (a.u.)');

box('on');

%% Reduce empty space between the two plots
pos_1 = get(handle_1, 'pos');
pos_2 = get(handle_2, 'pos');
gap = pos_1(2) - pos_2(4) - pos_2(2);
pos_1(2) = pos_1(2) - gap/4;
pos_1(4) = pos_1(4) + gap/4;
pos_2(4) = pos_2(4) + gap/4;
set(handle_1, 'pos', pos_1);
set(handle_2, 'pos', pos_2);

% Add '(B)' after reducing the space
y_limits = ylim();
text(-0.05, y_limits(2), '(B)', 'Fontsize', font_size);

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);
