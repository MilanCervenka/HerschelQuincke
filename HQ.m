% this script calculates transmission properties of
% N-branch HQ silencer

% parameters are given in vector "qvec"
% determining the number of branches
N = length(qvec)/2;

% number of modes in the main channel
M    = 12;
% small parameter to introduce imaginary part of plane-wave wavenumber
% to avoid infibities in cot and csc functions
eps  = 1e-12; 

% characteristic acoustic impedance
Z0   = rho0*c0;

% physical length and widths of the branches
Ln = c0*qvec(1:N)/(2*fc);
hn = H*qvec(N+1:2*N);

% determinimg the frequency range of interest
% for calculation of minimum TL
fmin = fc - Df/2;
fmax = fc + Df/2;

% calculating the positions of the branches
yn(1) = 0;
for i=2:N
    yn(i) = sum(hn(1:i-1));
end

% calculating the number of modes in individual branches
Snmin = 4;
clear Sn;
for ind=1:N
    pom = ceil(M*hn(ind)/H);
    Sn(ind) = max(pom, Snmin);
end
S = sum(Sn);

% frequency range for the calculation of the transmission properties
fi = 1:1:1000;
Nf = length(fi);

% filling the matrix QSM - Eq. (10)
clear GSSp QSM;
ind = 1;
for ni=1:N
    for si = 1:Sn(ni)
        for mi = 1:M
           QSM(ind, mi) = FillQSM(si-1, mi-1, yn(ni), hn(ni), H);
        end
        GSSp(ind) = hn(ni)/H;
        ind = ind+1;
    end
end
% filling the matrix GSS
GSS = diag(GSSp);
clear GSSp;

QMS = transpose(QSM);

IMM = eye(M);

for indf = 1 : Nf
    f = fi(indf);

    clear KMMp
    for mi=1 : M
        KMMp(mi) = Kz(f, mi-1, H, c0, 0);
    end
    % filling the matrix KMM 
    KMM = diag(KMMp);
    clear KMMp;

    clear KSSp Argp;
    ind = 1;
    for ni=1:N
        for si = 1:Sn(ni)
            KSSp(ind) = Kz(f, si-1, hn(ni), c0, eps);
            Argp(ind) = KSSp(ind)*Ln(ni);
            ind = ind+1;
        end
    end
    % filling the matrix KSS
    KSS = diag(KSSp);
    clear KSSp;
    % filling the matrices QSM 
    SISS = diag(csc(Argp));
    TISS = diag(cot(Argp));
    clear Argp;

    KIMM = inv(KMM);

    % matrices Eq. (18)
    AMM = 1i * KIMM * QMS * KSS * GSS * TISS * QSM;
    BMM = 1i * KIMM * QMS * KSS * GSS * SISS * QSM;

    % calculating the transmission matrix - Eq. (20)
    M1 = IMM - AMM - BMM*((IMM-AMM)\BMM);
    M2 = BMM*(IMM + (IMM-AMM)\(IMM+AMM));    
    TMM = - M1 \ M2;

    % transmission coefficient
    Ti(indf) = abs(TMM(1, 1));
    % transmission loss
    TLi(indf)    = -20*log10(Ti(indf));
end

% determining where to calculate maximum transmission coefficient
iod  = 1;
ido = Nf;
for j = 1 : Nf
    if fi(j) <= fmin
        iod = j;
    end
    if fi(j) <= fmax
        ido = j;
    end
end

% maximum transmission coefficient in the given frequency range
Tmax  = max( Ti(iod:ido) );
% corresponding transmission loss
TLmin = -20*log10(Tmax);
