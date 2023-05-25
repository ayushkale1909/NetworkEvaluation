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

converged = false;
iterations = 0;
routingOverhead = 0;

% Initialize routing tables 
dvrTables = cell(N, 1);
for i=1:N
    dvrTables{i} = inf(N, 2);
    dvrTables{i}(:, 1) = 1:N;
    dvrTables{i}(i, 2) = 0; % Distance to itself is 0
    if i ~= 1  % Not the root node
        parent = floor(i/2);
        dvrTables{i}(parent, 2) = adjMatrix(i, parent);  % Direct cost to parent
    end
    if 2*i <= N  % Left child exists
        dvrTables{i}(2*i, 2) = adjMatrix(i, 2*i);  % Direct cost to left child
    end
    if 2*i + 1 <= N  % Right child exists
        dvrTables{i}(2*i + 1, 2) = adjMatrix(i, 2*i + 1);  %Direct cost to right child
    end
end

tic; 

% Run until convergence
while ~converged
    converged = true;  %Assume convergence 
    iterations = iterations + 1;

    oldTables = dvrTables; 

    
    for i=1:N
        neighbors = [];  
        if i ~= 1  % Not the root node
            parent = floor(i/2);
            neighbors = [neighbors, parent];  %Add parent to neighbors
        end
        if 2*i <= N  %Left child exists
            neighbors = [neighbors, 2*i];  %Add left child to neighbors
        end
        if 2*i + 1 <= N  %Right child exists
            neighbors = [neighbors, 2*i + 1];  %Add right child to neighbors
        end
        for neighbor = neighbors
            routingOverhead = routingOverhead + 1; 
            
            %Update neighbor's routing table
            for j=1:N
                costThroughMe = dvrTables{i}(j, 2) + adjMatrix(i, neighbor);
                if costThroughMe < dvrTables{neighbor}(j, 2)
                    dvrTables{neighbor}(j, 2) = costThroughMe;
                    converged = false;
                end
            end
        end
    end

    
    for i=1:N
        if ~isequal(oldTables{i}, dvrTables{i})
            converged = false;
            break;
        end
    end
end

convergenceTime = toc; 

%Display routing tables
for i=1:N
    disp(['Routing table for node ' num2str(i)]);
    disp(dvrTables{i});
end

%Convergence Time 
disp(['Converged in ' num2str(iterations) ' iterations.']);
disp(['Convergence time: ' num2str(convergenceTime) ' seconds.']);

%Routing Overhead
disp(['Total routing overhead: ' num2str(routingOverhead) ' messages.']);
