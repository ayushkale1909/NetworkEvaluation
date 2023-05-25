% Number of nodes
N = 25; % Change this value as per your requirement

% Weights for each edge
weights = rand(N) * 10; 

% Adjacency matrix 
adjMatrix = weights + weights' - diag(diag(weights + weights'));

% Create the graph
G = graph(adjMatrix, 'upper'); % Create an undirected graph, because of symmetric matrix

% Visualization
nodeColor = 'red'; 
figure;
plot(G, 'NodeColor', nodeColor);

tic; 

% Initialize routing tables
routingTables = cell(N, 1);
routingOverhead = 0;

% Run Dijkstra's algorithm 
for i = 1:N
    [T, dist] = shortestpathtree(G, i, 'all');
    for j=1:N
        routingTables{i}(j, 1) = j;
        routingTables{i}(j, 2) = dist(j);
    end
    routingOverhead = routingOverhead + N - 1; 
end

convergenceTime = toc; 

% Display routing tables
for i = 1:N
    disp(['Routing table for node ' num2str(i)]);
    disp(routingTables{i});
end

% Display convergence time
disp(['Convergence time: ' num2str(convergenceTime) ' seconds.']);

% Display routing overhead
disp(['Total routing overhead: ' num2str(routingOverhead) ' messages.']);


