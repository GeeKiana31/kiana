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
            Total = SignalDetection(obj1.Hits + obj2.Hits, obj1.Misses + ...
                obj2.Misses, obj1.FalseAlarms + obj2.FalseAlarms, ...
                obj1.CorrectRejections + obj2.CorrectRejections);
        end

        function Scaled = mtimes(obj, k)
            Scaled = SignalDetection(obj.Hits * k, obj.Misses * k, ...
                obj.FalseAlarms * k, obj.CorrectRejections * k);
        end

%% Generate Plots
        function Plot_ROC = Plot_ROC(obj)
            xpoints = [0, obj.FARate, 1];
            ypoints = [0, obj.HitRate, 1];
            plot(xpoints, ypoints)
            xlim([0, 1]);
            xlabel('False Alarm Rate')
            ylabel('Hit Rate')
            title('ROC Curve')
        end

        function Plot_SDT = Plot_SDT(obj)
            x = [-5:.1:5];
            Noise = normpdf(x, 0, 1);
            Signal = normpdf(x, obj.D_Prime, 1);
            
            plot(x, Noise, x, Signal)
            xline(obj.D_Prime/2 + obj.Criterion, '--k', 'HandleVisibility','off')
            line([0 obj.D_Prime],[findpeaks(Noise), findpeaks(Signal)])
            ylim([0, .5])
            xlabel('Signal Strength')
            ylabel('Probability')
            legend('Noise', 'Signal')
            title('Signal Detection Theory Plot')
        end
    end
end