function ranking_sorted = ParetoRanking(generation)
    
    temp_gen = generation';
    rank = 1;
    currentRank = 1;
    pop_size = size(temp_gen,1);
    n = pop_size;
    t_gen = [];
    % Pareto Ranking (non-domination) of each individual
    while (n > 0)
        for c=1:n
            rank = currentRank;
            for cc=1:n
                if ( (   temp_gen(c).numRoutes >  temp_gen(cc).numRoutes ...
                     &&  temp_gen(c).totCost   >= temp_gen(cc).totCost ) ...
                  || (   temp_gen(c).numRoutes >= temp_gen(cc).numRoutes ...
                     &&  temp_gen(c).totCost   >  temp_gen(cc).totCost) ) 

                    rank = currentRank + 1;
                    break;
                else
                    continue;
                end
            end
            temp_gen(c).paretoRank = rank;

        end
        ranks = [temp_gen.paretoRank];
        
        [~,tg_idx] = ismember(ranks, currentRank);
        tg_idx=(find(tg_idx));
        t_gen =[t_gen; temp_gen([tg_idx])];
        
        temp_gen([tg_idx]) = [];
        n = pop_size - size(t_gen, 1);
        currentRank = currentRank +1;
    end
    
    ranking = t_gen';
    
    ranking_fields = fieldnames(ranking);
    ranking_cell = struct2cell(ranking);
    ranking_cell_sz = size(ranking_cell);
    ranking_cell = reshape(ranking_cell, ranking_cell_sz(1), []);
    ranking_cell = ranking_cell';
    ranking_cell = sortrows(ranking_cell,6);
    
    ranking_cell = reshape(ranking_cell',ranking_cell_sz);
    ranking_sorted = cell2struct(ranking_cell,ranking_fields,1);
    

end