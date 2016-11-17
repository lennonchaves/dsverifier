function dsv_extraction(directory, p)

%
% Function to extract all counterexamples from .out files generated by DSVerifier
% Script to extraction from counterexamples folder all parameters necessaries
% for validation and reproduction in MATLAB
%
% Function: dsv_extraction(directory, p)
%
% Where 'directory' should be the path with all counterexamples inside .out files.
% the parameter 'p' is the property to be analyzed and it should be (m) for minimum phase, (s) for stability, (o) for overflow, (lc) for limit cycle, (e) for quantization error in transfer function and (scl) for stability in closed-loop systems
%
%
% Lennon Chaves
% October 09, 2016
% Manaus, Brazil

sh = 'sh';
cp = 'cp';

current =  pwd;

user = userpath;
install_folder = [user '/Add-Ons/Toolboxes/DSValidator/code'];
cd(install_folder);

%extraction of parameters

if (strcmp(p,'lc') || strcmp(p,'o') || strcmp(p,'e'))

script1 = 'dsverifier-directory-data-extractor-script.sh';
command = [sh ' ' script1 ' ' directory];
system(command);

%copying files to matlab directory
command = [cp ' ' directory '/dsv_counterexample_parameters.txt' ' dsv_counterexample_parameters.txt'];
system(command);

else

script2 = 'dsverifier-restricted-counterexample-extractor-script.sh';
command = [sh ' ' script2 ' ' directory];
system(command);

%copying files to matlab directory
command = [cp ' ' directory '/dsv_counterexample_parameters.txt' ' dsv_counterexample_parameters.txt'];
system(command);

end

cd(current);

end
