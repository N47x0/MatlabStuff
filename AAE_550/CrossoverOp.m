function [child_A, child_B] = CrossoverOp(parent_A, parent_B)
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
    
    child_A = MakeChild(rand_routeB,cA);
    child_B = MakeChild(rand_routeA,cB);

end

function child = MakeChild(rand_route, parent)

    global depot_node;
    global cost;
    global printing;
    
    persistent improved worsend;
    if (isempty(improved))
        improved = 0;
        worsend = 0;
    end

    % Use a copy of the parent to be modified as a base for new child.
    temp_child = parent;
    numNodes = length(temp_child.routes(1,:));
    
    % Iterate over routes and determine if each route contains one or more
    % of the nodes contained in the random route inherited from the other
    % parent. When the route containing any of those nodes is found, the
    % nodes are removed from that route.
    for r=1:temp_child.numRoutes
        route = temp_child.routes(r,:);
        [~,ismem] = ismember([rand_route], route);
        route([ismem(find(ismem))]) = [];
        route = [route zeros(1,(numNodes-numel(route)))];
        temp_child.routes(r,:) = route(:);
    end
    
    empty_rows = 0;
    empty_rows = find(all(temp_child.routes == 0,2));
    
    if(empty_rows)
       temp_child.routes(empty_rows,:) = [];
       temp_child.numRoutes = temp_child.numRoutes - length(empty_rows);
       temp_child.routeCosts(empty_rows,:) = [];
    end

    new_routes = [];
    nR = temp_child.numRoutes;
    for n=1:length(find(rand_route))
        reassign_metrics = [];
        for r=1:nR
            % Debugging statement
            if (nR > size(temp_child.routes,1))
                breakp;
            end
            
            [feasible_insert, route_cost, new_route] = InsertionTest(rand_route(n),temp_child.routes(r,:));
            new_routes = [new_routes; new_route];
            reassign_metrics = [reassign_metrics; feasible_insert route_cost r];
            if (~feasible_insert)
                reassign_metrics(r,3) = 0;
            end
            
        end
        % If InsertionTest failed on all available routes.
        % Then create a new, single node route. Note: Single node
        % routes are always feasible.
        if(~size(find(reassign_metrics),1))
            temp_child.routes = [temp_child.routes; [rand_route(n) zeros(1,numNodes-1)]];
            temp_child.numRoutes = temp_child.numRoutes + 1;
            temp_child.routeCosts = [temp_child.routeCosts; cost(depot_node(1),rand_route(n))*2];
            %disp('Insertion Failed!');
        end
        
        % Remove empty rows
        reassign_metrics(all(reassign_metrics==0,2),:) = [];
        new_routes(all(new_routes==0,2),:) = [];

        % If new updated routes were found.
        if (size(find(new_routes),1))
            route_costs = reassign_metrics(:,2);
            min_route_cost = min(route_costs);
            min_idx = find(reassign_metrics(:,2)==min(min(reassign_metrics(:,2))));

            % Update new individual's parameters
            route_idx = reassign_metrics(min_idx,3);
            temp_child.routes(route_idx,:) = new_routes(min_idx,:);
            temp_child.routeCosts(route_idx) = min_route_cost;
        end
    end
        
    % Reset chromosome to update with new route info.
    temp_child.chromo = [];
    for i=1:temp_child.numRoutes
        temp_child.chromo = [temp_child.chromo temp_child.routes(i,find(temp_child.routes(i,:)))];
    end
    
    %Debugging Statement
    if (length(temp_child.chromo) > 100)
        breakp
    end
    
    temp_child.totCost = sum(temp_child.routeCosts);
    temp_child.paretoRank = Inf; %unknown rank for now.
    % Could Check here to see if there was an improvement in total cost
    % from the parent.
    if (temp_child.totCost <= parent.totCost)
        improved = improved+1;
    else
        worsend = worsend+1;
    end
    
    if (printing)
        disp('improved    worsend');
        disp([sprintf('  %d    %d',improved,worsend)]);
    end
    
    child = temp_child;
    
end
