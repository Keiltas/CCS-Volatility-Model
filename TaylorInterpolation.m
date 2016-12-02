function tay = TaylorInterpolation(S, delta, gamma, dS)
    tay = S + delta * dS + 0.5 * gamma * dS^2;
end