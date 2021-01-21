clear;
S1 = load('anw.mat','input','target');
S5 = load('naca0012.mat','input','target');
S9 = load('rae2822.mat','input','target');

input = [S1.input;S5.input;S9.input];
target = [S1.target;S5.target;S9.target];
          
save('airfoil.mat','input','target')