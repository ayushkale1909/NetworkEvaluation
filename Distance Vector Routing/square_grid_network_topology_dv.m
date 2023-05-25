% Grid size 
gridSize = 5; % Change this value as per your requirement

% Number of nodes
N = gridSize^2;

% Weights for each edge
weights = rand(N, 1) * 10; 

% Adjacency matrix
adjMatrix = zeros(N);

for i = 1:gridSize
    for j = 1:gridSize
        node = (i - 1) * gridSize + j;
        if i > 1 
            adjMatrix(node, node - gridSize) = weights(node);
            adjMatrix(node - gridSize, node) = weights(node);
        end
        if i < gridSize
            adjMatrix(node, node + gridSize) = weights(node);
            adjMatrix(node + gridSize, node) = weights(node);
        end
        if j > 1 
            adjMatrix(node, node - 1) = weights(node);
            adjMatrix(node - 1, node) = weights(node);
        end
        if j < gridSize
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

converged = false;
iterations = 0;
routingOverhead = 0;

% Initialize routing tables 
dvrTables = cell(N, 1);
for i=1:N
    dvrTables{i} = inf(N, 2);
    dvrTables{i}(:, 1) = 1:N;
    dvrTables{i}(i, 2) = 0; % Distance to itself is 0
    row = floor((i - 1) / gridSize) + 1;
    col = mod(i - 1, gridSize) + 1;
    if row > 1
        dvrTables{i}(i - gridSize, 2) = adjMatrix(i, i - gridSize);
    end
    if row < gridSize
        dvrTables{i}(i + gridSize, 2) = adjMatrix(i, i + gridSize);
    end
    if col > 1
        dvrTables{i}(i - 1, 2) = adjMatrix(i, i - 1);
    end
    if col < gridSize
        dvrTables{i}(i + 1, 2) = adjMatrix(i, i + 1);
    end
end

tic; 

% Run the algorithm until convergence
while ~converged
    converged = true;  
    iterations = iterations + 1;

    oldTables = dvrTables;  

    
    for i=1:N
        neighbors = [];  
        row = floor((i - 1) / gridSize) + 1;
        col = mod(i - 1, gridSize) + 1;
        if row > 1
            neighbors = [neighbors, i - gridSize];
        end
        if row < gridSize
            neighbors = [neighbors, i + gridSize];
        end
        if col > 1
            neighbors = [neighbors, i - 1];
        end
        if col < gridSize
            neighbors = [neighbors, i + 1];
        end
        for neighbor = neighbors
            routingOverhead = routingOverhead + 1;
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
