function sinr = sinrDB(pr, inter, n)
    sinr = 10*log10( pr / (inter + n) );
end
