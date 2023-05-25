% Number of nodes
N = 25; % Change this value as per your requirement

% Weights for each edge
weights = rand(N, 1) * 10; 

% Adjacency matrix 
adjMatrix = zeros(N);
for i=1:N-1
    adjMatrix(i, i+1) = weights(i);
    adjMatrix(i+1, i) = weights(i);
end
adjMatrix(N, 1) = weights(N);
adjMatrix(1, N) = weights(N);

G = graph(adjMatrix);

% Visualize the network 
nodeColor = 'red'; 
figure;
plot(G, 'NodeColor', nodeColor);

% Initialize routing tables 
dvrTables = cell(N, 1);
for i=1:N
    dvrTables{i} = inf(N, 2);
    dvrTables{i}(:, 1) = 1:N;
    dvrTables{i}(i, 2) = 0; % Distance to itself is 0
end

% Update routing tables 
converged = false;
iterations = 0;
routingOverhead = 0;

tic; % Start time measurement for convergence

while ~converged
    converged = true;
    iterations = iterations + 1;

    % Each node sends its routing table to its neighbors
    for i=1:N
        neighbors = find(adjMatrix(i, :) > 0);
        for neighbor = neighbors
            routingOverhead = routingOverhead + 1; % Increment routing overhead for each sent table
            % Update neighbor's routing table
            for j=1:N
                costThroughMe = dvrTables{i}(j, 2) + adjMatrix(i, neighbor);
                if costThroughMe < dvrTables{neighbor}(j, 2)
                    dvrTables{neighbor}(j, 2) = costThroughMe;
                    converged = false;
                end
            end
        end
    end
end

convergenceTime = toc; 

% Display routing tables
for i=1:N
    disp(['Routing table for node ' num2str(i)]);
    disp(dvrTables{i});
end

%Convergence Time 
disp(['Converged in ' num2str(iterations) ' iterations.']);
disp(['Convergence time: ' num2str(convergenceTime) ' seconds.']);

%Routing Overhead
disp(['Total routing overhead: ' num2str(routingOverhead) ' messages.']);
