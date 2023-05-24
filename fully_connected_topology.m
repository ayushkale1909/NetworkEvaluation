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

%Example 
group = [1 2 1 2 1];

%Calcualte Network Modularity
[Q,Qv] = modularity(adjMatrix,group);
disp('Modularity:');
disp(Q);

%Calculate Network Resilience
resilience = zeros(N, 1);
for i = 1:N
    tempAdjMatrix = adjMatrix;
    tempAdjMatrix(i, :) = 0;  % Remove node i and connection
    tempAdjMatrix(:, i) = 0;
    [bins, ~] = conncomp(graph(tempAdjMatrix));
    resilience(i) = max(bins);  % Measure 
end

disp('Resilience Index:');
disp(resilience);
