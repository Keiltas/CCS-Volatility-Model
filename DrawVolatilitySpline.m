function yy = DrawVolatilitySpline(StrikePrices, Spline, SyntheticFP, StdDev, TBInputData)
    figHandle = figure(1);
    clf;
    set(figHandle, 'units','normalized','position',[.4 .5 .3 .4]);
   
    title('Input Volatility');  
    hold on
    ylabel('Volatility');
    xlabel('Strike Price');
    load(TBInputData);
    
    % x - axis (strike prices)
    StrikePrice = sd*StdDev / BreakpointScaleFactor + SyntheticFP;
    
    % y - axis (volatility)
    Volatility = (ATMVolatility + vd) .* baseSmileWeight + multiplier .* multiplierSmileWeight * ATMVolatility;
    
    
    xx = StrikePrices;
    yy = GetTbricksVolatility(xx, Spline, SyntheticFP, StdDev,  TBInputData);


    axis([(min(StrikePrices) - 70.5) (max(StrikePrices) + 70.5) 0 (max(yy) + 70.5)])  
    plot(StrikePrice(1:end), Volatility(1:end),'o', 'markersize', 6,'color','r');
    plot(SyntheticFP, ATMVolatility * baseSmileWeight,'.','markersize', 35, 'color', 'b');
    plot(xx, yy, '-', 'color', 'black');
    hold off


end