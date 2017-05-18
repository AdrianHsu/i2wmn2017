clc;
clear;

dist    = 500;          % inter site distance
side   = dist/sqrt(3);
ms_num = 50;
sim_time = 1000;
T0 = 27;
T = T0 + 273.15;
bw  = 10e6;
h_ms = 1.5;
h_bs    = 51.5;
p_bs_dbm = 33;
p_bs_db = p_bs_dbm - 30;
p_ms   = 0  - 30;      % MS power = 0  dBm
gr_db = 14;
gt_db = 14;
label = 10;

bs_x = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

%% B-1 MS & central BS scatter
figB_1 = figure();
set (figB_1,'Visible','off');
hold on;
[x,y] = hexagon_c(0, 0, ms_num);
scatter(x, y);
is_draw = 1;
[v_x, v_y] = hexagon_v(side, 0, 0, is_draw);

title('MS & BS scatter');
xlabel('Distance(m)'), ylabel('Distance(m)');
hold off;
saveas(figB_1,'B_1.jpg');

%% B-2 Shannon capacity to distance
% B = B_tot / num_MS;
% Noise = myThermalNoise(T, B);
%
% % get distance b/w each MS & BS
% d = zeros(19,num_MS);
% for i = 1:19
%     d_x = x-BS_X(i);
%     d_y = y-BS_Y(i);
%     d(i,:) =  sqrt(d_x.^2 + d_y.^2);
% end
%
% G_C = G_two_ray_ground(H_T, H_MS, d);
% G_C_dB = todB(G_C);
% power = P_BS + G_T_dB + G_R_dB + G_C_dB;
% power = fromdB(power);
% P_R_MS =  power(10,:);
% I_t = sum(power,1) - power(10,:);
% SINR = mySINR( P_R_MS, I_t, Noise);
%
% capacity = B * log2(1+fromdB(SINR));
% distance = sqrt(x .^ 2 + y .^ 2);
%
% figB_2 = figure();
% set (figB_2,'Visible','off');
% scatter(distance, capacity / 1e6, 20, 'o', 'filled');
% xlabel('Distance(m)'), ylabel( 'Shannon capacity (Mbps)');
% title('Shannon capacity to distance');
% saveas(figB_2,'B_2.jpg');
% %% B-3 Bits Loss Probability to Traffic Load
% buffersize = 1e6;
% missrate = zeros(1,3);
% lambda = 1e6 * [1.5,0.5,0.2];
% for type = 1 : 3
%     buffer = zeros(1,num_MS);
%     miss = zeros(1,num_MS);
%     for t = 1:sim_time
%         rate = poissrnd(lambda(type));
%         data = rate + buffer;
%         oversize = data - capacity;
%         overflow = oversize > 0;
%         buffer(~overflow) = 0;
%         oversize(~overflow) = 0;
%         temp = 0; % how many bits store in buffer
%         for i = 1 : num_MS
%             if overflow(i)
%                 if temp + oversize(i) <= buffersize
%                     temp = temp + oversize(i);
%                     buffer(i) = oversize(i);
%                 else
%                     stop = i;
%                     store = buffersize - temp;
%                     loss = oversize(i) - store;
%                     miss(i) = miss(i) + loss ;
%                     buffer(i) = store;
%                     break;
%                 end
%             end
%         end
%         miss(stop+1:num_MS) = miss(stop+1:num_MS) + oversize(stop+1:num_MS);
%         buffer(stop+1:num_MS) = 0;
%     end
%     missrate(type) = sum(miss) / (sim_time * num_MS * rate);
% end
% figB_3 = figure();
% set (figB_3,'Visible','off');
% bar(missrate);
% set(gca,'XTickLabel',{'high','medium','low'})
% for i = 1:3
%     text(i, missrate(i)+0.05, num2str(missrate(i)));
% end
% xlabel('Traffic Load');
% ylabel('Bits Loss Probability(%)');
% title('Poisson random distribution');
% axis([0.5,3.5,0,1]);
% saveas(figB_3,'B_3.jpg');
