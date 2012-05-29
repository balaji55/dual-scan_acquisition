%% Display parameters for the plots
font_size = 18;
linewidth = 2;

%% Scanning parameters
M = 1024;        % samples per scan
d = 10;          % spin density, in arbitrary units
sigma_N = 1;     % noise standard deviation, in arbitrary units
scans = 2;       % number of scans
B_m = [0.5 3];   % modulation amplitudes for the scans, in Gauss
Delta_B = [2 5]; % sweep width for the scans, in Gauss
Gamma = 0.4;     % the HWHM linewidth depicted, in Gauss

%% Produce the data
B_1 = linspace(-Delta_B(1)/2, Delta_B(1)/2, M); % B field values for scan 1
B_2 = linspace(-Delta_B(2)/2, Delta_B(2)/2, M); % B field values for scan 2
Y_1 = f([d Gamma B_m(1)], B_1) + sigma_N*sqrt(scans)*randn(1,M); % scan 1 data
Y_2 = f([d Gamma B_m(2)], B_2) + sigma_N*sqrt(scans)*randn(1,M); % scan 2 data

%% We'll need these to organize the plots a bit
B_min = min([B_1 B_2]);
B_max = max([B_1 B_2]);
Y_min = min([Y_1 Y_2]);
Y_max = max([Y_1 Y_2]);

%% New figure window
figure();

%% Top plot: scan 1
handle_1 = subplot(2,1,1);
plot(B_1, Y_1);
set(gca(), 'Xticklabel', {});
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
xlim([B_min B_max]);
ylim([Y_min Y_max]);
ylabel('Signal (a.u.)');
text(B_min*0.9, Y_min*0.6, ...
	{'B_m_,_1 = 0.5 G' '\Delta_B_,_1 = 2 G'}, 'FontSize', font_size);

%% Bottom plot: scan 2
handle_2 = subplot(2,1,2);
plot(B_2, Y_2);
set(gca(), 'Fontsize', font_size);
set(gca(), 'Linewidth', linewidth);
xlim([B_min B_max]);
ylim([Y_min Y_max]);
xlabel('B (G)');
ylabel('Signal (a.u.)');
text(B_min*0.9, Y_min*0.6, ...
	{'B_m_,_2 = 3 G' '\Delta_B_,_2 = 5 G'}, 'Fontsize', font_size);

%% Remove empty space between the two plots
pos_1 = get(handle_1, 'pos');
pos_2 = get(handle_2, 'pos');
gap = pos_1(2) - pos_2(4) - pos_2(2);
pos_1(2) = pos_1(2) - gap/2;
pos_1(4) = pos_1(4) + gap/2;
pos_2(4) = pos_2(4) + gap/2;
set(handle_1, 'pos', pos_1);
set(handle_2, 'pos', pos_2);

%% Save figure as an EPS file
print('-depsc2', [mfilename() '.eps']);
