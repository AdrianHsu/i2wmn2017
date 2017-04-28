classdef MS_randwalk
    properties
        x
        y
        speed
        theta
        time
        label
    end
    properties(Constant = true, Hidden = true)
        minSpeed = 1;
        maxSpeed = 15;
        minT = 1;
        maxT = 6;
        P_MS = 23 - 30;
        G_T_dB = 14;
        H_MS = 1.5;
    end
    methods
        function obj = MS_randwalk(x, y, speed, theta, time, label)
            if nargin == 6
                obj.x = x;
                obj.y = y;
                obj.speed = speed;
                obj.theta = theta;
                obj.time = time;
                obj.label = label;
            else
                obj.x = 0;
                obj.y = 0;
                obj.speed = 0;
                obj.theta = 0;
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
        function P_T = power(obj, x_b, y_b, H_R, G_R)
            d_x = obj.x - x_b;
            d_y = obj.y - y_b;
            d_t = sqrt(d_x.^2 + d_y.^2);
            G_C = twoRayGnd(obj.H_MS, H_R, d_t);
            P_T = fromdB(obj.P_MS, obj.G_T_dB) * G_C * G_R;
        end
        function draw(obj)
            scatter(obj.x, obj.y, 'b');
        end
        function [x,y] = getloc(obj)
            x = obj.x;
            y = obj.y;
        end
        function [handover, oldlabel, obj] = handover(obj, maxlabel)
            if obj.label == maxlabel
                handover = 0;
                oldlabel = obj.label;
            else
                handover = 1;
                oldlabel = obj.label;
                obj.label = maxlabel;
            end
        end
    end
end
