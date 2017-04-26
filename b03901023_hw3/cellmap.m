function [borderX, borderY] = cellmap(size, X, Y, centralX, centralY, label, draw)

    BS_X = X + centralX;
    BS_Y = Y + centralY;
    hold on;
    for i = 1:size(BS_X, 2)
        [edgeX{i}, edgeY{i}] = hexagonborder(side, BS_X(i), BS_Y(i), draw);
        if label == 1
            text(BS_X(i), BS_Y(i), int2str(i));
        end
        if i == 1
            borderX = edgeX{i};
            borderY = edgeY{i};
        else
            [borderX, borderY] = polibool('union', borderX, borderY, edgeX{i}, edgeY{i});
        end
    end
    clear i;
