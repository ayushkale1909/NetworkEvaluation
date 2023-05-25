% Number of nodes
N = 25; % Change this value as per your requirement

% Weights for each edge
weights = rand(N, 1) * 10; 

% Adjacency matrix
adjMatrix = zeros(N);
for i = 2:N
    adjMatrix(i, 1) = weights(i);
    adjMatrix(1, i) = weights(i);
end

G = graph(adjMatrix);

% Visualization
nodeColor = 'red';
figure;
plot(G, 'NodeColor', nodeColor);

% Initialize routing tables 
dvrTables = cell(N, 1);
for i=1:N
    dvrTables{i} = inf(N, 2);
    dvrTables{i}(:, 1) = 1:N;
    dvrTables{i}(i, 2) = 0; 
    if i == 1  % Central node
        for j=2:N  % Direct cost to all other nodes
            dvrTables{i}(j, 2) = adjMatrix(i, j);
        end
    else  % Other nodes
        dvrTables{i}(1, 2) = adjMatrix(i, 1);  % Direct cost to central node
    end
end

tic; 

% Each node sends its routing table to its neighbors

converged = false;
iterations = 0;
routingOverhead = 0;

for i=1:N
    if i == 1  % Central node
        neighbors = 2:N;  
    else  % Other nodes
        neighbors = 1;  % Central node is the only neighbor
    end
    for neighbor = neighbors
        routingOverhead = routingOverhead + 1; 
        % Update routing table
        for j=1:N
            costThroughMe = dvrTables{i}(j, 2) + adjMatrix(i, neighbor);
            if costThroughMe < dvrTables{neighbor}(j, 2)
                dvrTables{neighbor}(j, 2) = costThroughMe;
                converged = false;
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
