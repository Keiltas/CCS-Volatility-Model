function Forward = SpotToForwardPrice(SpotPrice, rfRate, CostCarry, TimeToMaturity)
    Forward = SpotPrice * exp((rfRate - CostCarry) * TimeToMaturity);
end