% rocket first order ODE: y' = f(y, t)
% also requires u, the set of actions n x 2
function y_prime = rocketOde(u, y) 

% height
h = 3;
% mass
m = 10;
% moment of inertia
I = (1/12) * m * h^2;
% fuel use constant in loss/thrust
k = 3;

% interpolates the command at time t from the discretized control input sequence
%if(size(u, )
%u = interp1(linspace(0,t_max,size(u_steps, 1)), u_steps, t);
F = u(1);
alpha = u(2);

% the rocket's x axis is the pointy direction
R_world_ship = [cos(y(3)) -sin(y(3)); sin(y(3)) cos((y(3)))];

y_prime = [
  y(4);                                                                                                                                                                                                                          
  y(5);
  y(6); 
  % rotates thrust vector into world frame
  R_world_ship * F/m * [cos( alpha ); sin( alpha ) ] + [0 ; -9.8];
  -F * sin(alpha)/I * h/2;
  k * F
];
end
