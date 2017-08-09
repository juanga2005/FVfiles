%% preprocess experimental design 

clear all
clc 
close all


Design = importdata('design64points.txt')

gamma_vec = Design(:,1);
z_0_vec = Design(:,2);
L_vec = Design(:,3);

z_i = 100;
z_cutoff_vec = 2*ones(size(gamma_vec));

% fortran code takes in gamma, z_0, L, z_cuoff and then alphax, alphay and
% alphaz which are diffusion coefficients at reference height

% compute u_star
Phi = @(z,LL) sqrt(1 - 15*z./LL);

u_star = (0.4)./log(10./z_0_vec);

alphaz_vec = (0.4*u_star*10)./(Phi(10,L_vec));

alphay_vec = 0.1*(z_i.^(3/4)).*((-0.4.*L_vec).^(-1/3)).*u_star;
alphax_vec = alphay_vec;

% write files 
dlmwrite('alphashear.dat', gamma_vec)
dlmwrite('z_0.dat', z_0_vec)
dlmwrite('u_cutoff.dat', z_cutoff_vec)
dlmwrite('diffL.dat', L_vec)
dlmwrite('alphaz.dat', alphaz_vec)
dlmwrite('alphax.dat', alphax_vec)
dlmwrite('alphay.dat', alphay_vec)