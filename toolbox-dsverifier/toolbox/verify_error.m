function verify_error(system, realization, xsize, error, varargin)
%
% Checks error property violation for digital systems using a bounded model checking tool.
% Function: VERIFY_ERROR(system, realization, xsize, error)
%
% Where
%   system: represents a struct with digital system represented in transfer-function;
%   realization: set the realization for the Digital-System (DFI, DFII, TDFII, DDFI, DDFII, and TDDFII);
%   xsize:  set the bound of verification.
%   error: set the error limit
%
%  The 'system' must be structed as follow:
%  system.system = tf(den,num,ts): transfer function representation (den - denominator, num - numerator, ts - sample time);
%  or system.system = c2d(sys,ts): if the digital system should be discretized
%  
%  See also TF and C2D.
%
%  system.impl.int_bits: integer bits implementation;
%  system.impl.frac_bits: fractional bits representation;
%  system.range.max = max dynamical range;
%  system.range.min = min dynamical range;
%  system.delta = delta operator (it must be '0' if it is not a delta realization).
%
% Another usage form is adding other parameters (optional parameters) as follow:
%
% VERIFY_ERROR(system, realization, xsize, error, bmc, solver, ovmode, rmode, emode, timeout)
%
% Where
%  bmc: set the BMC back-end for DSVerifier (ESBMC or CBMC);
%  solver: use the specified solver in BMC back-end which could be 'Z3', 'boolector', 'yices', 'cvc4', 'minisat';
%  ovmode: set the overflow mode which could be 'WRAPAROUND' or 'SATURATE';
%  rmode: set the rounding mode which could be 'ROUNDING', 'FLOOR', or 'CEIL';
%  emode: set the error mode which could be 'ABSOLUTE' or 'RELATIVE';
%  timeout: configure time limit, integer followed by {s,m,h} (for ESBMC only).
%
% Example of usage:
%  num = [...];
%  den = [...];
%  ds.system = tf(den,num,ts);
%  ds.impl.int_bits = ...;
%  ds.impl.frac_bits = ...;
%  ds.range.max = ...;
%  ds.range.min = -...;
%  ds.delta = ...;
%
%  VERIFY_ERROR(ds,'DFI',10,'CBMC');
%  VERIFICATION FAILED!
%
% Author: Lennon Chaves
% Federal University of Amazonas
% October, 2016
%
global property;
%setting the DSVERIFIER_HOME
dsv_setup();
%translate to ANSI-C file
dsv_parser(system,'tf', error,realization);
%verifying using DSVerifier command-line
property = 'ERROR';

extra_param = get_macro_params(nargin-1,varargin,'tf');

command_line = [' --property ' property ' --realization ' realization ' --x-size ' num2str(xsize) extra_param];
dsv_verification(command_line,'tf');
%report the verification
output = dsv_report('output.out','tf');
disp(output);

end

