function [theta_hat] = estimate_parameters(Gamma_min, Gamma_max, ...
		number_of_scans, Y, B, initializations, B_m_guess)
%
% [theta_hat] = estimate_parameters(Gamma_min, Gamma_max, ...
%     number_of_scans, Y, B, initializations, B_m_guess)
%
% This function estimates the unknown parameters from a set of scan data.
%
% The inputs are Gamma_min, Gamma_max, number_of_scans, Y, B, initializations,
% and B_m_guess:
%
%     Gamma_min       : the minimum HWHM linewidth expected, in Gauss
%     Gamma_max       : the maximum HWHM linewidth expected, in Gauss
%     number_of_scans : how many different scans were performed
%     Y               : the scan data, in arbitrary units
%     B               : the field values for each data point
%     initializations : how many initial guesses to try when fitting
%     B_m_guess       : the modulation amplitude you set on the instrument
%
% The output is theta_hat = [d_hat Gamma_hat B_m_hat], the estimated parameter
% values.
%

% Note: I am aware that number_of_scans is not strictly necessary, but it makes
% for a nice sanity check.

	% Argument checking
	if ~isscalar(Gamma_min) || ~isfloat(Gamma_min) || ~(Gamma_min>0)
		error('estimate_parameters:invalid_argument', ...
			'Gamma_min must be a positive scalar float');
	elseif ~isscalar(Gamma_max) || ~isfloat(Gamma_max) || ~(Gamma_max>0)
		error('crlb_on_var:invalid_argument', ...
			'Gamma must be a positive scalar float');
	elseif ~isscalar(number_of_scans) || ~isfloat(number_of_scans) || ...
		~(number_of_scans > 0)
			error('estimate_parameters:invalid_argument', ...
				'number_of_scans must be a positive scalar float');
	elseif ~(size(Y, 1) == number_of_scans) || ~isfloat(Y)
		error('estimate_parameters:invalid_argument', ...
			'Y must be a number_of_scans-by-M matrix of floats');
	elseif ~(size(B, 1) == number_of_scans) || ~isfloat(B)
		error('estimate_parameters:invalid_argument', ...
			'B must be a number_of_scans-by-M matrix of floats');
	elseif ~isequal(size(Y), size(B))
		error('estimate_parameters:invalid_argument', ...
			'Y and B must have the same size');
	elseif ~isscalar(initializations) || ~isfloat(initializations) || ...
		~(initializations > 0)
			error('estimate_parameters:invalid_argument', ...
				'initializations must be a positive scalar float');
	elseif ~isfloat(B_m_guess) || any(B_m_guess<0) || ...
			~isequal(size(B_m_guess), [1 number_of_scans])
		error('estimate_parameters:invalid_argument', ...
		'B_m_guess must be a 1-by-number_of_scans vector of positive floats');
	end

	% We can try a few different initializations
	Gamma_guess = linspace(Gamma_min, Gamma_max, initializations);

	% Preallocate
	theta_hats = zeros(initializations, number_of_scans + 2);
	residual_norm = zeros(initializations, 1);

	% Create the objective function
	fit_error_ready = @(theta) fit_error(theta, number_of_scans, Y, B);

	for i=1:initializations
		guess = [0 Gamma_guess(i) B_m_guess];
		[theta_hats(i,:), residual_norm(i)] = lsqnonlin(fit_error_ready, ...
			guess,                         ... % starting guess
			zeros(1, number_of_scans + 2), ... % lower bounds (zero)
			inf(1, number_of_scans + 2));  ... % upper bounds (infinity)
	end

	% Return the theta_hat with best residual norm
	[~, index] = min(residual_norm);
	theta_hat = theta_hats(index,:);
end

function [errors] = fit_error(theta, number_of_scans, Y, B)
% theta = [d Gamma B_m]
% d               : spin density, in arbitrary units
% Gamma           : HWHM linewidth, in Gauss
% B_m             : modulation amplitudes, in Gauss
% number_of_scans : how many scans were performed
% Y               : the scan data, in arbitrary units
% B               : field values for each data point, in Gauss

	% Break theta apart
	d = theta(1);
	Gamma = theta(2);
	B_m = theta(3:end);

	% Preallocate
	errors = zeros(size(Y));

	% Iterate over the scans
	for i=1:1:number_of_scans
		ideal_data = f([d Gamma B_m(i)], B(i,:));
		errors(i,:) = Y(i,:) - ideal_data;
	end

end
