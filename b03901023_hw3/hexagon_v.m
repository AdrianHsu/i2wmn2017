function [v_x, v_y] = hexagon_v(side, x0, y0, draw)
    v_x = side * cos((0:6)*pi/3) + x0;
    v_y = side * sin((0:6)*pi/3) + y0;
    if draw == 1
        plot(v_x, v_y);
        scatter(x0, y0, 'r');
        title('figure B-1');
        xlabel('distance(m)'), ylabel('distance(m)');
    end
end
