function verify_minimum_phase(system, bmc, realization, xsize, varargin)

global property;
%setting the DSVERIFIER_HOME
dsv_setup();
%translate to ANSI-C file
dsv_parser(system,'tf',0);
%verifying using DSVerifier command-line
property = 'MINIMUM_PHASE';

extra_param = get_macro_params(nargin,varargin,'tf');

command_line = [' --property ' property ' --realization ' realization ' --x-size ' num2str(xsize) ' --bmc ' bmc extra_param];
dsv_verification(command_line,'tf');
%report the verification
output = dsv_report('output.out','tf');
disp(output);

end

