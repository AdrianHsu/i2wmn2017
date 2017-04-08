% hw2_1.m, DOWNLINK

T = 27;
bw = 10000000; % 10e6
p_bs_dbm = 33;
p_ms_dbm = 23;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
scale = 2000;

p_bs_db = p_bs_dbm - 30;
p_ms_db = p_ms_dbm - 30;
dist = 500;
side = 500/sqrt(3);
ms_num = 50;
bs_num = 19;

% 1-1
[v_x,v_y,c_x,c_y]=hexagon(0,0,ms_num);
hold on;
plot(c_x, c_y, '.');
plot(v_x,v_y);
xlabel('Distance(m)'), ylabel('Distance(m)');
title('fig. 1-1');
hold off;

% 1-2
d = sqrt(c_x.^2 + c_y.^2);
gc = twoRayGnd(h_bs, h_md, d);
gc_db = todB(gc);
pr_ms_db = p_bs_db + gt_db + gr_db + gc_db;

figure;
scatter(d, pr_ms_db);
xlabel('Distance(m)'), ylabel( 'Received Power(dB)');
title('fig. 1-2');

% 1-3
noise = thermNoise(T + 273.15, bw);
bs_x = side * [-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist * [-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];
res_dist = zeros(bs_num-1, ms_num);
for i = 1:(bs_num-1)
    d_x = c_x - bs_x(i);
    d_y = c_y - bs_y(i);
    res_dist(i,:) = sqrt(d_x.^2 + d_y.^2);
end

gci = twoRayGnd(h_bs, h_md, res_dist);
gci_db = todB(gci);
inter = p_bs_db + gt_db + gr_db + gci_db;
inter_db = fromdB(inter);
inter_db_total = sum(inter_db);
pr_ms = fromdB(pr_ms_db);
sinr = sinrDB( pr_ms, inter_db_total, noise);

figure;
scatter(d, sinr);
xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('fig. 1-3');
