clear;
S1 = load('anw-q1.mat','input','target');
S2 = load('anw-q2.mat','input','target');
S3 = load('anw-q3.mat','input','target');
S4 = load('anw-q4.mat','input','target');
S5 = load('naca0012-q1.mat','input','target');
S6 = load('naca0012-q2.mat','input','target');
S7 = load('naca0012-q3.mat','input','target');
S8 = load('naca0012-q4.mat','input','target');
S9 = load('rae2822-q1.mat','input','target');
S10 = load('rae2822-q2.mat','input','target');
S11 = load('rae2822-q3.mat','input','target');
S12 = load('rae2822-q4.mat','input','target');

input = [S1.input;S2.input;S3.input;S4.input;S5.input;...
         S6.input;S7.input;S8.input;S9.input;S10.input;...
         S11.input;S12.input];%S13.input;S14.input;S15.input;...
         %S16.input;S17.input;S18.input;S19.input;S20.input];
target = [S1.target;S2.target;S3.target;S4.target;S5.target;...
          S6.target;S7.target;S8.target;S9.target;S10.target;...
          S11.target;S12.target];%S13.target;S14.target;S15.target;...
          %S16.target;S17.target;S18.target;S19.target;S20.target];
          
save('airfoil_quad.mat','input','target')