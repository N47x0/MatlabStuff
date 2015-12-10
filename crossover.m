function [child_A, child_B] = crossover(parent_A, parent_B)
    % Perform Crossover.
    % Child A/B = Parent A/B
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
    numNodes = length(parent.routes(1,:));
    for r=1:parent.numRoutes
        route = parent.routes(r,:);
        [~,ismem] = ismember([rand_route], route);
        route([ismem(find(ismem))]) = [];
        route = [route zeros(1,(numNodes-numel(route)))];
        parent.routes(r,:) = route(:);
    end
    
    empty_row_idx = find(~parent.routes(:,1));
    
    if(empty_row_idx)
       parent.routes(empty_row_idx,:) = [];
       parent.numRoutes = parent.numRoutes - 1;
    end
    
    reassign_metrics = [];
    new_routes = [];
    for n=1:length(find(rand_route))
        for r=1:parent.numRoutes
            [feasible_insert, route_cost, new_route] = InsertionTest(rand_route(n),parent.routes(r,:));
            new_routes = [new_routes; new_route];
            reassign_metrics = [reassign_metrics; feasible_insert route_cost];
        end
    end
    
    reassign_metrics(all(reassign_metrics==0,2),:) = [];
    new_routes(all(new_routes==0,2),:) = [];
    
    route_costs = reassign_metrics(:,2);
    min_route_cost = min(route_costs);
    min_idx = find(reassign_metrics(:,2)==min(min(reassign_metrics(:,2))));
    
    parent.routes = [parent.routes; new_routes(min_idx,:)];
    parent.numRoutes = parent.numRoutes + 1;
    
    child = parent;
    
end
