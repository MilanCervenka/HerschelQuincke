function kz = Kz(f, m, L, c0, eps)
    k  = 2*pi*f/c0/(1+1i*eps);
    ky = m*pi/L;

    kz = sqrt(k^2 - ky^2);


    kz = conj(kz);
end