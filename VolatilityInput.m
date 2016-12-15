
ATMVolatility = 9;
BreakpointScaleFactor = 1;

SlopeLeft = -0.5;  % slopes of spline at the ends of the interval 
SlopeRight = 0.5;  % we used first-order derivatives as conditions

SwimCorrelation = 1;
SwimReferencePrice = 100;  %????????

sd = [
0.5]';

vd = [
0.5]';
    
multiplier = [1 ];
baseSmileWeight = [1];
multiplierSmileWeight = [0];
