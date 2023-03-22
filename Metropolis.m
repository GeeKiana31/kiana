classdef Metropolis
    properties
        samples
    end
    
    properties (Access = private)
        logTarget
        state
        sigma
        accProb
    end
    
    methods
        function obj = Metropolis(logTarget, initialState)

            obj.logTarget = logTarget;
            obj.state = initialState;
            obj.sigma = 1;
            obj.accProb = 0;
            obj.samples = [];
        end
        
        function self = adapt(self, blockLengths)
            targetAccRate = 0.4;
            nBlocks = numel(blockLengths);
            for iBlock = 1:nBlocks
                blockLength = blockLengths(iBlock);
                accCount = 0;
                for iIter = 1:blockLength
                    proposal = normrnd(self.state, self.sigma);
                    if self.accept(proposal)
                        self.state = proposal;
                        accCount = accCount + 1;
                    end
                end
                accRate = accCount / blockLength;
                self.sigma = self.sigma * (accRate / targetAccRate) ^ 1.1;
            end
        end
        
        function self = sample(self, n)
            for iSample = 1:n
                proposal = normrnd(self.state, self.sigma);
                if self.accept(proposal)
                    self.state = proposal;
                end
                self.samples(iSample) = self.state;
            end
        end
        
        function summ = summary(self)
            meanVal = mean(self.samples);
            credInt = prctile(self.samples, [2.5 97.5]);
            summ.mean = meanVal;
            summ.c025 = credInt(1);
            summ.c975 = credInt(2);
        end
    end
    
    methods (Access = private)
        function yesno = accept(self, proposal)
            logAccProb = self.logTarget(proposal) - self.logTarget(self.state);
            if logAccProb >= 0
                yesno = true;
            else
                accProb = exp(logAccProb);
                if rand < accProb
                    yesno = true;
                else
                    yesno = false;
                end
            end
            self.accProb = (self.accProb + yesno) / 2;
        end
    end
end