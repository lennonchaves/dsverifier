function dsv_verification(command, representation)
% Function to get the parameters, system and implementatio to start the verification
%
% Function: output =  DSV_VERIFICATION(command, representation)
%
%  command: the command line with all parameters to execute the
%  verification
%  representation: 'ss' for state-space, 'tf' for transfer function and 'cl' for
%  closed-loop systems
%
% Author: Lennon Chaves
% Federal University of Amazonas
% October 2016
%

if strcmp(representation,'ss')
s1 = 'dsverifier file.ss';
else
s1 = 'dsverifier input.c';
end

s3 = ' --show-ce-data > output.out';
command_line = [s1 command s3];
system(command_line);

end

