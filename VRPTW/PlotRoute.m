% Display results: printing = 1
function [] = PlotRoute(current_best, toPrint)
    global printing;
    global c101;
    global depot_node;
    
    printing = toPrint;

    if printing
        clf
        figure(1)
        hold on
        grid on

        for i=1:length(current_best.chromo)
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
end