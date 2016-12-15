function tay = TaylorInterpolation(S, delta, gamma, dS, IsSkewIncluded, varargin)
 
    if (IsSkewIncluded == 0) % only 'classic' delta and gamma are used, volatility dependence on spot price is ignored.
        tay = S + delta * dS + 0.5 * gamma * dS^2;
    elseif (IsSkewIncluded == 1)
        %dealing with non-neccessary parameters.
        if (nargin == 5)
            error('When skew pricing, at least one second order Greek is assumed to be set.');
        end
        
        vega = 0;
        vanna = 0;
        vomma = 0;

        if (nargin > 5)
            vega = varargin{1};
        end
        if (nargin > 6)
            vanna = varargin{2};
        end
        if (nargin > 7)
            vomma = varargin{3};
        end
          
        VolatilitySlope = -0.011;       %????????????????????????
        VolatilityCurvature = 0.02;   %????????????????????????
        SkewDelta = delta +  vega * VolatilitySlope;
        SkewGamma = gamma + 2 * vanna * VolatilitySlope +  vomma * (VolatilitySlope) ^ 2 + vega * VolatilityCurvature;
        tay = S + SkewDelta * dS + 0.5 * SkewGamma * dS^2;
    else
        error('Unexpected "IsSkewIncluded" parameter value, 0 or 1 assumed.');
    end
end