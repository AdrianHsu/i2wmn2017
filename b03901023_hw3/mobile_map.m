function [borderX, borderY] = mobile_map(side, X, Y, baseX, baseY, label, draw)

    bs_x = X + baseX;
    bs_y = Y + baseY;
    hold on;
    si = 19;
    for i = 1:si
        [edgeX{i}, edgeY{i}] = hexagon_border(side, bs_x(i), bs_y(i), draw);
        if label == 1
            text(bs_x(i), bs_y(i), int2str(i));
        end
        if i == 1
            borderX = edgeX{i};
            borderY = edgeY{i};
        else
            [borderX, borderY] = polybool(borderX, borderY, edgeX{i}, edgeY{i}, 'union');
        end
    end
    clear i;
end
