% symbolics:
% z_sym = sym('z', [91, 1])
%[a, b] = nonlcon_wrapper(z_sym)
% matlabFunction(jacobian(a, z_sym), 'file', 'JC', 'vars', {z_sym})
% matlabFunction(jacobian(b, z_sym), 'file', 'JCeq', 'vars', {z_sym})
% number of discrete samples
N = 20; 
% size of state vector
nX = 7; 
% size of action vector
nU = 2;

% our decision vector is N x nU (actions) + N x nX (states) + 1 (final time)
z0 = zeros(N*(nU + nX) + 1, 1);

% cost is the fuel consumed by the final state
costfcn = @(z) z(N*nU + N*nX); 
% cost is optimal time
%costfcn = @(z) z(N*nU + N*nX+1); 

options = optimoptions("fmincon",...
    "MaxFunctionEvaluations", 2000000,...
    "SpecifyConstraintGradient", true, ...
    "display", "iter", ...
    "Algorithm","interior-point", ...
    "EnableFeasibilityMode",true,...
    "MaxIterations",100000);
    %"Algorithm","interior-point",...
    %"EnableFeasibilityMode",true,...
    %"SubproblemAlgorithm","cg"...);

nonlcon_wrapper = @(z) nonlcon(z, N, nX, nU);

gen_jacobians(nonlcon_wrapper, size(z0, 1));
disp("done generating jacobian")

z = fmincon(costfcn, z0, [], [], [] , [], [], [], nonlcon_wrapper, options);

u = reshape(z(1: N*nU), nU, N);
x = reshape(z(N*nU+1: N*nU + N*nX), nX, N);
t_max = z(end);
x0 = x(:, 1);

%[tout, yout] = simRocket(u, t_max, x0);
%plot(yout(:, 1), yout(:, 2))
dt = t_max / (N-1);
t = 0:dt:t_max;
plot(x(1, :), x(2, :))
%plot(tout, yout(:, 2))

function [C, Ceq, jacC, jacCeq] = nonlcon(z, N, nX, nU)
% seperate decision vector into useful components
u = reshape(z(1: N*nU), nU, N);
x = reshape(z(N*nU+1: N*nU + N*nX), nX, N);
t_max = z(end);
dt = t_max / (N-1);

% desired start states and end states
%Ceq = [x(1, 1)-0; x(2, 1)-0; x(1, end)-0; x(2, end)-100; x(3, 1)-pi/2; x(3, end)-pi/2];
Ceq = [x(1, 1)-0; x(2, 1)-100; x(3, 1) - pi/8; x(4, 1)-30; x(5, 1); x(6, 1); x(7,1); % start x=0 y=100 theta=pi/2-pi/4 xdot=30 ydot=0 thetadot=0 fuel=0
        x(1, end)-100; x(2, end)-0; x(3, end)-pi/2; x(4, end); x(5, end); x(6, end)]; % start x=100 y=0 theta=pi/2 xdot=0 ydot=0 thetadot=0 fuel=?

% defect constraints
for i = 1:N-1
    x_prime = rocketOde(u(:, i),  (x(:, i) + x(:, i+1))/2); % can be i or i+1  (implicit) depending on which integral scheme
    Ceq = [Ceq; x(:, i) + x_prime * dt - x(:, i+1)];
end
C = [-t_max; % time is positive
    u(1, :).' - 500;  % thrust is <= 100
    -u(1, :).'; % thrust >= 0
    -u(2, :).' - pi/4; % gimbal >= -pi/4
     u(2, :).' - pi/4; % gimbal <= pi/4
     %-x(3, :).'; % theta >=0
     %x(3, :).' - pi; % theta <=pi
    %-x(2, :).' % height >= 0
    ];
jacC = JC(z).';
jacCeq = JCeq(z).';

end

function gen_jacobians(nonlcon_wrapper, num_rows) 
 z_sym = sym('z', [num_rows, 1]);
 [a, b] = nonlcon_wrapper(z_sym);
 matlabFunction(jacobian(a, z_sym), 'file', 'JC', 'vars', {z_sym});
 matlabFunction(jacobian(b, z_sym), 'file', 'JCeq', 'vars', {z_sym});
end

