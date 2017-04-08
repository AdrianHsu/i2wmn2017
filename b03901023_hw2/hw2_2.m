% hw2_2.m, UPLINK

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

% 2-1
[v_x,v_y,c_x,c_y]=hexagon(0,0,ms_num);
hold on;
plot(c_x, c_y, '.');
plot(v_x,v_y);
xlabel('Distance(m)'), ylabel('Distance(m)');
title('fig. 2-1');
hold off;

% 2-2
d = sqrt(c_x.^2 + c_y.^2);
gc = twoRayGnd(h_bs, h_md, d);
gc_db = todB(gc);
pr_bs_db = p_ms_db + gt_db + gr_db + gc_db;

figure;
scatter(d, pr_bs_db);
xlabel('Distance(m)'), ylabel( 'Received Power(dB)');
title('fig. 2-2');

% 2-3
noise = thermNoise(T + 273.15, bw);
pr_bs = fromdB(pr_bs_db);
pr_bs_total = sum(pr_bs);
inter = pr_bs_total - pr_bs;
sinr = sinrDB(pr_bs,inter,noise);

figure;
scatter(d, sinr);
xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('fig. 2-3');
