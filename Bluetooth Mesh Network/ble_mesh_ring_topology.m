% wirelessnetworkSupportPackageCheck;
totalNodes = 6;
circleCenter = [30 15];  
circleRadius = 15; 
meshNodesPositions = zeros(totalNodes, 2);
for nodeIdx = 1:totalNodes
    angle = 2*pi*(nodeIdx-1)/totalNodes;
    meshNodesPositions(nodeIdx,:) = circleCenter + circleRadius*[cos(angle), sin(angle)];
end

relayNode = 1:totalNodes;
sourceDestinationNodePairs = [(1:3)' (2:4)'];
meshNodes = cell(1,totalNodes);

for nodeIdx = 1:totalNodes
    meshCfg = bluetoothMeshProfileConfig(ElementAddress=dec2hex(nodeIdx,4));
    if any(nodeIdx,relayNode)
        meshCfg.Relay = true;
    end
    meshNode = bluetoothLENode("broadcaster-observer", MeshConfig=meshCfg, ...
        Position=[meshNodesPositions(nodeIdx,:) 0],ReceiverRange=25, ...
        AdvertisingInterval=20e-3, ScanInterval=30e-3);
    meshNodes{nodeIdx} = meshNode;
end

% Add traffic between Node1 and Node4
traffic = networkTrafficOnOff(DataRate=1,PacketSize=15,GeneratePacket=true);
addTrafficSource(meshNodes{1},traffic, ...
    SourceAddress=meshNodes{1}.MeshConfig.ElementAddress, ...
    DestinationAddress=meshNodes{4}.MeshConfig.ElementAddress, ...
    TTL=3);

% Add traffic between Node2 and Node5
traffic = networkTrafficOnOff(DataRate=1,PacketSize=10,GeneratePacket=true);
addTrafficSource(meshNodes{2},traffic, ...
    SourceAddress=meshNodes{2}.MeshConfig.ElementAddress, ...
    DestinationAddress=meshNodes{5}.MeshConfig.ElementAddress, ...
    TTL=3);


meshNetworkGraph = helperBLEMeshVisualizeNetwork();                     % Object for Bluetooth mesh network visualization                
meshNetworkGraph.NumberOfNodes = totalNodes;                            % Total number of mesh nodes
meshNetworkGraph.NodePositionType = 'UserInput';                        % Option to assign node position             
meshNetworkGraph.Positions = meshNodesPositions;                        % List of all node positions
meshNetworkGraph.VicinityRange = 25;                                    % Reception range of mesh node
meshNetworkGraph.Title = 'Bluetooth Mesh Network';                      % Title of plot
meshNetworkGraph.SourceDestinationPairs = sourceDestinationNodePairs;   % Source-destination node pair
meshNetworkGraph.NodeType = [1 1 2 1 1 1];                              % State of mesh node
meshNetworkGraph.DisplayProgressBar = false;                            % Display progress bar
meshNetworkGraph.createNetwork();                                       % Display mesh network


