clc;
clear;

ms_num = 50;
sim_time = 1000;
T0 = 27;
T = T0 + 273.15;
bw  = 10e6;
h_ms = 1.5;
h_bs    = 51.5;
p_bs_dbm = 33;
p_bs_db = p_bs_dbm - 30;
p_ms   = -30;
gr_db = 14;
gt_db = 14;
label = 10;
dist    = 500;
side   = dist/sqrt(3);
cell_num = 19;

bs_x = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

% B-1
hold on;
[x,y] = hexagon_c(0, 0, ms_num);
scatter(x, y);
is_draw = 1;
[v_x, v_y] = hexagon_v(side, 0, 0, is_draw);

title('figure B-1');
xlabel('Distance(m)');
ylabel('Distance(m)');
figure;
hold off;

% B-2
channel_bw = bw / ms_num;
noise = thermNoise(T, channel_bw);

d = zeros(cell_num,ms_num);
for i = 1:cell_num
    d_x = x - bs_x(i);
    d_y = y - bs_y(i);
    d(i,:) = sqrt(d_x.^2 + d_y.^2);
end

gc = twoRayGnd(h_bs, h_ms, d);
gc_db = todB(gc);
power = p_bs_db + gt_db + gr_db + gc_db;
power = fromdB(power);
pr_ms = power(10,:);
inter = sum(power,1) - power(10,:);
sinr = sinrDB(pr_ms, inter, noise);

cap = channel_bw * log2( 1 + fromdB(sinr) );
distance = sqrt(x.^ 2 + y.^ 2);
scatter(distance, cap, 'o');

xlabel('Distance(m)');
ylabel( 'Shannon Capacity(bps)');
title('figure B-2');
figure;

% 4-3
data_buff = zeros(ms_num, 3);
lambda = [0.2, 0.5, 1]*1e6;
total = [0,0,0];
missbit = [0,0,0];
remain = [1,1,1] * bw;
for p = 1:3
    buf = 0; % for total buffer
    for i=1:ms_num
        for t=1:sim_time
            arrive_rate = lambda(p);
            buf = buf + arrive_rate;
            if cap(i) < arrive_rate
                tmp = remain(p) - (arrive_rate - cap(i));
                if (tmp < 0)
                    missbit(p) = missbit(p) - tmp;
                    remain(p) = 0;
                else
                    remain(p) = tmp;
                end
            else
                tmp = cap(i) - arrive_rate;
                if data_buff(i,p) < tmp
                    remain(p) = remain(p) + data_buff(i,p);
                    data_buff(i,p) = 0;
                else
                    remain(p) = remain(p) + tmp;
                    data_buff(i,p) = data_buff(i,p) - tmp;
                end
            end
        end
    end
    total(p) = buf;
end
loss = missbit./total;

bar(lambda, loss, 'b');
xlabel('Traffic Load');
ylabel('Bits Loss Probability');
title('figure B-3');
