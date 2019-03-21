%
%  Gabbiani & Cox, Mathematics for Neuroscientists
%
%  this function in called by wang_mod.m
%
%  wanghy.m
%
%  set up the wang equations on a patch
%  and solve via hybrid euler
%
%  usage		v = wanghy(dt,t1,t2,T,Istim)
%
%  where     dt = timestep (ms)
%	         t1 = start time of current pulse (ms)
%	         t2 = stop time of current pulse (ms)
%	         T = final time (ms)
%	         Istim = size of current pulse (micro A/cm^2)
%	    	 v = voltage (mV)
%
% example
%		v = wanghy(0.01,10,100,200,-1)
%		v = wanghy(0.01,10,100,200,3)
%
% original	Wang, X-J (1994) Multiple dynamical modes of thalamic
%		relay neurons: Rhythmic bursting and intermittent phase-
%		locking. Neuroscience 59:21-31.
%

function [v h_out H2_out] = wanghy(dt,t1,t2,T,Istim)
%*** modified to store T-current inactivation and H-current squared
%*** activation

%function v = wanghy(dt,t1,t2,T,Istim)

% maximal conductances, in mS / (cm)^2
gK = 30; %delayed rectifier            
gT = 0.3; %low-theshold T-type calcium current
gNa = 42; %HH-type sodium channel        
gNaP = 9; %persistent sodium
gl = 0.1; %leak           
gh = 0.04; %H-current

% reversal potentials, in mV
Vh = -40;		
VK = -80;             
VNa = 55;           
Vl = -72;         
VCa = 120;

%temperature factor
phi_n = 200/7;
phi_h = 2;

%capacitance
C = 1;                  % micro F / (cm)^2

N = floor((T-dt)/dt);
v = zeros(N,1);		% allocate space for v

%***
h_out  = zeros(N,1);
H2_out = zeros(N,1);


% initial conditions
v(1) = -70;		
n = 0.1; %delayed rectifier activation variable
H = 0.1; %H-current activation variable
h = 0.1; %T-type calcium current inactivation variable

%***
t_out(1) = dt;
h_out(1) = h;
H2_out(1) = H^2;

j = 2;			% time counter

while j*dt < T,		% run for T ms

    t = j*dt;

    Iapp = 0;		% apply Istim between t1 and t2 
    if (t>t1 & t<t2)
       Iapp = Istim;
    end

    % advance the gating variables, n h & H using hybrid Euler

    tmp = an(v(j-1));
    n = (n+dt*phi_n*tmp)/(1+dt*phi_n*(tmp+bn(v(j-1))));

    tmp = tauh(v(j-1))/phi_h;
    h = (tmp*h + dt*hinf(v(j-1)))/(tmp+dt);

    tmp = tauH(v(j-1)); %no temperature scaling for H current activation
    H = (tmp*H + dt*Hinf(v(j-1)))/(tmp+dt);

    % compute the conductances of the K, Na, NaP, h & Ca currents

    cIK = gK*(n^4);

    tmp = am(v(j-1));
    mNa = tmp/(tmp+bm(v(j-1)));
    
    %use the approximation hNa = 0.85-n, where hNa is fast 
    %sodium inactivation (FitzHugh Biophys J 1:445-466, 1961) 
    cINa = gNa*mNa^3*(0.85-n);

    %persistent sodium 
    tmp = amP(v(j-1));
    mNaP = tmp/(tmp+bmP(v(j-1)));
    cINaP = gNaP*mNaP^3;

    cIh = gh*H^2;

    cIT = gT*sinf(v(j-1))^3*h;

    % advance the voltage, v
    tmp1 = (cINa+cINaP)*VNa+cIK*VK+cIh*Vh+cIT*VCa+gl*Vl+Iapp;
    tmp2 = cINa+cINaP+cIK+cIh+cIT+gl;

    v(j) = (v(j-1) + dt*tmp1)/(1 + dt*tmp2);

    %***
    h_out(j) = h;
    H2_out(j) = H^2;
    
    j = j + 1;

end

return

% steady-state activation, time constant and opening and closing
% functionals from Wang

%activation variable of T-type current at steady-state
function val = sinf(V)
val = 1/(1+exp(-(V+65)/7.8));

%forward rate of delayed rectifier
function val = an(V)
sigK = 10;
val = -.01*(V+45.7-sigK)./(exp(-(V+45.7-sigK)/10)-1);

%backward rate of delayed rectifier
function val = bn(V)
sigK = 10;
val = .125*exp(-(V+55.7-sigK)/80);

%steady-state inactivation of T-type calcium current
function val = hinf(V)
thh = -81;
kh = 6.25;
val = 1/(1+exp((V-thh)/kh));

%time constant of inactivation of T-type calcium current
function val = tauh(V)
val = hinf(V)*exp((V+162.3)/17.8) + 20;

%forward rate of fast sodium current
function val = am(V)
sigNa = 3;
tmp = -.1*(V+29.7-sigNa);
val = tmp/(exp(tmp)-1);

%backward rate of fast sodium current
function val = bm(V)
sigNa = 3;
val = 4*exp(-(V+54.7-sigNa)/18);

%forward rate of persistent sodium current
function val = amP(V)
sigNa = -5;
tmp = -.1*(V+29.7-sigNa);
val = tmp/(exp(tmp)-1);

%backward rate of persistent sodium current
function val = bmP(V)
sigNa = -5;
val = 4*exp(-(V+54.7-sigNa)/18);

%steady-state activation of H current
function val = Hinf(V)
val = 1/(1+exp((V+69)/7.1));

%time constant of H current
function val = tauH(V)
val = 1000/(exp((V+66.4)/9.3)+exp(-(V+81.6)/13));

