%https://docs.google.com/document/d/12Bgm2X32ssVyNvAXecjxL3QIKdnnVgydlbvl-A0Jpzs/edit
Gt=14;
Gr=14;
ht=51.5;
hr=1.5;
d = 1000:1000:20000;
PG_two_ray = Gt * Gr * ht^2 * hr^2 *(1./d).^4;
PL_dB_two_ray = -10 * log10(PG_two_ray);
figure;
plot(d, PL_dB_two_ray);
xlabel('Distance between transmitter and receiver'); ylabel('Path Loss (dB)');
title('Modelling of two-ray ground reflection model');
h = legend('two-ray Model',1);
