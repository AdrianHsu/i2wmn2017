classdef rw_mobile
    properties
        x
        y
        theta % a. moving direction between [0, 2pi] uniformly.
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
        function obj = rw_mobile(x, y, theta, speed, time, label)
            if nargin == 6 % default value, use nargin
                obj.x = x;
                obj.y = y;
                obj.theta = theta;
                obj.speed = speed;
                obj.time = time;
                obj.label = label;
            else
                obj.x = 0;
                obj.y = 0;
                obj.theta = 0;
                obj.speed = 0;
                obj.time = 0;
                obj.label = 0;
            end
        end
        function[obj, dum_x, dum_y] = move(obj)
            obj.x = obj.x + obj.speed * cos(obj.theta);
            dum_x = obj.x;
            obj.y = obj.y + obj.speed * sin(obj.theta);
            dum_y = obj.y;
            obj.time = obj.time - 1;
            if obj.time <= 0
                obj.speed = unifrnd(obj.minSpeed, obj.maxSpeed);
                obj.theta = unifrnd(1, 2*pi);
                interval = obj.maxT - obj.minT;
                obj.time = obj.minT + unidrnd(interval); 
            end
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
        function [handoff, oldlabel, obj] = handoff(obj, maxlabel)
            if obj.label == maxlabel
                handoff = 0;
                oldlabel = obj.label;
            else
                handoff = 1;
                oldlabel = obj.label;
                obj.label = maxlabel;
            end
        end
    end
end
