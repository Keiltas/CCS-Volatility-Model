run('Data.m');
run('VolatilityInput.m');

[volSpline, SyntheticFP, StdDev] = CreateVolatilitySpline(ForwardPrice, volatilityTTM);

StrikeSD = BreakpointScaleFactor * (strikePrice - SyntheticFP) / StdDev;
StrikeVolatility = ((ppval(volSpline, StrikeSD) + ATMVolatility) * baseSmileWeight(end)) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility;



strikes  = [
150
160
165
170
175
180
185
190
195
]';

StrikeSDArr = BreakpointScaleFactor * (strikes - SyntheticFP) / StdDev;

StrikeVolatilityarr = ((ppval(volSpline, StrikeSDArr) + ATMVolatility) * baseSmileWeight(end)) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility;


