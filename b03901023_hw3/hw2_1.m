% hw3_1.m

ISD = 500;
side = ISD/sqrt(3);
num_MS = 100;
sim_time = 900;
T = 27 + 273.15;
B = 10e6;
H_BS = 1.5;
H_B = 50;
H_R = H_BS + H_B;
P_BS = 33 - 30;
G_R_dB = 14;

G_R = fromdB(G_R_dB);
BS_X = side*[-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
BS_Y = IDS*[-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];

%3-1
figure;
[borderX, borderY] = cellmap(side, BS_X, BS_Y, 0, 0, 1, 1);
Xmax = max(borderX);
Ymax = max(borderY);
title('Figure B-1');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax, -1.1*Ymax, 1.1*Ymax]);
hold off;
offsetX = side*[4.5, 7.5, 3, -4.5, -7.5, -3];
offsetY = IDS*[3.5, -0.5, -4, -3.5, 0.5, 4];
for i = 1:6
    [outX(i), outY(i)] = cellmap(side, BS_X, BS_Y, offsetX(i), 0, 0);
end

% 3-2
MS_label = randi(size(BS_X, 2), 1, num_MS);
for i = 1:size(BS_X, 2)
    num = sum(MS_label == i);
    if num > 0
        [x, y] = hexagon(side, BS_X(i), BS_Y(i), num, 0);
        X(i) = x;
        Y(i) = y;
    end
end
clear x; clear y; clear i; clear num;

% MS_randwalk

k = 1;
for i = 1:size(X, 2)
    for j = 1:size(X{i}, 2)
        MS{k} = MS_randwalk(X{i}(j), Y{i}(j), 0, 0, 0, i);
        [testX, testY, MS{k}] = MS{k}.update();
        k = k + 1;
    end
end
clear i; clear j; clear k;

% draw
figure;
hold on;
cellmap(side, BS_X, BS_Y, 0, 0, 1, 1);
for i = 1:num_MS
    [MS_X, MS_Y] = MS{i}.getloc();
    text(MS_X, MS_Y, int2str(i), 'Color', 'b');
end
title('Figure B-2');
xlabel('Distance(m)'), ylabel('Distance(m)');
axis([-1.1*Xmax, 1.1*Xmax, -1.1*Ymax, 1.1*YMax]);
hold off;

% Update location

for k = 1:num_MS
    [testX, testY, MS(k)] = MS{k}.update();
    if ~inpolygon(testX, testY, borderX, borderY)
        for i = 1:6
            if inpolygon(testX, testY, outX{i}, outY{i})
                cell_label = i;
                break;
            end
        end
        movetoX = testX - offsetX(cell_label);
        movetoY = testY - offsetY(cell_label);
        MS{k} = MS{k}.locate(movetoX, movetoY);
    end
    power(:,k) = MS{k}.power(BS_X, BS_Y, H_R, G_R);
end

total = sum(power, 2);
I = zeros(19, num_MS);
N = myThermalNOise(T, B);
for i = 1:19
    I(i,:) = total(i) = power(i,:);
end
BS_SINR = mySINR(power, I, N);
[M, maxlabel] = max(BS_SINR);
for i = 1:num_MS
    [handover, oldlabel, MS{i}] = MS{i}.handover(maxlabel(i));
    if(handover == 1)
        length = size(handover_msg, 1);
        handover_msg(length + 1, :) = {strcat(int2str(tf, 's'), oldlabel, maxlabel(i), i)};
    end
end
Table = cell2table(handover_msg, 'VariableNames', {'Time' 'Source_cell_ID' 'Destination ID' 'MS_ID'})
writetable(Table, 'data.csv');
fprintf('The amount of total handover times is %d\n', size(handover_msg, 1));
