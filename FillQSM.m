function qsm = FillQSM(s, m, yn, hn, H)
    
    eps = 1e-8;

    if (s==0)&&(m==0)
        qsm = 1;
    elseif (s>0)&&(m==0)
        qsm = 0;
    elseif (s==0)&&(m>0)
        pom = sin(m*pi*(yn+hn)/H) - sin(m*pi*yn/H);
        qsm = sqrt(2)*H*pom/(m*pi*hn);
    else
        jmen = pi*((m*hn)^2-(s*H)^2);
        if abs(jmen) > eps
            pom = ((-1)^s)*sin(m*pi*(yn+hn)/H) - sin(m*pi*yn/H);
            qsm = 2*m*H*hn*pom/jmen;
        else
            pom = 2*pi*m*hn*cos(m*pi*yn/H) ...
                + H*sin(m*pi*(2*hn+yn)/H) ...
                - H*sin(m*pi*yn/H);
            qsm = pom/(2*pi*m*hn);
        end
    end
end