% hw3_bonus.m

T0 = 27;
T = T0 + 273.15;
ms_num = 100;
sim_time = 900;
bw = 10e6;
h_bs = 51.5;
gr_db = 14;
gr = fromdB(gr_db);

p_bs_dbm = 33;
p_bs_db = p_bs_dbm - 30;
dist = 500;
side = dist/sqrt(3);


%3-1
bs_x = side * [-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist * [-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];
figure;
[maxX, maxY, borderX, borderY] = mobile_map(side, bs_x, bs_y, 0, 0, 1, 1);
title('Figure B-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
hold off;
baseX = side * [4.5, 7.5, 3, -4.5, -7.5, -3];
baseY = dist * [3.5, -0.5, -4, -3.5, 0.5, 4];
for i = 1:6
    [outX{i}, outY{i}] = mobile_map(side, bs_x, bs_y, baseX(i), baseY(i), 0, 0);
end

% % 3-2
mobile_label = randi(size(bs_x, 2), 1, ms_num);
for i = 1:size(bs_x, 2)
    num = sum(mobile_label == i);
    if num > 0
        [x, y] = hexagon_c(bs_x(i), bs_y(i), num);
        X{i} = x;
        Y{i} = y;
    end
end
clear x; clear y; clear i; clear num;
%
% % rw_mobile
%
k = 1;
for i = 1:size(X, 2)
    for j = 1:size(X{i}, 2)
        mobile{k} = rw_mobile(X{i}(j), Y{i}(j), 0, 0, 0, i);
        [testX, testY, mobile{k}] = mobile{k}.update();
        k = k + 1;
    end
end
clear i; clear j; clear k;


% % draw
figure;
hold on;
mobile_map(side, bs_x, bs_y, 0, 0, 1, 1);
for i = 1:ms_num
    [mobile_X, mobile_Y] = mobile{i}.getGeometry();
    text(mobile_X, mobile_Y, int2str(i), 'Color', 'b');
end
title('Figure B-2');
xlabel('Distance(m)'), ylabel('Distance(m)');
hold off;

%
% % Update location
%
for k = 1:ms_num
    [testX, testY, mobile{k}] = mobile{k}.update();
    if ~inpolygon(testX, testY, borderX, borderY)
        cell_label = 1;
        for i = 1:6
            if inpolygon(testX, testY, outX{i}, outY{i})
                cell_label = i;
                break;
            end
        end
        movetoX = testX - baseX(cell_label);
        movetoY = testY - baseY(cell_label);
        mobile{k} = mobile{k}.locate(movetoX, movetoY);
    end
    p(:,k) = mobile{k}.power(bs_x, bs_y, h_bs, gr);
end
%
total = sum(p, 2);
inter = zeros(19, ms_num);
N = thermNoise(T, bw);
for i = 1:19
    inter(i,:) = total(i) - p(i,:);
end
BS_SINR = sinrDB(p, inter, N);
[M, maxlabel] = max(BS_SINR);
for i = 1:ms_num
    [handoff, oldlabel, mobile{i}] = mobile{i}.handoff(maxlabel(i));
    if(handoff == 1)
        if i == 1
            length = 0;
        else
            length = size(handoff_msg, 1);
        end
        handoff_msg(length + 1, :) = {strcat(int2str(i),'s'), oldlabel, maxlabel(i)};
    end
end
Table = cell2table(handoff_msg, 'VariableNames', {'Time' 'Source_cell_ID' 'Destination_ID'});
writetable(Table, 'data.csv');
fprintf('The amount of total handoff times is %d\n', size(handoff_msg, 1));
