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
figure;
title('figure 4-1');
xlabel('Distance(m)');
ylabel('Distance(m)');
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

capacity = channel_bw * log2( 1 + fromdB(sinr) );
distance = sqrt(x .^ 2 + y .^ 2);
scatter(distance, capacity / 1e6, 20, 'o', 'filled');
figure;
xlabel('Distance(m)');
ylabel( 'Shannon Capacity(Mbps)');
title('figure 4-2');

% 4-3
buffersize = 1e6;
missrate = zeros(1,3);
CBR = 1e6 * [1,0.5,0.2];
for type = 1 : 3
    buffer = zeros(1,ms_num);
    miss = zeros(1,ms_num);
    rate = CBR(type);
    for t = 1:sim_time
        data = rate + buffer;
        oversize = data - capacity;
        overflow = oversize > 0;
        buffer(~overflow) = 0;
        oversize(~overflow) = 0;
        temp = 0;
        for i = 1 : ms_num
            if overflow(i)
                if temp + oversize(i) <= buffersize
                    temp = temp + oversize(i);
                    buffer(i) = oversize(i);
                else
                    stop = i;
                    store = buffersize - temp;
                    loss = oversize(i) - store;
                    miss(i) = miss(i) + loss ;
                    buffer(i) = store;
                    break;
                end
            end
        end
        miss(stop+1:ms_num) = miss(stop+1:ms_num) + oversize(stop+1:ms_num);
        buffer(stop+1:ms_num) = 0;
    end
    missrate(type) = sum(miss) / (sim_time * ms_num * rate);
end
bar(missrate);
set(gca,'XTickLabel',{'high','medium','low'})
for i = 1:3
    text(i, missrate(i)+0.05, num2str(missrate(i)));
end

xlabel('Traffic Load');
ylabel('Bits Loss Probability(%)');
title('Constant Bits Rate');
axis([0.5,3.5,0,1]);
