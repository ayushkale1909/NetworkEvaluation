% Number of nodes
N = 25; % Change this value as per your requirement

% Weights for each edge
weights = rand(N) * 10; 

% Adjacency matrix 
adjMatrix = weights + weights'- diag(diag(weights + weights'));
G = graph(adjMatrix);

%Visualization
nodeColor = 'red'; 
figure;
plot(G, 'NodeColor', nodeColor);

% Initialize routing tables 
dvrTables = cell(N, 1);
for i=1:N
    dvrTables{i} = inf(N, 2);
    dvrTables{i}(:, 1) = 1:N;
    dvrTables{i}(i, 2) = 0; % Distance to itself is 0
    for j=1:N
        if i ~= j
            dvrTables{i}(j, 2) = adjMatrix(i, j); % Direct cost to all other nodes
        end
    end
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
            neighbors = setdiff(1:N, i);
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

