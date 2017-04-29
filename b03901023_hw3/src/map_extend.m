function [mobile, p] = map_extend(mobile, vX, vY, cX, cY)
    
    ms_num = 100;
    dist = 500;
    side = dist/sqrt(3);
    bs_x = side * [-3,-3,-3,-1.5,-1.5,-1.5,-1.5,0,0,0,0,0,1.5,1.5,1.5,1.5,3,3,3];
    bs_y = dist * [-1,0,1,-1.5,-0.5,0.5,1.5,-2,-1,0,1,2,-1.5,-0.5,0.5,1.5,-1,0,1];
    baseX = side * [4.5, 7.5, 3, -4.5, -7.5, -3];
    baseY = dist * [3.5, -0.5, -4, -3.5, 0.5, 4];
    h_bs = 51.5;
    gr_db = 14;
    gr = fromdB(gr_db);
    
    for i = 1:ms_num
        [mobile{i}, newX, newY] = mobile{i}.move();
        if ~inpolygon(newX, newY, vX, vY)
            fprintf('newX:%d\n', newX);
            fprintf('newY:%d\n', newY);
            num = 1;
            
            
            for j = 1:6
                if inpolygon(newX, newY, cX{j}, cY{j})
                    num = j;
                    break
                end
            end
            fprintf('num:%d\n', num);
            mobile{i} = mobile{i}.extend(newX - baseX(num), newY - baseY(num));
        end
        dist = mobile{i}.getDist(bs_x, bs_y);
        p(:,i) = mobile{i}.getPower(dist, h_bs, gr);
    end
end
