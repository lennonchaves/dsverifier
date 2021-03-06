function verify_stability(system, realization, xsize, varargin)
%
% Checks stability property violation for digital systems using a bounded model checking tool.
% Function: VERIFY_STABILITY(system, realization, xsize)
%
% Where
%   system: represents a struct with digital system represented in transfer-function;
%   realization: set the realization for the Digital-System (DFI, DFII, TDFII, DDFI, DDFII, and TDDFII);
%   xsize:  set the bound of verification.
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
% VERIFY_STABILITY(system, realization, xsize, bmc, solver, ovmode, rmode, emode, timeout)
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
%  num = [1 0.5 1];
%  den = [1 -1.5 -3];
%  ds.system = tf(den,num,1);
%  ds.impl.int_bits = 2;
%  ds.impl.frac_bits = 14;
%  ds.range.max = 3;
%  ds.range.min = -3;
%  ds.delta = 0.25;
%
%  VERIFY_STABILITY(ds,'DFI',10,'CBMC');
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
dsv_parser(system,'tf',0,realization);
%verifying using DSVerifier command-line
property = 'STABILITY';

extra_param = get_macro_params(nargin,varargin,'tf');

command_line = [' --property ' property ' --realization ' realization ' --x-size ' num2str(xsize) extra_param];
dsv_verification(command_line,'tf');
%report the verification
output = dsv_report('output.out','tf');
disp(output);

end

