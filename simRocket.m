% u (nU x N)
function [tout, yout] = simRocket(u, t_max, y_init)
    N = size(u, 2);
    dt = t_max / (N-1);
    

    %u = interp1(linspace(0,t_max,size(u_steps, 1)), u, t);
    %ode = @(t, y) ( rocketOde( u(:, floor( t / dt)+1 ), y) ); 
    ode = @(t, y) ( rocketOde(  interp1(linspace(0,t_max,size(u.', 1)), u.', t) , y) ); 


    % Simulates dynamics with ode45
    [tout, yout] = ode45(ode,[0 t_max],y_init);
end 

% scatter(y(:, 1), y(:, 2))
% plot(t, y(:, 2))
%[t, y] = simRocket([0.0 0.0 0.0; 0.0 0.00 0.0], 10, [0; 0; pi/2; 0; 0; 0; 0])
% [t, y] = simRocket([200.0 200.0 200.0; 0.001 -0.002 0.0], 10, [0; 0; pi/2; 0; 0; 0; 0])
