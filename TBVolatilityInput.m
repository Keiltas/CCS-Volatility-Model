classdef TBVolatilityInput
   properties
    volatilityTTM;
    rfRate;
    ForwardPrice;

    ATMVolatility;
    BreakpointScaleFactor;

    SlopeLeft; 
    SlopeRight;

    SwimCorrelation;
    SwimReferencePrice;  

    sd; 
    vd;
    
    multiplier;
    baseSmileWeight;
    multiplierSmileWeight;
    
   end
   methods
      function obj = TBVolatilityInput(InputFile)
          run(InputFile);
          
          obj.volatilityTTM = volatilityTTM;
          obj.rfRate = rfRate;
          obj.ForwardPrice = ForwardPrice;
          obj.ATMVolatility = ATMVolatility;
          obj.BreakpointScaleFactor = BreakpointScaleFactor;
          
          obj.SlopeLeft = SlopeLeft;
          obj.SlopeRight = SlopeRight;
          obj.SwimCorrelation = SwimCorrelation;
          obj.SwimReferencePrice = SwimReferencePrice;
          
          obj.sd = sd;
          obj.vd = vd;
          obj.multiplier = multiplier;
          obj.baseSmileWeight = baseSmileWeight;
          obj.multiplierSmileWeight = multiplierSmileWeight;
      end
   end
end



