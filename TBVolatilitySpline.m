classdef TBVolatilitySpline
   properties
       leftBound;
       rightBound;
       
       SyntheticFP;  % These values are stored to perform sd <=> strike price and vd <=> volatility conversions. 
       StdDev; 
       ATMVolatility;
       BreakpointScaleFactor;
       
       
       SlopeLeft;  % slopes of spline at the ends of the interval 
       SlopeRight; 
       
       type;
       
       spline;
   end
   methods
      function obj = TBVolatilitySpline(VolInput, ATMVolpath)
          
          if ((size(VolInput.sd, 1) ~=  size(VolInput.vd, 1)) || (size(VolInput.sd, 2) ~=  size(VolInput.vd, 2)))
            error('Dimensions of x and y coordinates have to b equal.');
          end
          if ((size(VolInput.sd, 1) ~=  1) || (size(VolInput.vd, 1) ~=  1))
            error('x and y coordinates are assumed to be row vectors.');
          end
          
          
          obj.ATMVolatility = ATMVolpath.GetValue(VolInput.ForwardPrice);
          % Preliminary calculations
          obj.SyntheticFP = VolInput.ForwardPrice ^ (VolInput.SwimCorrelation) * VolInput.SwimReferencePrice ^ (1.0 - VolInput.SwimCorrelation);
          obj.StdDev = obj.SyntheticFP * obj.ATMVolatility * sqrt(VolInput.volatilityTTM);
          obj.BreakpointScaleFactor = VolInput.BreakpointScaleFactor;
          obj.SlopeLeft = VolInput.SlopeLeft;
          obj.SlopeRight = VolInput.SlopeRight;
      
          % Node with sd = 0 is the reserved central node with strike equal
          % to synthetic forward and with volatility equal to ATM volatility 
          % (retrieved from ATM volatility path in Tbricks)
          % CHECK for sd = 0 in input data hasn't done!
          sd = VolInput.sd;
          vd = VolInput.vd;
          multiplier = VolInput.multiplier;
          baseSmileWeight = VolInput.baseSmileWeight;
          multiplierSmileWeight = VolInput.multiplierSmileWeight;   
          
          sd(size(sd, 2) + 1) = 0;
          vd(size(vd, 2) + 1) = 0;

          multiplier(size(sd, 2)) = 1;
          baseSmileWeight(size(sd, 2)) = 1;
          multiplierSmileWeight(size(sd, 2)) = 0;   

          % Between these two points, the spline is built. 
          % Beyond them, volatility stays constant (with value equal to one on the corresponding boundary)

          obj.leftBound(1) = min(sd);
          obj.rightBound(1) = max(sd);

          
          syms x y;
          if (size(sd, 2) ==  1)
              % ATM volatility input consists of a single point, path is constant in this case. 
              obj.type = 1;
              obj.spline = vd(1);
              obj.leftBound(2) = vd(1);
              obj.rightBound(2) = vd(1);
  
          elseif (size(sd, 2) ==  2)
              % ATM volatility input consists of two points, path is linear.
              
              obj.type = 2;
              A  = [ x y 1; sd(1) vd(1) 1; sd(2) vd(2) 1];
              S = double(coeffs(solve(det(A),y), 'All'));
              %obj.spline = [S(2), S(1)]
              obj.spline = [S(1), S(2)];
              obj.leftBound(2) = polyval(obj.spline, obj.leftBound(1));
              obj.rightBound(2) = polyval(obj.spline, obj.rightBound(1));
              
          elseif (size(sd, 2) ==  3)
              % ATM volatility input consists of three points, path is a parabola. 
              obj.type = 3;
              A  = [x^2 x y 1; sd(1)^2 sd(1) vd(1) 1; sd(2)^2 sd(2) vd(2) 1; sd(3)^2 sd(3) vd(3) 1];
              S = double(coeffs(solve(det(A),y), 'All'));
              obj.spline = [S(1), S(2), S(3)]; 
              obj.leftBound(2) = polyval(obj.spline, obj.leftBound(1));
              obj.rightBound(2) = polyval(obj.spline, obj.rightBound(1));              
          elseif (size(sd, 2) >  3)
              % ATM volatility input consists of three points, path is a parabola. 
              obj.type = 4;
              obj.spline = csape(sd, [ obj.SlopeLeft  vd obj.SlopeRight ], [1 1]);       
              obj.leftBound(2) = ppval(obj.spline, obj.leftBound(1));
              obj.rightBound(2) = ppval(obj.spline, obj.rightBound(1));              
          end
          
      end
      % Calculate ATM volatility at a given strike price.
      % returns volatility, not vd
      function value = GetValue(obj, StrikePrice)

 
          sd = obj.BreakpointScaleFactor * (StrikePrice - obj.SyntheticFP) / obj.StdDev;
          
          if (sd > obj.rightBound(1))
              value = (obj.rightBound(2) + (sd - obj.rightBound(1)) * obj.SlopeRight) + obj.ATMVolatility;
              return
          elseif (sd < obj.leftBound(1))
              value = (obj.leftBound(2) + (sd - obj.leftBound(1)) * obj.SlopeLeft) + obj.ATMVolatility;
              return
          end
          if (obj.type ==  1)
              value = obj.spline + obj.ATMVolatility ;
          elseif ((obj.type ==  2) || (obj.type ==  3))
              value = polyval(obj.spline, sd) + obj.ATMVolatility; 
          elseif (obj.type ==  4)
              value  = ppval(obj.spline, sd) + obj.ATMVolatility;
          end 
      end
      
   end
end



