function Volatility = GetTbricksVolatility(StrikePrice, Spline, SyntheticFP, StdDev, TBInputData)
   
   load(TBInputData);
   
   StrikeSD = BreakpointScaleFactor * (StrikePrice - SyntheticFP) / StdDev;
    
   Volatility = ((ppval(Spline, StrikeSD) + ATMVolatility) * baseSmileWeight(end)) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility;

end