
volatilityTTM = 10.0/365;

rfRate = 0.02996934116;
%rfRate = 0.01;

time = 10.0/365;


ForwardPrice = SpotToForwardPrice(129, rfRate, 0, time)
%ForwardPrice = 129.105962537;