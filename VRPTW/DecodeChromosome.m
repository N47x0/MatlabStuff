function [individual] = DecodeChromosome(chromo)
    
    global c101;
    global cost;
    global depot_node;
    global max_cap;
    
    numNodes = size(c101, 1) - 1;
    
    % Initialize new individual's parameters
    routes = [];
    route_metrics =[];
    new_route = [];

    % New chromosome starts at depot with full cap.
    current_node = depot_node(1);
    route_travel_time = 0;
    route_load = max_cap;
    
    % Decode routes from Chromosome
    for i=1:numel(chromo)
        next_node = chromo(i);
        cost_to_next = cost(current_node, next_node);
        demand_at_next = c101(next_node,4);
        service_time_at_next = c101(next_node,7);

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
            feasible_service = ( ( (open_time <= route_travel_time) ...             % Ensures arrival is possible
                                        && (route_travel_time < close_time) ...     % Ensures arrival before closing
                                 ) && ( (route_travel_time...                       % Current_route_time
                                         + cost_to_next...                          % plus time to next (cost = time)
                                         + cost(next_node,depot_node(1)))...        % plus time from next to depot
                                         + service_time_at_next...                     % plus service time
                                         < depot_node(6)...                         % is less than depot closing time.
                                      )...
                               ); 
        end

        % Route Update
        % if service is feasible,
        %   update time and load
        %   accept and append next_node to new_route
        % if not_feasible or feasible_but_last_node
        %   update total routes list and begin new route from depot.
        %   Re-init at start of next route.
        % If not_feasible_and_last_node
        %   create single node route
        %   single node routes always feasible.
        if (feasible_service)
            % cumulative route time
           route_travel_time = route_travel_time + cost_to_next + service_time_at_next;

           % Cumulative load depletion.
           route_load = route_load - demand_at_next;
           new_route = [new_route next_node];
           current_node = next_node;
        end   
        % 
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
    assert(sum(route_metrics(:,2)) == numel(chromo))
    
    individual.chromo = chromo;
    individual.routes = routes;
    individual.routeCosts = route_metrics(:,1);
    individual.numRoutes = size(routes, 1);
    individual.totCost = sum(route_metrics(:,1));
    individual.paretoRank = Inf;
    
    % Phase 2 insertion.
    for i=1:(size(routes,1)-1)
        feasible_service = 0;
        route=routes(i);
        last_of_route = route(length(find(route)));
        route(length(find(route))) = [];
        n_route = routes(i+1);
%         if ()
%         
%         end
    
    end
end

function feasible = TestFeasibleTime(open_time...
    , close_time...
    , route_travel_time...
    , current_node...
    , next_node)

    cost_to_next = cost(current_node, next_node);
    service_time_at_next = c101(next_node,7);
    
    feasible= ( ( (open_time <= route_travel_time) ...              % Ensures arrival is possible
                        && (route_travel_time < close_time) ...     % Ensures arrival before closing
                 ) && ( (route_travel_time...                       % Current_route_time
                         + cost_to_next...                          % plus time to next (cost = time)
                         + cost(next_node,depot_node(1)))...        % plus time from next to depot
                         + service_time_at_next...                  % plus service time
                         < depot_node(6)...                         % is less than depot closing time.
                      )...
               ); 

end

function feasible = TestFeasibleLoad(route_load, next_node)
    % Capacity Constraint
    demand_at_next = c101(next_node, 4);
    feasible = ((route_load - demand_at_next) >= 0);
end

function [new_route, route_metrics] = UpdateRoutes()
    
end