function [edgeX, edgeY] = hexagon_border(side, x0, y0, draw)
    L = linspace(0, 2*pi, 7);
    edgeX = side * cos(L) + x0;
    edgeY = side * sin(L) + y0;
    if draw == 1
        plot(edgeX, edgeY, 'r', 'Linewidth', 1);
        scatter(x0, y0, 'filled', 'g');
    end
end