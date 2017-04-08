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
plot(c_x, c_y, '.');
xlabel('Distance(m)'), ylabel('Distance(m)');
title('fig. 1-1');
Xmax = 4*side;
Ymax = 2.5*dist;
axis([-1.1*Xmax, 1.1*Xmax,-1.1*Ymax, 1.1*Ymax])
hold off;

% BONUS, B-2
for i = 1:bs_num
    d_x(i,:) = c_x(i,:) - bs_x(i);
    d_y(i,:) = c_y(i,:) - bs_y(i);
end
d_t = sqrt(d_x.^2 + d_y.^2);
gc = twoRayGnd(h_bs, h_md, d_t);
gc_db = todB(gc);
pr_bs_db = p_ms_db + gt_db + gr_db + gc_db;
pr_bs = fromdB(pr_bs_db);

figure;
scatter(d_t(:), pr_bs_db(:),10);    % (:) to become a vector
xlabel('Distance(m)');
ylabel('Received Power(dB)');
title('fig. 3-2');

% BONUS, B-3
noise = thermNoise(T + 273.15, bw);
inter = zeros(bs_num,ms_num);

figure;
hold on;
for i = 1:bs_num
    d_x = c_x - bs_x(i);
    d_y = c_y - bs_y(i);
    d_t = sqrt(d_x.^2 + d_y.^2);

    gc = twoRayGnd(h_bs, h_md, d_t);
    gc_db = todB(gc);
    power_dB = p_ms_db + gt_db + gr_db + gc_db;
    power = fromdB(power_dB);

    tmp = sum(power);
    total = sum(tmp);

    d = d_t(i,:);
    obs = pr_bs(i,:);
    inter(i,:) = total - obs;
    sinr = sinrDB(obs,inter(i,:),noise);
    scatter(d,sinr);
end

xlabel('Distance(m)'), ylabel( 'SINR(dB)');
title('fig. 3-3');
legend('BS1', 'BS2', 'BS3', 'BS4', 'BS5', 'BS6', 'BS7', 'BS8', 'BS9', 'BS10', 'BS11', 'BS12', 'BS13', 'BS14', 'BS15', 'BS16', 'BS17', 'BS18', 'BS19');
hold off;
