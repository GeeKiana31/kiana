classdef SignalDetection
    properties
        Hits
        Misses
        FalseAlarms
        CorrectRejections
    end

    methods
        function obj = SignalDetection(Hits, Misses, FalseAlarms, ...
                CorrectRejections)
            obj.Hits = Hits;
            obj.Misses = Misses;
            obj.FalseAlarms = FalseAlarms;
            obj.CorrectRejections = CorrectRejections;
        end

        function HitRate = HitRate(obj)
            HitRate = obj.Hits / (obj.Hits + obj.Misses);
        end

        function FARate = FARate(obj)
            FARate = obj.FalseAlarms / (obj.FalseAlarms + ...
                obj.CorrectRejections);
        end

        function D_Prime = D_Prime(obj)
            D_Prime = norminv(obj.HitRate) - norminv(obj.FARate);
        end

        function Criterion = Criterion(obj)
            Criterion = -0.5 * (norminv(obj.HitRate) + norminv(obj.FARate));
        end

%% Operation Override 
        function Total = plus(obj1, obj2)
            Total = Vector(obj1.Hits + obj2.Hits, obj1.Misses + ...
                obj2.Misses, obj1.FalseAlarms + obj2.FalseAlarms, ...
                obj1.CorrectRejections + obj2.CorrectRejections);
        end

        function scaled = times(obj, k)
            scaled = Vector(obj.Hits .* k, obj.Misses .* k, ...
                obj.FalseAlarms .* k, obj.CorrectRejections .* k);
        end

%% Generate Plots
        function plot_roc = plot_roc(obj)
            plot_roc = plot(obj.HitRate, obj.FARate);
        end

        function plot_sdt = plot_sdt(obj)
            x = [-10:2:20];
            Noise = normpdf(x,0,1);
            Signal = normpdf(x,obj.D_Prime,1);
            plot(x,Noise)

            hold on

            plot(x,Signal)
            line(x,obj.D_Prime)

            hold off
        end
    end
end