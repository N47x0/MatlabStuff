%% AAE 550 Final Project Ignacio Soriano
%function [] = AAE_550_Project()
clc
clear all


global c101; 
global max_cap;
global cost;
global depot_node;
global printing;
global pop_size;

printing = 1;

c101 = load('solomonC101.dat');
max_cap = 400;

% Save the first node as depot.
depot_node = c101(1,:);

% Create Cost Table
numNodes = size(c101, 1);
cost = zeros(numNodes, numNodes);
for i=1:numNodes
   for j=1:numNodes
       if i == j
           continue
       else
           % Euclidean Distance between nodes
           cost(c101(i,1),c101(j,1)) = sqrt((abs(c101(i,2) - c101(j,2)))^2 + (abs(c101(i,3) - c101(j,3)))^2);
       end
   end
end

% In keeping with the 4*tot_bits method discussed in class, but because
% this problem setup is using "gene/integer/Natural" level encoding,
% we will have a population size of 4*num_genes. The minus one
% accounts for the depot_node in the data set that is not part of the
% customers/node base (gene:customer 1:1 mapping).
pop_size = 2*(size(c101,1) - 1);

init_gen = []; 
%Initial Generation:
for i=1:pop_size
    rp = randperm(101);
    % remove depot index (1) from initial generation.
    rp(rp==1) = [];
    init_gen = [init_gen; rp];
end

pareto_matrix = [];


% Setting up the initial population:
for c=1:pop_size
    chromo = init_gen(c,:);
    
    % Initialize new individual's parameters
    routes = [];
    route_metrics =[];
    new_route = [];

    current_node = depot_node(1);
    route_travel_time = 0;
    route_load = max_cap;
    
    % Decode routes from Chromosome
    for i=1:numel(chromo)
        next_node = chromo(i);
        cost_to_next = cost(current_node, next_node);
        demand_at_next = c101(next_node,4);

        % Capacity Constraint
        feasible_service = ((route_load - demand_at_next) >= 0);

        % Time window Constraint
        open_time = c101(next_node,5);
        close_time = c101(next_node,6);

        % if service is available too soon, wait until open window.
        if (feasible_service && (open_time > route_travel_time) )
            route_travel_time = open_time;
        end

        % if vehicle load allows then:
        %   service is feasible if travel_time_to_next is within window
        %   and travel_time_from_next_to_depot is within depot window.
        if (feasible_service)
            feasible_service = ( ( (open_time <= route_travel_time) ...
                                        && (route_travel_time < close_time) ...
                                 ) && ( (route_travel_time...
                                         + cost_to_next...
                                         + cost(next_node,depot_node(1)))...
                                         < depot_node(6)...
                                      )...
                               ); 
        end

        % Route Update
        % if service is feasible,
        %   update time and load
        %   accept and append next_node to new_route
        % else
        %   update total routes list and begin new route from depot.
        %   Re-init at start of next route.
        if (feasible_service)
            % cumulative route time
           route_travel_time = route_travel_time + cost_to_next;

           % Cumulative load depletion.
           route_load = route_load - demand_at_next;
           new_route = [new_route next_node];
           current_node = next_node;
        end   
        if (~feasible_service || (feasible_service && i == numel(chromo)))
            % need to append enough zeros to dinamically grow routes
            new_route = [new_route zeros(1,(numNodes-numel(new_route)))];
            routes = [routes; new_route];
            route_metrics = [route_metrics; [route_travel_time numel(find(new_route))] ];
            new_route = [next_node];
            current_node = depot_node(1);
            route_travel_time = cost(current_node,next_node);
            route_load = max_cap-c101(next_node,4);

            % In the case that we ended on one node, make it its own route
            % Note: single node routes are always feasible.
            if (~feasible_service && i == numel(chromo))
                new_route = [new_route zeros(1,(numNodes-numel(new_route)))];
                routes = [routes; new_route];
                route_metrics = [route_metrics; [route_travel_time numel(find(new_route))] ];
            end
        end

    end
    % Sanity check: Sum of nodes visited must equal number of genes.
    assert(sum(route_metrics(:,2)) == numel(chromo));

    num_routes = size(routes, 1);
    total_cost = sum(route_metrics(:,1));
    
    % Saving important information for the individual in the current
    % generation struct.
    
    currGen(c).chromo = chromo;
    currGen(c).routes = routes;
    currGen(c).routeCosts = route_metrics(:,1);
    currGen(c).numRoutes = num_routes;
    currGen(c).totCost = total_cost;
    currGen(c).paretoRank = Inf;
    
    % pareto_matrix has 4 columns per individual/chromosome:
    % node that when we first build this rank is Inf
    %                                           rank                num_routes      total_cost    chromo_idx
    %pareto_matrix = [pareto_matrix; currGen(c).paretoRank currGen(c).numRoutes currGen(c).totCost c];
    
end

% Pareto Ranking (non-domination) of each individual
%currGen = ParetoRanking(currGen);


% This is the main loop.
current_best = [];%currGen.paretoRank(pareto_matrix(:,1)==1,:);
maxGens = 400;
for gens=1:maxGens
    % Pareto Ranking (non-domination) of each individual
    currGen = ParetoRanking(currGen);
    
    % Size of current best can vary. These are all the rank 1's. After
    % tournament and crossover/mutation and ranking, we will replace these
    % individuals with the next generation's worst individuals. This will
    % ensure they compete. Elitist method.
    
     ranks = [currGen.paretoRank];
     best_of_gen = currGen(ranks(:)==1);

    % Tournament
    % Pareto-Ranking is used as the fitness criterion for sorting the
    % current generation by fitness. The fittest individuals (upper half)
    % are selected for Crossover. The bottom half is discarded. 
    % Each parent generates a child to complete the next generation. This
    % guarantees that the fittest individuals of the previous generation
    % live on. Crossover is achieved by randomly pairing parents.
    best_half = currGen([1:pop_size/2]);
    
    
    
    parents = best_half;

    printing = 0;
    newGen = [];
    % Form pairings
    mix_parents_idx = randperm(size(parents,2));
    for i=2:2:(size(parents,2))
        pA = parents(mix_parents_idx(i-1));
        pB = parents(mix_parents_idx(i));

        [cA,cB] = CrossoverOp(pA,pB);
        pA.paretoRank = Inf;
        pB.paretoRank = Inf;
        newGen = [newGen pA pB cA cB];
    end

    lastGen = currGen;
    currGen = newGen;

    % What is left:
    % -- Use elitist method (keep best individual - lowest total distance)
    % - Need to define mutation operator: 
    % -- only if there is time.
    % - Then pareto-rank again.
    % - Repeat.
    
    % Display results: printing = 1
    
    routeNums = [best_of_gen.numRoutes];
    [min_route,min_route_idx] = min(routeNums);
    
    totCosts = [best_of_gen.totCost];
    [min_cost, min_cost_idx] = min(totCosts);
    
    PlotRoute(best_of_gen(min_route_idx), 1);
    after=0;
    
    if printing
        disp(['GA Iteration    BestNRoutes BestCost']);
        disp([sprintf('    %d               %d         %d',gens,best_of_gen(min_route_idx).numRoutes,best_of_gen(min_cost_idx).totCost)]);
    end
end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    