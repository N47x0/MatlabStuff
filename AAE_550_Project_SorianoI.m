%% AAE 550 Final Project Ignacio Soriano
%function [] = AAE_550_Project()
clc
clear all

%Consider removing first element (as the depot)
global c101; 
global max_cap;
global cost;
global depot_node;
c101 = load('solomonC101.dat');
max_cap = 200;

% Save the first node as depot [and remove from the list.] cancelled
depot_node = c101(1,:);
%c101([1], :)=[];

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
% we will have a population size of 4*num_individuals. The minus one
% accounts for the depot_node in the data set that is not part of the
% population.
pop_size = 4*(size(c101,1) - 1);


init_gen = []; 
%Initial Generation:
for i=1:pop_size
    rp = randperm(101);
    % remove depot index (1) from initial generation.
    rp(rp==1) = [];
    init_gen = [init_gen; rp];
end

pareto_matrix = [];

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
    currGen(c).chromo = c;
    currGen(c).routes = routes;
    currGen(c).numRoutes = num_routes;
    currGen(c).totCost = total_cost;
    
    % pareto_matrix has 4 columns per individual/chromosome:
    % node that when we first build this rank is Inf
    %                              rank num_routes total cost chromo_idx
    pareto_matrix = [pareto_matrix; Inf num_routes total_cost c];
    
end

temp_ranks = [];
rank = 1;
currentRank = 1;
n = pop_size;
% Pareto Ranking (non-domination) of each individual
while (n > 0)
    for c=1:n
        rank = currentRank;
        for cc=1:n
            if ( (   pareto_matrix(c,2) > pareto_matrix(cc,2) ...
                 &&  pareto_matrix(c,3) >= pareto_matrix(cc,3) ) ...
              || (   pareto_matrix(c,2) >= pareto_matrix(cc,2) ...
                 &&  pareto_matrix(c,3) > pareto_matrix(cc,3)) ) 

                rank = currentRank + 1;
                break;
            else
                continue;
            end
        end
        pareto_matrix(c,1) = rank;
        
    end
    temp_ranks = [temp_ranks; pareto_matrix(pareto_matrix(:,1)==currentRank,:)];
    
    pareto_matrix(pareto_matrix(:,1)==currentRank,:) = [];
    n = pop_size - size(temp_ranks, 1);
    currentRank = currentRank +1;
end
% v_sorted = sortrows(pareto_matrix,2);
% c_sorted = sortrows(pareto_matrix,3);
% r_sorted = sortrows(pareto_matrix,1)

pareto_matrix = temp_ranks;

% Size of current best can vary. These are all the rank 1's. After
% tournament and crossover/mutation and ranking, we will replace these
% individuals with the next generation's worst individuals. This will
% ensure they compete.
current_best = pareto_matrix(pareto_matrix(:,1)==1,:);
current_best = currGen(current_best(1,1));

% Tournament
% The population is randomly broken into sets of 4. The fittest individual
%  (using pareto-ranking) is selected as a parent. Each parent is combined
%  with the others to produce 2 children per pairing, such that 
rank_sorted = sortrows(pareto_matrix,1);
best_quarter = rank_sorted([1:pop_size/4],:);
rank_sorted([1:pop_size/4],:) = [];

% Select the remaining quarter.
rand_idxs = randperm(pop_size/4);
rand_quarter = rank_sorted(rand_idxs, :);
parents = [best_quarter; rand_quarter];

children = [];
% Form pairings
mix_parents_idx = randperm(size(parents,1));
for i=2:2:(size(parents,1))
    pA = currGen(parents(mix_parents_idx(i-1)));
    pB = currGen(parents(mix_parents_idx(i)));
    
    children = [children crossover(pA,pB)];
    disp('Generation Step')
    disp(i/2);
    
end


% What is left:
% - Need to define how many individuals to pit in competition:
% -- Tournament Stage/Parent Selection.
% -- Use elitist method (keep best individual - lowest total distance)
% - Select Parents:
% - Need to define crossover operator:
% -- Then randomly select a route from a parent(A) and reassign the nodes
%    in that route within parent(B). Select best reassignment. If all
%    reasignments are infeasible, create new route.
% - Need to define mutation operator: 
% -- only if there is time.
% -- Then pareto-rank again.
% -- Repeat.


% Display results: printing = 1
printing = 0;

if printing
    clf
    figure(1)
    hold on
    grid on

    for i=1:numNodes
        plot(c101(i,2),c101(i,3),'o'); 
    end
    
    for i=1:current_best.numRoutes
        x = [depot_node(2)];
        y = [depot_node(3)];
        nextPoint = [];
        numPaths = size(find(current_best.routes(i,:)),2);
        for j=1:numPaths
            x = [x c101(current_best.routes(i,j),2)];
            y = [y c101(current_best.routes(i,j),3)];
            if (j == numPaths)
                x = [x depot_node(2)];
                y = [y depot_node(3)];
            end
            plot(x,y,'-r');
        end
        
    end
end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    