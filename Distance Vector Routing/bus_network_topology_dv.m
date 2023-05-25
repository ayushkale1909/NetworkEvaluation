% Number of nodes
N = 25; % Change this value as per your requirement

% Weights for each edge
weights = rand(N-1, 1) * 10; 

% Adjacency matrix
adjMatrix = zeros(N);
for i = 1:N-1
    adjMatrix(i, i+1) = weights(i);
    adjMatrix(i+1, i) = weights(i);
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
    if i ~= 1 % For all nodes except the first one
        dvrTables{i}(i-1, 2) = adjMatrix(i, i-1);  % Direct cost to the previous node
    end
    if i ~= N % For all nodes except the last one
        dvrTables{i}(i+1, 2) = adjMatrix(i, i+1);  %Direct cost to the next node
    end
end

tic; 


while ~converged
    converged = true;  
    iterations = iterations + 1;

    oldTables = dvrTables;  

    % Each node sends its routing table to its neighbors
    for i=1:N
        neighbors = [];  %Initializing list of neighbors
        if i ~= 1  % Not the first node
            neighbors = [neighbors, i-1];  % Add previous node to neighbors
        end
        if i ~= N  % Not the last node
            neighbors = [neighbors, i+1];  % Add next node to neighbors
        end
        for neighbor = neighbors
            routingOverhead = routingOverhead + 1;
            
            %Update routing table
            for j=1:N
                costThroughMe = dvrTables{i}(j, 2) + adjMatrix(i, neighbor);
                if costThroughMe < dvrTables{neighbor}(j, 2)
                    dvrTables{neighbor}(j, 2) = costThroughMe;
                    converged = false;
                end
            end
        end
    end

    % Check for convergence 
    for i=1:N
        if ~isequal(oldTables{i}, dvrTables{i})
            converged = false;
            break;
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
