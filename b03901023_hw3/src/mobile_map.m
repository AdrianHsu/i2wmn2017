function [maxX, maxY, vX, vY] = mobile_map(X, Y, baseX, baseY, is_text, is_draw)
    dist = 500;
    side = dist/sqrt(3);
    bs_x = X + baseX;
    bs_y = Y + baseY;
    %init
    [v_x{1}, v_y{1}] = hexagon_v(side, bs_x(1), bs_y(1), is_draw);
    if is_text == 1
        text(bs_x(1), bs_y(1), int2str(1));
    end
    vX = v_x{1};
    vY = v_y{1};
    %put data
    for i = 2:19
        [v_x{i}, v_y{i}] = hexagon_v(side, bs_x(i), bs_y(i), is_draw);
        if is_text == 1
            text(bs_x(i), bs_y(i), int2str(i));
        end
        [vX, vY] = polybool('union', vX, vY, v_x{i}, v_y{i});
    end
    maxX = max(vX);
    maxY = max(vY);
end
