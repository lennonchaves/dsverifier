function [output] = dsv_comparison(system, p)
%
% Script to verify and compare the results between MATLAB and DSVerifier
% Give the system as input on this function and check if the outputs of
% MATLAB and DSVerifier are the same.
% 
% Function: [output] = dsv_comparison(system, p)
%
% The struct 'system' should have the following features:
% system.sys.a = denominator;
% system.sys.b = numerator;
% system.sys.tf = transfer function system representation
% system.impl.frac_bits = fractionary bits
% system.impl.int_bits = integer bits
% system.impl.realization_form = realization, and it should be DFI, DFII, TDFII, DDFI, DDFII or TDDFII
% system.inputs.const_inputs = the inputs from counterexample
% system.inputs.initial_states = the initial states from counterexample
% system.outputs.output_verification = the output extracted from counterexample
% system.impl.delta = in delta form realizations, the delta operator should be informed
% system.impl.sample_time = sample time of realization
% system.impl.x_size = the bound size
%
%
% The parameter 'p' is the property to be analyzed: minimum phase (m), stability (s), overflow(o), limit cycle (lc).
%
% The output is the feedback returned from comparison (successful or failed);
%
% Lennon Chaves
% November 17, 2016
% Manaus, Brazil

global max_error;
global overflow_mode;

if (strcmp(p,'lc'))

count = length(unique(system.output.output_simulation));

    if count <= system.impl.x_size/2
        output = 'Successful';
    else
        output = 'Failed';
    end

elseif (strcmp(p,'o'))
    
n = system.impl.int_bits;
l = system.impl.frac_bits;

min_wl = -1*((2^(n-1)));
max_wl = ((2^(n-1))-2^(-1*l));
y = system.output.output_simulation;
result = 0;

if strcmp(overflow_mode,'wrap')
    
for i=1:system.impl.x_size

if (y(i) >= max_wl || y(i) <= min_wl)
        result=1;
        break;
end

end

elseif strcmp(overflow_mode, 'saturate')
n_y = length(system.output.output_verification);
count = 0;
yv = system.output.output_verification;
ys = system.output.output_simulation;
for i=1:n_y
erro = abs(abs(yv(i))-abs(ys(i)));
if yv(i) ~= 0
erro = erro/abs(yv(i));
end
if round(erro) <= 0.1
count = count + 1;
end
end

if count == n_y
    result = 1;
else
    result = 0;
end

end
    
if result == 1
  output = 'Successful';
else
  output = 'Failed';
end

elseif (strcmp(p,'e'))

y = system.output.output_simulation;

if (max_error > 0)

has_error = 0;
for i=1:length(y)
 if (y(i) < (-1)*max_error || y(i) > max_error)
    has_error = 1;
    break;
 end
end

if has_error == 1
  output = 'Successful';
else
  output = 'Failed';
end

else
output = 'Failed';
end

else

 if (strcmp(lower(strtrim(system.output.output_verification)),lower(strtrim(system.output.output_simulation))))
	output = 'Successful';
    else
        output = 'Failed';
 end

end

end
