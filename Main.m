
run('Data.m');

[volSpline, SyntheticFP, StdDev] = CreateVolatilitySpline(ForwardPrice, volatilityTTM, 'model.mat');

StrikeVolatility = GetTbricksVolatility(strikePrice, volSpline, SyntheticFP, StdDev,  'model.mat');   

yy = DrawVolatilitySpline(90:5:260, volSpline, SyntheticFP, StdDev, 'model.mat');



% These values are used in Taylor model as reference values (more precisely V(S_0))
[Call, Put] = blsprice(ForwardPrice, strikePrice, rfRate, time, StrikeVolatility  / 100);    

[InitCallDeltaBLS, InitPutDeltaBLS]  = blsdelta(ForwardPrice, strikePrice, rfRate, time, StrikeVolatility  / 100);
InitGammaBLS = blsgamma(ForwardPrice, strikePrice, rfRate, time, StrikeVolatility  / 100);

maxDiff = 50; % This paramter defines how far (in %) we want to differ form initial forward price(in terms of testing Taylor model performance)
              % For example, with maxDiff = 30, only prices in [0.7 * F,
              % 1.3 * F] will be considered. F - initial forward price
              
SpotPrice = zeros(1, 2*maxDiff);
CallPriceBLS = zeros(1, 2*maxDiff);
PutPriceBLS = zeros(1, 2*maxDiff);
CallPriceTAY = zeros(1, 2*maxDiff);
PutPriceTAY = zeros(1, 2*maxDiff);
CallPriceSkewTAY = zeros(1, 2*maxDiff);
PutPriceSkewTAY = zeros(1, 2*maxDiff);


for i = 1:(2*maxDiff)           % Claculating Fair prices for both Taylor and Black-Scholes models 
    SpotPrice(i) = ForwardPrice * (100-maxDiff-1 + i) / 100;
    [CallPriceBLS(i), PutPriceBLS(i)]  = blsprice(SpotPrice(i), strikePrice, rfRate, time, StrikeVolatility  / 100);
    CallPriceTAY(i)  = max(TaylorInterpolation(Call, InitCallDeltaBLS, InitGammaBLS, ForwardPrice * (-maxDiff-1+i) / 100, 0),  0);
    PutPriceTAY(i) = max(TaylorInterpolation(Put, InitPutDeltaBLS, InitGammaBLS, ForwardPrice * (-maxDiff-1+i) / 100, 0),  0);    
    CallPriceSkewTAY(i)  = max(TaylorInterpolation(Call, InitCallDeltaBLS, InitGammaBLS, ForwardPrice * (-maxDiff-1+i) / 100, 1, 1),  0);
    PutPriceSkewTAY(i) = max(TaylorInterpolation(Put, InitPutDeltaBLS, InitGammaBLS, ForwardPrice * (-maxDiff-1+i) / 100, 1, 1),  0);
end

CallDeltaTAY = zeros(1, 2*maxDiff);
PutDeltaTAY = zeros(1, 2*maxDiff);
GammaTAY = zeros(1, 2*maxDiff);

CallDeltaBLS = zeros(1, 2*maxDiff);
PutDeltaBLS = zeros(1, 2*maxDiff);
GammaBLS = zeros(1, 2*maxDiff);

for i = 1:(2*maxDiff)  % Claculating Greeks  for both Taylor and Black-Scholes models 
    CallDeltaTAY(i) = InitCallDeltaBLS + InitGammaBLS * ForwardPrice * (-maxDiff - 1 + i) / 100;
    PutDeltaTAY(i) = InitPutDeltaBLS + InitGammaBLS * ForwardPrice * (-maxDiff - 1 + i) / 100;
    GammaTAY(i) = InitGammaBLS;

    [CallDeltaBLS(i), PutDeltaBLS(i)] = blsdelta(SpotPrice(i), strikePrice, rfRate, time, StrikeVolatility  / 100);
    GammaBLS(i) = blsgamma(SpotPrice(i), strikePrice, rfRate, time, StrikeVolatility  / 100);
end

CallVolatilityTAY = zeros(1, 2*maxDiff);
PutVolatilityTAY = zeros(1, 2*maxDiff);

CallVolatilityBLS = zeros(1, 2*maxDiff);
PutVolatilityBLS = zeros(1, 2*maxDiff);



for i = 1:(2*maxDiff) % Claculating implied volatilities  for both Taylor and Black-Scholes models 
   CallVolatilityBLS(i) = blsimpv(SpotPrice(i), strikePrice, rfRate, time, CallPriceBLS(i), 1, 0, 1e-6, {'Call'});
   CallVolatilityTAY(i) = blsimpv(SpotPrice(i), strikePrice, rfRate, time, CallPriceTAY(i), 1, 0, 1e-6, {'Call'});
   PutVolatilityBLS(i) = blsimpv(SpotPrice(i), strikePrice, rfRate, time, PutPriceBLS(i), 1, 0, 1e-6, {'Put'});
   PutVolatilityTAY(i) = blsimpv(SpotPrice(i), strikePrice, rfRate, time, PutPriceTAY(i), 1, 0, 1e-6, {'Put'}); 
end

figHandle = figure(2);
clf;

set(figHandle, 'units','normalized','position',[.1/2 .1/2 .4 .8]);
subplot(2,1,1)
title('Fair Prices comparison (CALL)');
hold on
xlabel('Spot Price');
ylabel('Fair Price');

plot(SpotPrice, CallPriceBLS, 'b');
plot(SpotPrice, CallPriceTAY, 'r');
plot(SpotPrice, CallPriceSkewTAY, 'c');

hold off
legend('Black-Scholes','Taylor', 'SkewTaylor');


subplot(2,1,2)
title('Fair Prices comparison (PUT)');
hold on
xlabel('Spot Price');
ylabel('Fair Price');
plot(SpotPrice, PutPriceBLS, 'b');
plot(SpotPrice, PutPriceTAY, 'r');
plot(SpotPrice, PutPriceSkewTAY, 'c');

hold off
legend('Black-Scholes', 'Taylor', 'SkewTaylor');

% Figures For Greeks

figHandle = figure(3);
clf;

set(figHandle, 'units','normalized','position',[.5 .1/2 .4 .8]);
subplot(2,1,1)
title('Deltas comparison (CALL)');
hold on
xlabel('Spot Price');
ylabel('Delta');
plot(SpotPrice, CallDeltaBLS, 'b');
plot(SpotPrice, CallDeltaTAY , 'r');

hold off
legend('Black-Scholes','Taylor');

%figure;
subplot(2,1,2)
title('Deltas comparison (PUT)');
hold on
xlabel('Spot Price');
ylabel('Delta');
plot(SpotPrice, PutDeltaBLS, 'b');
plot(SpotPrice, PutDeltaTAY, 'r');

hold off
legend('Black-Scholes','Taylor');

figHandle = figure(4);
clf;

set(figHandle, 'units','normalized','position',[.4 .1 .3 .4]);
title('Gamma comparison (PUT & CALL)');
hold on
xlabel('Spot Price');
ylabel('Gamma');
plot(SpotPrice, GammaBLS, 'b');
plot(SpotPrice, GammaTAY, 'r');

hold off
legend('Black-Scholes','Taylor');

%Figure for implied volatility

figHandle = figure(5);
clf;

set(figHandle, 'units','normalized','position',[.1/2 .1/2 .3 .4]);

title('Implied volatility comparison (CALL / PUT)');
hold on
xlabel('Spot Price');
ylabel('Implied volatility');

plot(SpotPrice, CallVolatilityBLS, 'b');
plot(SpotPrice, CallVolatilityTAY, 'r');

hold off
legend('Black-Scholes','Taylor');

