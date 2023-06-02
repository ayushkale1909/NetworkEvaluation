
% Parameters
N = 100; % Number of packets 
G = 0.5; % Load
T_packet = 1; % Packet transmission time

% Initialize
t = zeros(1,N); % Arrival time
s = zeros(1,N); % Start of service time
f = zeros(1,N); % End of service time
d = zeros(1,N); % Delay
succeed = zeros(1,N); % Successful transmissions

% Main loop
for i = 1:N
    % Arrival time
    t(i) = (i-1) * G;
    
    % Start of service time 
    s(i) = t(i);
    
    % Calculate end of service time
    f(i) = s(i) + T_packet;
    
    % Check for successful transmission
    if i == 1 || f(i-1) <= s(i)
        succeed(i) = 1;
    end
end

throughput = sum(succeed) / f(N); % Successful packets per unit time
average_delay = mean(d(succeed==1)); % Average delay of successful packets
disp(['Throughput: ', num2str(throughput)]);
disp(['Average Delay: ', num2str(average_delay)]);
