%ref: https://www.mathworks.com/matlabcentral/answers/33593-generate-uniformly-distributed-points-inside-a-hexagon
function [c_x, c_y] = hexagon(x0, y0, ms_num)

    dist = 500;
    N = ms_num; %ms_num = 50, Number of users
    R = dist/sqrt(3); %Radius of Hexagon
    %Define the vertexes of the hexagon. They for angles 0, 60, 120, 180, 240 and 300 withe origin. %Vertexes
    v_x = R * cos((0:6)*pi/3);
    v_y = R * sin((0:6)*pi/3);
    %The method used here is to generate many points in a square and choose N points that fall within the hexagon
    %Generate 3N random points with square that is 2R by 2R
    c_x = R-rand(1, 3*N)*2*R; c_y = R-rand(1, 3*N)*2*R;
    %There is a command in MATLAB inploygon.
    %The command finds points within a polygon region. %get the points within the polygon
    IN = inpolygon(c_x + x0, c_y + y0, v_x + x0, v_y + y0);

    %drop nodes outside the hexagon
    c_x = c_x(IN); c_y = c_y(IN);
    %choose only N points
    idx = randperm(N);
    c_x = c_x(idx(1:N)) + x0;
    c_y = c_y(idx(1:N)) + y0;
    v_x = v_x + x0;
    v_y = v_y + y0;
    plot(v_x, v_y);
end
