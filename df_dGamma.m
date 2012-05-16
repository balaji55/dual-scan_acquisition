function [value] = df_dGamma(d, Gamma, B_m, B)
%
% [value] = df_dGamma(d, Gamma, B_m, B)
%
% This is the partial derivative of the f.m function with respect to Gamma.
%
% The inputs are d, Gamma, B_m, and B:
%
%     d     : the spin density, in arbitrary units
%     Gamma : the HWHM linewidth, in Gauss
%     B_m   : the modulation amplitude, in Gauss
%     B     : the field value, in Gauss
%

	% Argument checking
	if ~isscalar(d) || ~isfloat(d) || ~(d>0)
		error('df_dGamma:invalid_argument', ...
			'd must be a single positive float');
	elseif ~isscalar(Gamma) || ~isfloat(Gamma) || ~(Gamma>0)
		error('df_dGamma:invalid_argument', ...
			'Gamma must be a single positive float');
	elseif ~isscalar(B_m) || ~isfloat(B_m) || ~(B_m>0)
		error('df_dGamma:invalid_argument', ...
			'B_m must be a single positive float');
	elseif ~isscalar(B) || ~isfloat(B)
		error('df_dGamma:invalid_argument', ...
			'B must be a single float');
	end

	% Please pardon the unreadable math....
	value = imag( ...
		(B_m*d*(((2*Gamma - 2*B*1i)*((1 - B_m^2/(4*(B + ...
		1i*Gamma)^2))^(1/2) + 1))/2 - (B_m^2*1i)/(8*(1 - B_m^2/(4*(B + ...
		1i*Gamma)^2))^(1/2)*(B + 1i*Gamma))))/(B_m^2/8 - (((1 - ...
		B_m^2/(4*(B + 1i*Gamma)^2))^(1/2) + 1)*(B + 1i*Gamma)^2)/2)^2 ...
	);

end
