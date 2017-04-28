classdef rw_mobile
    properties
        x
        y
        theta % a. moving direction between [0, 2 π] uniformly.
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
        function[x, y, obj] = update(obj)
            obj.x = obj.x + obj.speed * cos(obj.theta);
            obj.y = obj.y + obj.speed * sin(obj.theta);
            obj.time = obj.time - 1;
            if obj.time <= 0
                [obj.speed, obj.theta, obj.time] = ms_update(obj.minSpeed, obj.maxSpeed, obj.minT, obj.maxT);
            end
            x = obj.x;
            y = obj.y;
        end
        function obj = locate(obj, movetoX, movetoY)
            obj.x = movetoX;
            obj.y = movetoY;
        end
        function [x,y] = getGeometry(obj)
            x = obj.x;
            y = obj.y;
        end
        function P_T = power(obj, x_b, y_b, H_R, G_R)
            d_x = obj.x - x_b;
            d_y = obj.y - y_b;
            d_t = sqrt(d_x.^2 + d_y.^2);
            G_C = twoRayGnd(obj.h_md, H_R, d_t);
            P_T = fromdB(obj.p_ms_db + obj.gt_db) * G_C * G_R;
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
