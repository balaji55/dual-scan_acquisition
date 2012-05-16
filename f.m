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
		error('f:invalid_argument', 'theta must be 1x3 or 3x1');
	else
		% Extract the parameters, for easier manipulation below
		d = theta(1);     % spin density, in arbitrary units
		Gamma = theta(2); % HWHM linewidth, in Gauss
		B_m = theta(3);   % modulation amplitude, in Gauss
	end
	if ~isscalar(d) || ~isfloat(d) || ~(d>0)
		error('f:invalid_argument', 'd must be a single positive float');
	elseif ~isscalar(Gamma) || ~isfloat(Gamma) || ~(Gamma>0)
		error('f:invalid_argument', 'Gamma must be a single positive float');
	elseif ~isscalar(B_m) || ~isfloat(B_m) || ~(B_m>0)
		error('f:invalid_argument', 'B_m must be a single positive float');
	elseif ~isvector(B) || ~isnumeric(B)
		error('f:invalid_argument', 'B must be numeric vector');
	end

	% First-harmonic signal, absorption and dispersion
	a = B + 1i*Gamma;
	g = 1/2 * a.^2 .* (1 + sqrt(1 - (B_m./2./a).^2)) - (B_m)^2 / 8;
	complex_signal = d * B_m ./ g;

	% We only want the absorption signal
	absorption_signal = imag(complex_signal);

end
