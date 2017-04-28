function [maxX, maxY, vX, vY] = mobile_map(X, Y, baseX, baseY, is_text, is_draw)
    dist = 500;
    side = dist/sqrt(3);
    bs_x = X + baseX;
    bs_y = Y + baseY;

    for i = 1:19
        [v_x{i}, v_y{i}] = hexagon_v(side, bs_x(i), bs_y(i), is_draw);
        if is_text == 1
            text(bs_x(i), bs_y(i), int2str(i));
        end
        if i == 1
            vX = v_x{1};
            vY = v_y{1};
        else
            [vX, vY] = polybool(vX, vY, v_x{i}, v_y{i}, 'union');
        end
    end
    maxX = max(vX);
    maxY = max(vY);
    clear i;
end
