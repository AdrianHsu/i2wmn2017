% two-ray-ground-model
function pl = twoRayGnd(ht, hr, d)
    pl = (ht*hr)^2 * (1./d).^4; %pl: path loss
end
