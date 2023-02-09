classdef SignalDetection
    properties
        hits
        misses
        FalseAlarms
        CorrectRejections
    end

    methods
        function obj = SignalDetection(hits, misses, FalseAlarms, ...
                CorrectRejections)
            obj.hits = hits;
            obj.misses = misses;
            obj.FalseAlarms = FalseAlarms;
            obj.CorrectRejections = CorrectRejections;
        end

        function HitRate = HitRate(obj)
            HitRate = obj.hits / (obj.hits + obj.misses);
        end

        function FARate = FARate(obj)
            FARate = obj.FalseAlarms / (obj.FalseAlarms + ...
                obj.CorrectRejections);
        end

        function d_prime = d_prime(obj)
            d_prime = norminv(obj.HitRate) - norminv(obj.FARate);
        end

        function criterion = criterion(obj)
            criterion = -0.5 * (norminv(obj.HitRate) + norminv(obj.FARate));
        end
    end
end