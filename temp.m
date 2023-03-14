[t, y] = simRocket([200.0 200.0 200.0; 0.001 -0.002 0.0], 10, [0; 0; pi/2; 0; 0; 0; 0])
%[t, y] = simRocket([0.0 0.0 0.0; 0.0 0.00 0.0], 10, [0; 0; pi/2; 0; 0; 0; 0])


subplot(2,2,1);
scatter(y(:, 1), y(:, 2))
ylabel("y");
xlabel("x");

subplot(2,2,2);
plot(t, y(:, 1))
ylabel("x");
xlabel("time");


subplot(2,2,3);
plot(t, y(:, 2))
ylabel("y");
xlabel("time");

subplot(2,2,4);
plot(t, y(:, 3))
ylabel("theta");
xlabel("time");