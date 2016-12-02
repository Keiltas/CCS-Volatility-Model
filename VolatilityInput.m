
ATMVolatility = 19.02083703;
BreakpointScaleFactor = 63.40279011;

SlopeLeft = -16.20824291;  % slopes of spline at the ends of the interval 
SlopeRight = 9.43325796;  % we used first-order derivatives as conditions

SwimCorrelation = 1;
SwimReferencePrice = 191.947;  %????????

sd = [
-3.5705630472
-2.6300698455
-1.3760789098
-0.1220879741
0.8184052276
1.7588984294]';

vd = [
37.37908016
23.0925939
8.81874492
0.51656622
-1.23241868
4.32999701]';
    
multiplier = [1 1 1 1 1 1];
baseSmileWeight = [1 1 1 1 1 1];
multiplierSmileWeight = [0 0 0 0 0 0];
