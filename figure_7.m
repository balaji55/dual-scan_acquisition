function figure_7

%% Display parameters for the plots
font_size = 18;
linewidth = 2;

% So they all have the same scales
B_min = -3;   %
B_max =  3;   % field values, in Gauss
Y_min = -700; %
Y_max =  700; % signal amplitudes, in arbitrary units

%% New figure window, a little bigger than usual
handle = figure();
set(handle, 'Position', [100 100 560 700], 'Paperpositionmode', 'auto');

%% Single-scan, traditional

% Read in scan data
spectra = csvread('data/s_2_traditional.csv');
spectrum = spectra(:, 8);

% Parameters
Delta_B = 6.00; % sweep width, in Gauss
M       = 2048; % samples per scan

% Field values
B = linspace(-Delta_B/2, Delta_B/2, M);

handle_1 = subplot(3, 1, 1);
plot(B, spectrum);

set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);

xlim([B_min B_max]);
ylim([Y_min Y_max]);
set(gca(), 'Xticklabel', {});

text(B_min*0.9, Y_min*0.6, ...
	{'B_m_,_1 = 1.03 G' '\Delta_B_,_1 = 6.00 G'}, 'Fontsize', font_size);

text(B_min*1.4, Y_max*0.8, '(A)', 'Fontsize', font_size);

%% Single-scan, optimized

% Read in scan data
spectra = csvread('data/s_2_single_scan.csv');
spectrum = spectra(:, 8);

% Parameters
Delta_B = 2.76; % sweep width, in Gauss
M       = 2048; % samples per scan

% Field values
B = linspace(-Delta_B/2, Delta_B/2, M);

handle_2 = subplot(3, 1, 2);
plot(B, spectrum);

set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);

ylabel('Signal (a.u.)');

xlim([B_min B_max]);
ylim([Y_min Y_max]);
set(gca(), 'XtickLabel', {});

text(B_min*0.9, Y_min*0.6, ...
	{'B_m_,_1 = 1.46 G' '\Delta_B_,_1 = 2.76 G'}, 'Fontsize', font_size);

text(B_min*1.4, Y_max*0.8, '(B)', 'Fontsize', font_size);

%% Dual-scan, optimized

% Read in scan data
spectra = csvread('data/s_2_dual_scan.csv');
spectrum_1 = spectra(:, 7);
spectrum_2 = spectra(:, 8);

% Parameters
Delta_B = [1.26 4.13]; % sweep widths, in Gauss
M       = 1024;        % samples per scan

% Field values
B_1 = linspace(-Delta_B(1)/2, Delta_B(1)/2, M);
B_2 = linspace(-Delta_B(2)/2, Delta_B(2)/2, M);

handle_3 = subplot(3, 1, 3);
plot(B_1, spectrum_1);
hold('on');
plot(B_2, spectrum_2, 'r');

set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);

xlim([B_min B_max]);
ylim([Y_min Y_max]);

xlabel('B (G)');

text(B_min*0.7, Y_min*0.6, ...
	{'B_m_,_1 = 0.61 G' '\Delta_B_,_1 = 1.26 G'}, 'Fontsize', font_size);
text(B_max*0.25, Y_max*0.1, ...
	{'B_m_,_2 = 2.63 G' '\Delta_B_,_2 = 4.13 G'}, 'Fontsize', font_size);

text(B_min*1.4, Y_max*0.8, '(C)', 'Fontsize', font_size);

%% Remove empty space between the three plots

% Round 1
pos_1 = get(handle_1, 'pos');
pos_2 = get(handle_2, 'pos');
gap_1 = pos_1(2) - pos_2(4) - pos_2(2);
pos_1(2) = pos_1(2) - gap_1/2;
pos_1(4) = pos_1(4) + gap_1/2;
pos_2(4) = pos_2(4) + gap_1/2;
set(handle_1, 'pos', pos_1);
set(handle_2, 'pos', pos_2);

% Round 2
pos_2 = get(handle_2, 'pos');
pos_3 = get(handle_3, 'pos');
gap_2 = pos_2(2) - pos_3(4) - pos_3(2);
pos_2(2) = pos_2(2) - gap_2/2;
pos_2(4) = pos_2(4) + gap_2/2;
pos_3(4) = pos_3(4) + gap_2/2;
set(handle_2, 'pos', pos_2);
set(handle_3, 'pos', pos_3);

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);

end
