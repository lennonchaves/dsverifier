function verify_ss_controllability(system, bmc, realization, solver, xsize)

global property;
%setting the DSVERIFIER_HOME
dsv_setup();
%translate to ANSI-C file
dsv_parser(system,'ss',0);
%verifying using DSVerifier command-line
property = 'CONTROLLABILITY';
command_line = [' --property ' property ' --realization ' realization ' --x-size ' num2str(xsize) ' --bmc ' bmc ' --solver ' solver];
dsv_verification(command_line,'ss');
%report the verification
output = dsv_report('output.out','ss');
disp(output);

end

