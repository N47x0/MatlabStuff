function [child_A, child_B] = crossover(parent_A, parent_B)
    % Perform Crossover.
    % Child A/B <==> Parent A/B
    % Select a random route from Parent A/B. Discard the nodes in that
    % route in Child B/A
    cA = parent_A;
    cB = parent_B;
    
    idx = randperm(cA.numRoutes);
    rand_routeA = cA.routes(idx(1),:);
    idx = randperm(cB.numRoutes);
    rand_routeB = cB.routes(idx(1));
    
    child_A = make_child(rand_routeB,cA);
    child_B = make_child(rand_routeA,cB);

end

function child = make_child(rand_route, parent)

    global depot_node;
    global cost;
    
    temp_child = parent;
    numNodes = length(temp_child.routes(1,:));
    for r=1:temp_child.numRoutes
        route = temp_child.routes(r,:);
        [~,ismem] = ismember([rand_route], route);
        route([ismem(find(ismem))]) = [];
        route = [route zeros(1,(numNodes-numel(route)))];
        temp_child.routes(r,:) = route(:);
    end
    
    empty_row_idx = find(~temp_child.routes(:,1));
    
    if(empty_row_idx)
       temp_child.routes(empty_row_idx,:) = [];
       temp_child.numRoutes = temp_child.numRoutes - 1;
       temp_child.routeCosts(empty_row_idx,:) = [];
    end
    
    reassign_metrics = [];
    new_routes = [];
    for n=1:length(find(rand_route))
        for r=1:temp_child.numRoutes
            [feasible_insert, route_cost, new_route] = InsertionTest(rand_route(n),temp_child.routes(r,:));
            new_routes = [new_routes; new_route];
            reassign_metrics = [reassign_metrics; feasible_insert route_cost r];
            if (~feasible_insert)
                reassign_metrics(r,3) = 0;
            end
            % If InsertionTest failed on all available routes.
            % Then create a new, single node route. Note: Single node
            % routes are always feasible.
            if(~size(find(reassign_metrics),1))
                temp_child.routes = [temp_child.routes; [rand_route(n) zeros(1,numNodes-1)]];
                temp_child.numRoutes = temp_child.numRoutes + 1;
                temp_child.routeCosts = [temp_child.routeCosts; cost(depot_node(1),rand_route(n))*2];
            end
            
        end
    end
    
    reassign_metrics(all(reassign_metrics==0,2),:) = [];
    new_routes(all(new_routes==0,2),:) = [];
    
    if (size(find(new_routes),1))
        route_costs = reassign_metrics(:,2);
        min_route_cost = min(route_costs);
        min_idx = find(reassign_metrics(:,2)==min(min(reassign_metrics(:,2))));

        % Update new individuals parameters
        temp_child.routes(reassign_metrics(min_idx,3),:) = new_routes(min_idx,:);
        temp_child.routeCosts = [temp_child.routeCosts; min_route_cost];
    end
    
    % Reset chromosome to update with new route info.
    temp_child.chromo = [];
    for i=1:temp_child.numRoutes
        temp_child.chromo = [temp_child.chromo temp_child.routes(i,find(temp_child.routes(i,:)))];
    end
    

    temp_child.totCost = sum(temp_child.routeCosts);
    
    child = temp_child;
    
end
