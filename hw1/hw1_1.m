T = 27;
bw = 10000000;
p_bs_dbm = 33;
gt_db = 14;
gr_db = 14;
h_bs = 51.5;
h_md = 1.5;
scale = 20;

pt = 10.^((p_bs_dbm - 30) / 10); %pt: transmit power
gt = 10.^(gt_db / 10); %gt: transmit antenna gain
gr = 10.^(gr_db / 10); %gr: receive antenna gain
ht = h_bs; %ht: transmit antenna height
hr = h_md; %hr: receive antenna height
d = 1000:1000:20000; %d: reference distance, the distance between the BS and the mobile device (in meter) as the x-axis.
pl = zeros(1,scale);
pr = zeros(1,scale);
pl = (ht*hr)^2 * (1./d).^4; %pl: path loss
%pr: receive power, the received power of the mobile device (in dB) as the y-axis 
pr = -10*log10(pl * pt * gt * gr);

plot(d, pr);
xlabel('Distance between transmitter and receiver'); ylabel('Path Loss (dB)');
title('Modelling of two-ray ground reflection model');
h = legend('two-ray Model',1);