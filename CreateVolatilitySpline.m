

function [VolSpline, SyntheticFP, StdDev] = CreateVolatilitySpline(ForwardPrice, volatilityTTM, TBInputData)

    %Create cubic spline for the ATM volatility path + get value
    %corresponding for our forward price from it
    %ATMVolatilityPath = [[95 0.6] [98 0.56] [100 0.5] [110 0.8] [120 0.9]];
    %ATMVolatilityPathSpline = csape(ATMVolatilityPath(:, 1),[0 ATMVolatilityPath(:, 2) 0], [1 1]);
    
%     if ForwardPrice > max(ATMVolatilityPath(:, 1))
%         ATMVolatility = ppval(ATMVolatilityPathSpline, max(ATMVolatilityPath(:, 1)));
%     elseif ForwardPrice < min(ATMVolatilityPath(:, 1))
%         ATMVolatility = ppval(ATMVolatilityPathSpline, min(ATMVolatilityPath(:, 1)));
%     else
%         ATMVolatility = ppval(ATMVolatilityPathSpline, ForwardPrice);
%     end
    %run('VolatilityInput.m');

    load(TBInputData); 
    %Calculation of nodes

    SyntheticFP = ForwardPrice ^ (SwimCorrelation) * SwimReferencePrice ^ (1.0 - SwimCorrelation);
    
    % Node with sd = 0 is the reserved central node with strike equal
    % to synthetic forward and with volatility equal to ATM volatility 
    % (retrieved from ATM volatility path in Tbricks)
    % CHECK for sd = 0 in input data hasn't done!
    
    sd(size(sd, 2) + 1) = 0;
    vd(size(vd, 2) + 1) = 0;

    multiplier(size(sd, 2) ) = 1;
    baseSmileWeight(size(sd, 2)) = 1;
    multiplierSmileWeight(size(sd, 2)) = 0;
    
    VolSpline = csape(sd,[ SlopeLeft  vd SlopeRight ],  [1 1]);       
    
    StdDev = SyntheticFP * ATMVolatility * sqrt(volatilityTTM);
    
    % x - axis (strike prices)
    StrikePrice = sd*StdDev / BreakpointScaleFactor + SyntheticFP;
    
    % y - axis (volatility)
    Volatility = (ATMVolatility + vd) .* baseSmileWeight + multiplier .* multiplierSmileWeight * ATMVolatility;
    
    %coeff =  1 / (StdDev / BreakpointScaleFactor);
   
    %VolSpline = csape(StrikePrice,[(SlopeLeft * coeff) Volatility (SlopeRight * coeff)], [1 1]);
    

    
%     xx = linspace(min(sd) - 6,max(sd) + 6, 101);
%     yy = zeros(1, 101);
%     plot(StrikePrice(end), Volatility(end),'.','markersize', 35, 'color', 'b');
%     plot(StrikePrice(1:end - 1), Volatility(1:end - 1),'o', 'markersize', 6,'color','r');
%     for i = 1:101
%         if (xx(i) < min(sd))
%             yy(i) = (ATMVolatility + ppval(VolSpline,min(sd))) * baseSmileWeight(end) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility + (xx(i) - min(sd)) * ppval(fnder(VolSpline), min(sd));
%         elseif (xx(i) > max(sd))
%             yy(i) = (ATMVolatility + ppval(VolSpline,max(sd))) * baseSmileWeight(end) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility + (xx(i) - max(sd)) * ppval(fnder(VolSpline), max(sd));
%         else
%         yy(i) = (ATMVolatility + ppval(VolSpline,xx(i))) * baseSmileWeight(end) + multiplier(end) * multiplierSmileWeight(end) * ATMVolatility;     
%         end
%     end
%     plot(xx*StdDev / BreakpointScaleFactor + SyntheticFP, yy, '-');
%     hold off

    %VolSpline.coefs(1, 0) =   
    
    
end


function SyntheticFP = CreateSyntheticForwardPrice(ForwardPrice, SwimCorrelation, SwimReferencePrice)
    SyntheticFP = ForwardPrice ^ (SwimCorrelation) * SwimReferencePrice ^ (1.0 - SwimCorrelation);
end

