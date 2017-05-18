function n = thermNoise(T, bw)
    % sinr: (signal power)/(interference power+noise power), SINR = S/(I+N)
    k = 1.38 * 10^(-23); % Boltzmans constant
    n = k * (T + 273.13) * bw; % Thermal noise power
end
