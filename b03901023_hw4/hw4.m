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

bs_x = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

% 4-1
hold on;
[x,y] = hexagon_c(0, 0, ms_num);
scatter(x, y);
is_draw = 1;
[v_x, v_y] = hexagon_v(side, 0, 0, is_draw);

title('figure 4-1');
xlabel('Distance(m)');
ylabel('Distance(m)');
figure;
hold off;

% 4-2
channel_bw = bw / ms_num;
noise = thermNoise(T, channel_bw);

d = zeros(19,ms_num);
for i = 1:19
    d_x = x - bs_x(i);
    d_y = y - bs_y(i);
    d(i,:) = sqrt(d_x.^2 + d_y.^2);
end

gc = twoRayGnd(h_bs, h_ms, d);
gc_db = todB(gc);
power = p_bs_db + gt_db + gr_db + gc_db;
power = fromdB(power);
pr_ms =  power(10,:);
i_t = sum(power,1) - power(10,:);
sinr = sinrDB( pr_ms, i_t, noise );

C = channel_bw * log2( 1 + fromdB(sinr) );
distance = sqrt(x .^ 2 + y .^ 2);
scatter(distance, C / 1e6, 20, 'o', 'filled');

xlabel('Distance(m)');
ylabel( 'Shannon Capacity(Mbps)');
title('figure 4-2');
figure;

% 4-3
CBR = [0.25, 0.5 , 1]*10^6; %constant bit rate, CBR parameters {Xl, Xm, Xh}
bitloss = zeros(1,3);
total_bit = zeros(1,3); %total bits
rem_buff = ones(1,3)*bw; %remain buffer
for t = 1:sim_time
    for i=1:ms_num
        for k=1:3 %rate low medium high
            temp_arrival = CBR(k);
            total_bit(1,k) = total_bit(1,k) + temp_arrival;
            if C(1, i) < temp_arrival %rate > capacity , goes to buffer
                rem_buff(1,k) = rem_buff(1,k) - (temp_arrival-C(1, i));
                if (rem_buff(1,k) < 0) %buffer is full
                    bitloss(1,k) = bitloss(1,k) - rem_buff(1,k);
                    rem_buff(1,k) = 0;
                end
            end
        end
    end
end

loss_prob = bitloss ./ total_bit;

bar(CBR , loss_prob);
title('figure 4-3')
xlabel('traffic load(bits/s)')
ylabel('bits loss probability')
