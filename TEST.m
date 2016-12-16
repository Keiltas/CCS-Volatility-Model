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


A = ATMVolPath([1 2 3 5], [2 3 9 7]);

xx = 0:0.1:10;
for i = 1:size(xx, 2)
yy(i) = A.GetValue(xx(i));
end

plot(xx, yy);


% B = ATMVolPath([188.827584434, 192.827584434], [19.02083703, 19.03083703]);
% 
% A = TBVolatilitySpline('Data.m', 'VolatilityInput.m', B);
% 
% C = TBVolatilitySpline('Data1.m', 'VolatilityInput.m', B);
% 
% xx = 90:5:260;
% for i = 1:size(xx, 2)
% zz(i) = A.GetValue(xx(i));
% 
% yy(i) = C.GetValue(xx(i));
% end
% 
% plot(xx, zz);
% hold on
% plot(xx, yy);

B = ATMVolPath([101], [ 10]);
C = TBVolatilityInput('VolatilityInput.m');
A = TBVolatilitySpline(C, B);
A.GetValue(100)
 xx = 90:5:220;
 for i = 1:size(xx, 2)
 zz(i) = A.GetValue(xx(i));
 

 end
 plot(xx, zz);