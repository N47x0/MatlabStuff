function [feasible, route_cost, new_route] = InsertionTest(node,route)
% Return best fitness node insertion in t_route
    global c101; 
    global max_cap;
    global cost
    depot_node = c101(1,:);
    t_route = route(find(route));
    feasible = 0;
    new_route = zeros(1,length(route));
    route_cost = 0;
    insertion_cost = [];
    % Adding the node might not be possible because there is no available
    % capacity left in this t_route.
     if((c101(node,4) + sum(c101(t_route , 4))) <= max_cap)
         feasible = 1;
         for i=1:numel(t_route)
             if (i == 1)
                routeTime = cost(depot_node(1), node);
                routeTime = AdjustOpenServiceTime(node, routeTime);
                feasible = CheckCloseServiceTime(node, routeTime);
                if (~feasible)
                    return;
                end
             elseif(i == 2)
                routeTime = cost(depot_node(1), t_route(1));
                routeTime = AdjustOpenServiceTime(t_route(1), routeTime);
                feasible = CheckCloseServiceTime(t_route(1), routeTime);
                if (~feasible)
                    return;
                end
             else
                routeTime = cost(depot_node(1), t_route(1));
                for c=2:i
                    if (c < i)
                        routeTime = routeTime + cost(t_route(c-1),t_route(c));
                        routeTime = AdjustOpenServiceTime(t_route(c), routeTime);
                        feasible = CheckCloseServiceTime(t_route(c), routeTime);
                        if (~feasible)
                            return;
                        end
                    else
                        routeTime = routeTime + cost(t_route(c-1), node);
                        routeTime = AdjustOpenServiceTime(node, routeTime);
                        feasible = CheckCloseServiceTime(node, routeTime);
                        if (~feasible)
                            return;
                        end
                    end 
                end
             end
             timeToNode = routeTime;
             lastNode = node;
             if(i <= numel(t_route))
                 for j=i:numel(t_route)
                     timeToNode = timeToNode + cost(lastNode, t_route(j));
                     routeTime = AdjustOpenServiceTime(t_route(j), timeToNode);
                     feasible = CheckCloseServiceTime(t_route(j), timeToNode);
                     if (~feasible)
                         return;
                     else
                         lastNode = t_route(j);
                     end
                 end
             end
             routeTime = timeToNode + cost(lastNode, depot_node(1));
             if (feasible)
                 position_of_insertion = i;
                 insertion_cost = [insertion_cost; position_of_insertion routeTime];                
             end
         end
         
         [min_cost, min_pos] = min(insertion_cost(:,2));
         new_route = InsertNodeIntoRoute(node, t_route, min_pos);
         new_route = [new_route zeros(1,length(route)-length(new_route))];
         route_cost = min_cost;
     else
         return;
     end
end     
    
function [routeTime] = AdjustOpenServiceTime(node_id, currentTime)
    global c101;
    if (currentTime < c101(node_id,5))
        routeTime = c101(node_id,5);
    else
        routeTime = currentTime;
    end
end

function [feasible] = CheckCloseServiceTime(node_id, currentTime)
    global c101;
    global cost;
    global depot_node;
    feasible = (   currentTime <= c101(node_id, 6) ...
                && ((currentTime + cost(node_id,depot_node(1))) <= depot_node(6))...
               );
end

function [new_route] = InsertNodeIntoRoute(node, t_route, insertion_idx)
    new_route = zeros(1,length(t_route)+1);
    new_route(insertion_idx) = node;
    new_route(~new_route) = t_route;
end