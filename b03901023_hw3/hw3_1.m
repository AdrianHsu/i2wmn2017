% hw3_1.m

dist = 500;
side = dist/sqrt(3);
ms_num = 100;
sim_time = 900;
T0 = 27;
T = T0 + 273.15;
B = 10e6;
h_bs = 51.5;
p_bs_dbm = 33;
p_bs_db = p_bs_dbm - 30;
gr_db = 14;

gr = fromdB(gr_db);
bs_x = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
bs_y = dist*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

%3-1
figure;
[borderX, borderY] = cellmap(side, bs_x, bs_y, 0, 0, 1, 1);
Xmax = max(borderX);
Ymax = max(borderY);
title('Figure B-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
% axis([-1.1*Xmax, 1.1*Xmax, -1.1*Ymax, 1.1*Ymax]);
hold off;
offsetX = side*[4.5, 7.5, 3, -4.5, -7.5, -3];
offsetY = dist*[3.5, -0.5, -4, -3.5, 0.5, 4];
for i = 1:6

    [outX{i}, outY{i}] = cellmap(side, bs_x, bs_y, offsetX(i), offsetY(i), 0, 0);
end

% % 3-2
MS_label = randi(size(bs_x, 2), 1, ms_num);
for i = 1:size(bs_x, 2)
    num = sum(MS_label == i);
    if num > 0
        [x, y] = hexagon(bs_x(i), bs_y(i), num);
        X{i} = x;
        Y{i} = y;
    end
end
clear x; clear y; clear i; clear num;
%
% % MS_randwalk
%
k = 1;
for i = 1:size(X, 2)
    for j = 1:size(X{i}, 2)
        MS{k} = MS_randwalk(X{i}(j), Y{i}(j), 0, 0, 0, i);
        [testX, testY, MS{k}] = MS{k}.update();
        k = k + 1;
    end
end
clear i; clear j; clear k;


% % draw
figure;
hold on;
cellmap(side, bs_x, bs_y, 0, 0, 1, 1);
for i = 1:ms_num
    [MS_X, MS_Y] = MS{i}.getloc();
    text(MS_X, MS_Y, int2str(i), 'Color', 'b');
end
title('Figure B-2');
xlabel('Distance(m)'), ylabel('Distance(m)');
% axis([-1.1*Xmax, 1.1*Xmax, -1.1*Ymax, 1.1*Ymax]);
hold off;

%
% % Update location
%
% for k = 1:ms_num
%     [testX, testY, MS(k)] = MS{k}.update();
%     if ~inpolygon(testX, testY, borderX, borderY)
%         for i = 1:6
%             if inpolygon(testX, testY, outX{i}, outY{i})
%                 cell_label = i;
%                 break;
%             end
%         end
%         movetoX = testX - offsetX(cell_label);
%         movetoY = testY - offsetY(cell_label);
%         MS{k} = MS{k}.locate(movetoX, movetoY);
%     end
%     power(:,k) = MS{k}.power(bs_x, bs_y, h_bs, gr);
% end
%
% total = sum(power, 2);
% I = zeros(19, ms_num);
% N = thermNoise(T, B);
% for i = 1:19
%     I(i,:) = total(i) - power(i,:);
% end
% BS_SINR = sinrDB(power, I, N);
% [M, maxlabel] = max(BS_SINR);
% for i = 1:ms_num
%     [handover, oldlabel, MS{i}] = MS{i}.handover(maxlabel(i));
%     if(handover == 1)
%         length = size(handover_msg, 1);
%         handover_msg(length + 1, :) = {strcat(int2str(tf, 's'), oldlabel, maxlabel(i), i)};
%     end
% end
% Table = cell2table(handover_msg, 'VariableNames', {'Time' 'Source_cell_ID' 'Destination ID' 'MS_ID'})
% writetable(Table, 'data.csv');
% fprintf('The amount of total handover times is %d\n', size(handover_msg, 1));
