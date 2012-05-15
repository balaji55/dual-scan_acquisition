function [absorption_signal] = f(theta, B)
%
% [absorption_signal] = f(theta, B)
%
% This is the first harmonic absorption signal model for a modulation-distorted
% Lorentzian EPR probe from Robinson 1999 [1], simplified to ignore the effects
% of modulation frequency, which are insignificant when the following holds:
%
%              linewidth       modulation frequency
%                     ||       ||
%                     \/       \/
%                   Gamma >> f_mod/gamma_e
%                                   /\
%                                   ||
%                                   electron gyromagnetic ratio
%
% The function inputs are theta = [d Gamma B_m] and B:
%
%     d     : the spin density, in arbitrary units
%     Gamma : the HWHM linewidth, in Gauss
%     B_m   : the modulation amplitude, in Gauss
%     B     : a vector of field values, in Gauss
%
% The output is the signal at the field values given in B.
%
% [1] "Linewidth analysis of spin labels in liquids: I. Theory and data
%     analysis". B.H. Robinson, C. Mailer, A.W. Reese, Journal of Magnetic
%     Resonance, 1999.
%

	% Argument processing and checking
	if ~isequal(sort(size(theta)), [1 3])
		error('theta must be 1x3 or 3x1');
	else
		% Extract the parameters, for easier manipulation below
		d = theta(1);     % spin density, in arbitrary units
		Gamma = theta(2); % HWHM linewidth, in Gauss
		B_m = theta(3);   % modulation amplitude, in Gauss
	end
	if ~isfloat(d) || ~(d>0)
		error('d must be a positive float');
	elseif ~isfloat(Gamma) || ~(Gamma>0)
		error('Gamma must be a positive float');
	elseif ~isfloat(B_m) || ~(B_m>0)
		error('B_m must be a positive float');
	elseif ~isnumeric(B)
		error('B must be numeric');
	end

	% First-harmonic signal, absorption and dispersion
	a = B + 1i*Gamma;
	g = 1/2 * a.^2 .* (1 + sqrt(1 - (B_m./2./a).^2)) - (B_m)^2 / 8;
	complex_signal = d * B_m ./ g;

	% We only want the absorption signal
	absorption_signal = imag(complex_signal);

end
