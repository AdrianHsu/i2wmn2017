% Introduction to Wireless and Mobile Networking : Hw1 -1
% radio propagation model : P_R = P_T * G_T * G_C * G_R 
% path-loss model only :  G_C = two-ray-ground model
clear;
clc;

T      = 27 + 273.15;
B      = 10e6;
P_T    = 33 - 30; % input power = 33 dBm
G_T_dB = 14;
G_R_dB = 14;
H_BS   = 1.5;     % height of Base station
H_B    = 50;      % height of building
H_MS   = 1.5;     % height of mobile station
H_T    = H_BS + H_B;
H_R    = H_MS;

% start modeling
d = 0:1:1000;
G_d = G_two_ray_ground(H_T, H_R, d);
G_d_dB = todB(G_d);
P_R = P_T + G_T_dB + G_R_dB + G_d_dB;

% plot figure1-1
figure
plot(d,P_R), 
xlabel('distance(m)'), ylabel( 'Received Power(dB)'),
title('Figure 1-1')

