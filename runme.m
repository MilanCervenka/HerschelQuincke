% width of the main channel (m)
H    = 0.05;

% sound speed (m/s)
c0   = 343;
% air density (kg/m^3)
rho0 = 1.2;

% center frequency of the stop-band (Hz)
fc = 500;
% silencerbandwidth (Hz)
Df = 300;

% parameter vector for 2-branch HQ silencer
qvec2 = [ 0.9368, 1.9368, 0.4221, 0.5779 ];
% parameter vector for 3-branch HQ silencer
qvec3 = [ 0.9365, 1.9374, 2.9769, 0.3228, 0.5965, 0.0807 ];
% parameter vector for 4-branch HQ silencer
qvec4 = [ 0.6824, 1.4037, 1.8904, 2.8245, 0.1259, 0.1792, 0.2657, 0.4292 ];

% calculating TL for 2-branch HQ silencer
qvec = qvec2;
HQ;
fprintf("For N=2, TLmin = %.2f dB\n", TLmin);
TLmin2 = TLmin;
TLi2 = TLi;

% calculating TL for 3-branch HQ silencer
qvec = qvec3;
HQ;
fprintf("For N=3, TLmin = %.2f dB\n", TLmin);
TLmin3 = TLmin;
TLi3 = TLi;

% calculating TL for 4-branch HQ silencer
qvec = qvec4;
HQ;
fprintf("For N=4, TLmin = %.2f dB\n", TLmin);
TLmin4 = TLmin;
TLi4 = TLi;

hold on;
rectangle('Position',[350 0 300 80], ...
          'FaceColor',[0.7 0.7 0.7 0.3], ...   % šedá + průhlednost (novější MATLAB)
          'EdgeColor','none')

h = yline(37.56,'r:', 'LineWidth',1);
set(h,'HandleVisibility','off');
text(20, 37.56+2, '37.56 dB');
h = yline(24.65,'b:', 'LineWidth',1);
set(h,'HandleVisibility','off');
text(20, 24.65+2, '24.65 dB');
h = yline(15.44,'k:', 'LineWidth',1);
set(h,'HandleVisibility','off');
text(20, 15.44+2, '15.44 dB');

h = xline(350,'k:', 'LineWidth',1);
set(h,'HandleVisibility','off');
h = xline(650,'k:', 'LineWidth',1);
set(h,'HandleVisibility','off');

plot(fi, TLi4, 'r');
plot(fi, TLi3, 'b');
plot(fi, TLi2, 'k');
axis([0 1000 0 80]);
legend("$N=4$", "$N=3$", "$N=2$",'Interpreter','latex');
xlabel("$f$ (Hz)",'Interpreter','latex');
ylabel("TL (dB)",'Interpreter','latex');
title("Transmission loss for $\Delta f = 300$\,Hz",'Interpreter','latex');
box on;
hold off;



