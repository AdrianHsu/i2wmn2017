classdef rw_mobile
    properties
        x
        y
        direction % a. moving direction between [0, 2pi] uniformly.
        speed % b. velocity between [minSpeed, maxSpeed] uniformly.
        time % c. moves t seconds, uniformly between [minT, maxT].
        label
    end
    properties(Constant = true)
        minSpeed = 1;
        maxSpeed = 15;
        minT = 1;
        maxT = 6;

        gt_db = 14;
        h_md = 1.5;
        p_ms_db = 23 - 30;
    end
    methods
        function obj = rw_mobile(x, y, direction, speed, time, label)
            if nargin == 6 % default value, use nargin
                obj.x = x;
                obj.y = y;
                obj.direction = direction;
                obj.speed = speed;
                obj.time = time;
                obj.label = label;
            else
                obj.x = 0;
                obj.y = 0;
                obj.direction = 0;
                obj.speed = 0;
                obj.time = 0;
                obj.label = 0;
            end
        end
        function[obj, x, y] = move(obj)
            obj.x = obj.x + obj.speed * cos(obj.direction);
            obj.y = obj.y + obj.speed * sin(obj.direction);
            obj.time = obj.time - 1;
            if obj.time <= 0
                obj.speed = unifrnd(obj.minSpeed, obj.maxSpeed);
                obj.direction = unifrnd(1, 2*pi);
                interval = obj.maxT - obj.minT;
                obj.time = obj.minT + unidrnd(interval); 
            end
            x = obj.x;
            y = obj.y;
        end
        function obj = extend(obj, newX, newY)
            obj.x = newX;
            obj.y = newY;
        end
        function dist = getDist(obj, x_b, y_b)
            distX = obj.x - x_b;
            distY = obj.y - y_b;
            dist = sqrt(distX.^2 + distY.^2);
        end
        function [x,y] = getGeometry(obj)
            x = obj.x;
            y = obj.y;
        end
        function pow = getPower(obj, dist, hr, gr)
            gc = twoRayGnd(obj.h_md, hr, dist);
            pow = fromdB(obj.p_ms_db + obj.gt_db) * gc * gr;
        end
        function [obj, content] = getHandoff(obj, t, upper, content)
            if obj.label ~= upper
                prev = obj.label;
                obj.label = upper;
                len = size(content, 1);
                content(len + 1, :) = {strcat(int2str(t),'s'), prev, upper};
                fprintf('yes: %d\n', t);
            else
                fprintf('not: %d\n', t);
                prev = obj.label;
            end
        end
    end
end
