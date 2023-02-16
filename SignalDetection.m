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
    end
end