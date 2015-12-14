function ranking = pareto_ranking(pareto_matrix)

    global pop_size;
    
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
    
    ranking = temp_ranks;

end