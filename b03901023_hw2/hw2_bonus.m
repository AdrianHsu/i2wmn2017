% hw2_bonus.m

T = 27;
bw = 10000000; % 10e6
p_bs_dbm = 33;
p_ms_dbm = 23;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
% scale = 2000;

p_bs_db = p_bs_dbm - 30;
p_ms_db = p_ms_dbm - 30;
dist = 500;
side = 500/sqrt(3);
ms_num = 50;
bs_num = 19;

% BONUS, B-1
noise = thermNoise(T + 273.15, bw);
bs_x = side * [-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist * [-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];
c_x = zeros(bs_num,ms_num);
c_y = zeros(bs_num,ms_num);
hold on;

for i = 1:bs_num
    [c_x(i,:), c_y(i,:)] = hexagon(bs_x(i), bs_y(i), ms_num);
end
hold on;
plot(c_x, c_y, '.');
xlabel('Distance(m)'), ylabel('Distance(m)');
title('fig. 1-1');
Xmax = 4*side;
Ymax = 2.5*dist;
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;
