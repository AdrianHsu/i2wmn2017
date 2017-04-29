% hw3_bonus.m

T0 = 27;
T = T0 + 273.15;
ms_num = 100;
cell_num = 19;
sim_time = 900;
bw = 10e6;
h_bs = 51.5;
gr_db = 14;
gr = fromdB(gr_db);

p_bs_dbm = 33;
p_bs_db = p_bs_dbm - 30;
dist = 500;
side = dist/sqrt(3);

%% B-1. Please give a figure to describe how you arrange cell IDs to Fig. 1.
bs_x = side * [-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist * [-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

baseX = side * [4.5, 7.5, 3, -4.5, -7.5, -3];
baseY = dist * [3.5, -0.5, -4, -3.5, 0.5, 4];

figure;
hold on;
[maxX, maxY, vX, vY] = mobile_map(bs_x, bs_y, 0, 0, 1, 1); %vX, vY are boundaries
for i = 1:6
    hold on;
    [cX{i}, cY{i}] = mobile_map(bs_x, bs_y, baseX(i), baseY(i), 0, 0);
end
hold off;

%% B-2. Please plot a map with all mobile devices in their initial location.
hold on;
myrand = randi( cell_num, [1, ms_num] );
for i = 1:cell_num
    mysum = sum(myrand == i);
    if mysum > 0
        [x, y] = hexagon_c(bs_x(i), bs_y(i), mysum);
        posX{i} = x;
        posY{i} = y;
    end
end
hold off;

% obj initialization
idx = 1;
for i = 1:cell_num
    lenX = size(posX{i}, 2);
    for j = 1:lenX
        mobile{idx} = rw_mobile(posX{i}(j), posY{i}(j), 0, 0, 0, i);
        [mobile{idx}, testX, testY] = mobile{idx}.move();
        idx = idx + 1;
    end
end

% plot mobile devices
figure;
hold on;
mobile_map(bs_x, bs_y, 0, 0, 1, 1);
for i = 1:ms_num
    [mobile_X, mobile_Y] = mobile{i}.getGeometry();
    text(mobile_X, mobile_Y, int2str(i));
end
title('Figure B-2');
xlabel('Distance(m)'), ylabel('Distance(m)');

% entend the map
pow = map_extend(mobile, vX, vY, cX, cY, baseX, baseY);
% calculate sinr
col_sum = sum(pow, 2);
inter = zeros(cell_num, ms_num);
noise = thermNoise(T, bw);
for i = 1:cell_num
    inter(i,:) = col_sum(i) - pow(i,:);
end
sinr = sinrDB(pow, inter, noise);

%% B-3. Based on B-1, find the handoff event and the related cell ID
[~, upper] = max(sinr);
content = cell(1,3);
for i = 1:ms_num
    [mobile{i}, content] = mobile{i}.getHandoff(upper(i), content);
end
table = cell2table(content, 'VariableNames', {'Time' 'Source_cell_ID' 'Destination_ID'});
writetable(table, 'data.csv');
