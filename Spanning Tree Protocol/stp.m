% Network with 5 nodes
Adj = [0 1 1 0 0; 1 0 1 1 0; 1 1 0 1 1; 0 1 1 0 1; 0 0 1 1 0];
G = graph(Adj);
T = minspantree(G);

subplot(1, 2, 1);
plot(G);
title('Original Network');

subplot(1, 2, 2);
plot(T);
title('Spanning Tree');


% Random Network Example
Adj = [0 1 0 0 1; 1 0 1 0 1; 0 1 0 1 0; 0 0 1 0 1; 1 1 0 1 0];
G = graph(Adj);
T = minspantree(G);
figure
subplot(1, 2, 1);
plot(G);
title('Original Network');
subplot(1, 2, 2);
plot(T);
title('Spanning Tree');
