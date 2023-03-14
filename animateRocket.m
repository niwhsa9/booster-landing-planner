% Animate the pendulum
FPS = 50; % Animation frames per second
t_anim = 0:1/FPS:t_max; % Create a time vector of frames
rocket = interp1(t, x(:,:).', t_anim); % Interpolate x,y at each time point
thrust = interp1(t, u(:,:).', t_anim); % Interpolate x,y at each time point

thrust(end, 1) = 0;
figure;
w = waitforbuttonpress;
while waitforbuttonpress ~= 0
    continue
end

for iter = 1:numel(t_anim) % Animation loop
    cla
    hold on
    title('Rocket animation')
    
    % rocket
    q = quiver(rocket(iter, 1), rocket(iter, 2), cos(rocket(iter, 3)), sin(rocket(iter, 3)), 10)
    q.MaxHeadSize = 10;
    q.LineWidth = 5;
    
    % thrust vector
    angle = rocket(iter, 3);
    R_world_ship = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    alpha = thrust(iter, 2);
    F = thrust(iter, 1);
    arrow = -F* R_world_ship * [cos( alpha ); sin( alpha ) ];
    q2 = quiver(rocket(iter, 1), rocket(iter, 2),  arrow(1), arrow(2), 0.06); % can set scale to 1
    q2.MaxHeadSize = 3;
    q2.LineWidth = 2;
    ground = plot([0 200], [0 0])
    ground.LineWidth = 2;

    hold off
    axis equal
    axis([0 140 -30 120])
    xlabel('x position (m)')
    ylabel('y position (m)')
    % Forces the animation to plot mid-loop
    drawnow
    %pause(0.01)
end