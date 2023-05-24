% Number of levels in the binary tree
L = 4; % Change this value as per your requirement

% Number of nodes
N = 2^L - 1;

% Weights for each edge
weights = rand(N, 1) * 10;

% Adjacency matrix
adjMatrix = zeros(N);
for i = 1:(N-1)/2
    adjMatrix(i, 2*i) = weights(2*i);
    adjMatrix(2*i, i) = weights(2*i);
    adjMatrix(i, 2*i + 1) = weights(2*i + 1);
    adjMatrix(2*i + 1, i) = weights(2*i + 1);
end

G = graph(adjMatrix);

% Visualization
nodeColor = 'red';
figure;
plot(G, 'NodeColor', nodeColor);

% Calculate Degree Centrality
degreeCentrality = centrality(G, 'degree');
disp('Degree Centrality:');
disp(degreeCentrality);

%Calculate ShortestPath
shortestPaths = distances(G);
disp('Shortest Paths:');
disp(shortestPaths);

%Calculate Betweenness Centrality
betweennessCentrality = centrality(G, 'betweenness');
disp('Betweenness Centrality:');
disp(betweennessCentrality);

%Calculate Network Diameter 
diameter = max(max(shortestPaths));
disp('Network Diameter:');
disp(diameter);

%Calculate Closeness Centrality 
closenessCentrality = centrality(G, 'closeness');
disp('Closeness Centrality:');
disp(closenessCentrality);

%Example groups
group = ones(1, N);

%Calculate Network Modularity
[Q,Qv] = modularity(adjMatrix,group);
disp('Modularity:');
disp(Q);

%Calculate Network Resilience
resilience = zeros(N, 1);
for i = 1:N
    tempAdjMatrix = adjMatrix;
    tempAdjMatrix(i, :) = 0;  % Remove node i and its connections
    tempAdjMatrix(:, i) = 0;
    [bins, ~] = conncomp(graph(tempAdjMatrix));
    resilience(i) = max(bins);  % Measure connectivity
end

disp('Resilience Index:');
disp(resilience);
