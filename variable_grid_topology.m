% Grid size
nRows = 5; % Change this value as per your requirement
nCols = 10; % Change this value as per your requirement

% Number of nodes
N = nRows * nCols;

% Weights for each edge
weights = rand(N, 1) * 10; 

% Adjacency matrix
adjMatrix = zeros(N);

for i = 1:nRows
    for j = 1:nCols
        node = (i - 1) * nCols + j;
        if i > 1 % North
            adjMatrix(node, node - nCols) = weights(node);
            adjMatrix(node - nCols, node) = weights(node);
        end
        if i < nRows % South
            adjMatrix(node, node + nCols) = weights(node);
            adjMatrix(node + nCols, node) = weights(node);
        end
        if j > 1 % West
            adjMatrix(node, node - 1) = weights(node);
            adjMatrix(node - 1, node) = weights(node);
        end
        if j < nCols % East
            adjMatrix(node, node + 1) = weights(node);
            adjMatrix(node + 1, node) = weights(node);
        end
    end
end

G = graph(adjMatrix);

% Visualization
nodeColor = 'red';
figure;
plot(G, 'NodeColor', nodeColor);

% Create a matrix of node positions
Y = repelem((1:nRows)', nCols);
X = repmat(1:nCols, nRows, 1);
positions = [X(:), Y(:)];

figure;
plot(G, 'NodeColor', nodeColor, 'XData', positions(:, 1), 'YData', positions(:, 2));
p.NodeLabel = {};
text(positions(:, 1)+0.3, positions(:, 2), p.NodeLabel, 'VerticalAlignment', 'Bottom', 'HorizontalAlignment', 'Right')

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
