button = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');
switch button
    case 'Yes',
        disp('Exiting MATLAB');
        %Save variables to matlab.mat
        save
    case 'No',
        quit cancel;
end