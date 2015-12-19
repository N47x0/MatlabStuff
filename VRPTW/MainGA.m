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
max_cap = 200;

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

scented_gen = [];
rp = randperm(101);
% remove depot index (1) from initial generation.
rp(rp==1) = [];

while (size(rp,2) > 0)
    i = rp(1);
    scented_gen = [scented_gen i];
    rp(1) = [];
    rel_dist = Inf;
    candidate = 0;
    for j=1:numel(rp)
        if (cost(i,rp(j)) < rel_dist)
            rel_dist = cost(i,rp(j));
            candidate = rp(j);
        end
    end
    scented_gen = [scented_gen candidate];
end

% In keeping with the 4*tot_bits method discussed in class, but because
% this problem setup is using "gene/integer/Natural" level encoding,
% we will have a population size of 4*num_genes. The minus one
% accounts for the depot_node in the data set that is not part of the
% customers/node base (gene:customer 1:1 mapping).
pop_size = (size(c101,1) - 1);
Z = zeros(1, pop_size);
init_gen = []; 
%Initial Generation:
for i=1:pop_size
    
    if (i <= round(pop_size/10))
        scented_gen = [];
        rp = randperm(101);
        % remove depot index (1) from initial generation.
        rp(rp==1) = [];

        while (size(rp,2) > 0)
            i = rp(1);
            scented_gen = [scented_gen i];
            rp(1) = [];
            rel_dist = Inf;
            candidate = 0;
            cand_idx = 0;
            for j=1:numel(rp)
                if (cost(i,rp(j)) < rel_dist)
                    rel_dist = cost(i,rp(j));
                    candidate = rp(j);
                    cand_idx = j;
                end
            end
            rp(cand_idx) = [];
            scented_gen = [scented_gen candidate];
        end
        init_gen = [init_gen; scented_gen];
    else
        rp = randperm(101);
        % remove depot index (1) from initial generation.
        rp(rp==1) = [];
        init_gen = [init_gen; rp];
    end
end

% Setting up the initial population:
for c=1:pop_size
    chromo = init_gen(c,:);
    
    new_individual = DecodeChromosome(chromo);

    % Saving important information for the individual in the current
    % generation struct.
    currGen(c) = new_individual;
    
end

% Pareto Ranking (non-domination) of each individual
%currGen = ParetoRanking(currGen);


% This is the main loop.
last_gen_best = currGen(1);
maxGens = 400;
for gens=1:maxGens
    
    assert(size(currGen,2)==pop_size)
    
    % Pareto Ranking (non-domination) of each individual
    currGen = ParetoRanking(currGen);
    Z=[[currGen.paretoRank]; Z];
    % Size of current best can vary. These are all the rank 1's. After
    % tournament and crossover/mutation and ranking, we will replace these
    % individuals with the next generation's worst individuals. This will
    % ensure they compete. Elitist method.
    ranks = [currGen.paretoRank];
    best_of_gen = currGen(ranks(:)==1);
     
    totCosts = [best_of_gen.totCost];
    [~,u] = unique(totCosts);
    best_of_gen = best_of_gen([u]);
    newGen = [best_of_gen];
    
    % Best evolution rate will determine mutation rate to aid search away
    % from local optima.
    rel_mins = [];
    for i=1:min([length(best_of_gen),length(last_gen_best)]) 
        rel_mins = [rel_mins; abs((best_of_gen(i).totCost/last_gen_best(i).totCost))];
    end
    
    mut_rate = (min(rel_mins));
    if(mut_rate > 0.1);
        new_rand_immigrants = randperm(round(pop_size*0.1));
        for i=1:length(new_rand_immigrants)
            rand_immigrant = DecodeChromosome(randperm(length(newGen(1).chromo)));
            newGen = [newGen rand_immigrant];
        end
    end
    
    disp([sprintf('Number of best carry overs: %d', size(best_of_gen,2))])
    disp([sprintf('New Mutation Rate: %1.4f', (mut_rate))]);
    
    % Tournament
    % Pareto-Ranking is used as the fitness criterion for sorting the
    % current generation by fitness. The fittest individuals (upper half)
    % are selected for Crossover. The bottom half is discarded. 
    % Each parent generates a child to complete the next generation. This
    % guarantees that the fittest individuals of the previous generation
    % live on. Crossover is achieved by randomly pairing parents.
%     best_half = currGen([1:pop_size/2]);
%     
%     parents = best_half;

    parents = [best_of_gen];
    tournamentSet = currGen;
    tourney_idx = [randperm(pop_size) randperm(pop_size)];
    
    while(length(newGen)<pop_size)
        pugilists = [];
        i = 2;
        while (length(parents)<2)
            pugilists = [pugilists tournamentSet(tourney_idx(i)) ...
                                   tournamentSet(tourney_idx(i-1))];
            tourney_idx([i, i-1]) = [];
                      
            paretoRanks = [pugilists.paretoRank];
            [minRank,minRank_idx] = min(paretoRanks);

            if (rand()<0.8)
                victor = pugilists(minRank_idx);
            else
                victor = pugilists(randperm(length(pugilists),1));
            end

            parents = [parents victor];
        end

        printing = 0;
        
        % Form pairings 
        mix_parents_idx = randperm(length(parents));

        pA = parents(mix_parents_idx(1)); % length based better!
        pB = parents(mix_parents_idx(2)); % length based better!
        parents = [];
        
%         if (rand() < 0.1 && i > 2)
%             mutant = randperm(101);
%             mutant(mutant==1) = [];
%             pA = DecodeChromosome(mutant);
%         end

        [cA,cB] = CrossoverOp(pA,pB);
        pA.paretoRank = Inf;
        pB.paretoRank = Inf;
        newGen = [newGen cA cB];
        
        if (rand() <= mut_rate)
            cA = MutateOp(cA);
        end
        if (rand() <= mut_rate)
            cB = MutateOp(cB);
        end
    end
    
    if (length(newGen) ~= pop_size)
        newGen(end) = [];
    end
    assert(length(newGen) == pop_size);

    last_gen_best = best_of_gen;
    currGen = newGen;

    % What is left:
    % - Need to define mutation operator: 
    % -- only if there is time.
    
    
    routeNums = [best_of_gen.numRoutes];
    [min_route,min_route_idx] = min(routeNums);
    
    totCosts = [best_of_gen.totCost];
    [min_cost, min_cost_idx] = min(totCosts);
    
    
    
    gen_stats(gens).gens = gens;
    gen_stats(gens).bestNumRoutes = best_of_gen(min_route_idx).numRoutes;
    gen_stats(gens).bestNumRoutesChromo = best_of_gen(min_route_idx).chromo;
    gen_stats(gens).bestCost = best_of_gen(min_cost_idx).totCost;
    gen_stats(gens).bestCostChromo = best_of_gen(min_cost_idx).chromo;

    PlotRoute(best_of_gen(min_route_idx), 1);
    after=0;
    
    if printing
        disp(['GA Iteration    BestNRoutes BestCost']);
        disp([sprintf('    %d               %d         %d',gens,best_of_gen(min_route_idx).numRoutes,best_of_gen(min_cost_idx).totCost)]);
    end
    
    if (gens == 25)
        breakp = 0;
    end
    if(gens == 50)
        breakp = 0;
    end
    if(gens == 75)
        breakp = 0;
    end
    
    figure(2)
    clf
    plot(routeNums,totCosts);
    
    figure (3)
    hold on
    grid on
    if(gens>1)
        xpt = [prev_g, gens];
        fr = [prev_r, min_route*10^3];
        fc = [prev_c, min_cost];

        plot(xpt, fr, '-g');
        plot(xpt, fc,'-b');
        prev_g = gens;
        prev_r = min_route*10^3;
        prev_c = min_cost;
    else
        clf
        prev_g = gens;
        prev_r = min_route*10^3;
        prev_c = min_cost;
        
        plot(gens,prev_r,'+r');
        plot(gens,prev_c,'ok');
    end
    
    figure(4)
    
    
    surf(Z);
    
end


stats_file = fopen('vrptw_ga_gens.txt','w');
bestRouteChromos = fopen('vrptw_ga_br_crms.txt', 'w');
bestCostChromos = fopen('vrptw_ga_bc_crms.txt', 'w');

fprintf(stats_file, '%15s %15s %15s\r\n','GA Iteration','Best#Routes','BestCost');
fprintf(bestRouteChromos,'%15s %6s\r\n','GA Iteration', 'chromo')
fprintf(bestCostChromos,'%15s %6s\r\n','GA Iteration', 'chromo')

for i=1:size(gen_stats,2)
    stats = gen_stats(i);
    fprintf(stats_file,'%15i %15i %15i\r\n',stats.gens, stats.bestNumRoutes, stats.bestCost);
    fprintf(bestRouteChromos, '%d\r\n', stats.bestNumRoutesChromo);
    fprintf(bestCostChromos, '%d\r\n',  stats.bestCostChromo);
end
    
    
fclose(stats_file);
fclose(bestRouteChromos);
fclose(bestCostChromos);
    


    
    
    
%     parents = [best_of_gen];
%     tournamentSet = currGen;
%     tourney_idx = randperm(pop_size);
%     while(length(parents)<pop_size/2)
%         pugilists = [];
%         for i=1:2
%             pugilists = [pugilists tournamentSet(tourney_idx(i))];
%             tourney_idx(i) = [];
%         end
%         
%         paretoRanks = [pugilists.paretoRank];
%         [minRank,minRank_idx] = min(paretoRanks);
%         
%         if (rand()<0.8)
%             victor = pugilists(minRank_idx);
%         else
%             victor = pugilists(randperm(length(pugilists),1));
%         end
%         
%         parents = [parents victor];
%     end
% 
%     printing = 0;
%     newGen = [];
%     % Form pairings 
%     mix_parents_idx = randperm(size(parents,2));
%     for i=2:2:(size(parents,2))
%         pA = parents(mix_parents_idx(i-1));
%         pB = parents(mix_parents_idx(i));
%         
% %         if (rand() < 0.1 && i > 2)
% %             mutant = randperm(101);
% %             mutant(mutant==1) = [];
% %             pA = DecodeChromosome(mutant);
% %         end
% 
%         [cA,cB] = CrossoverOp(pA,pB);
%         pA.paretoRank = Inf;
%         pB.paretoRank = Inf;
%         newGen = [newGen cA cB];
%         
%         if (rand() <= 0.1)
%             cA = MutateOp(cA);
%         end
%         if (rand() <= 0.1)
%             cB = MutateOp(cB);
%         end
%     end
% 
%     currGen = newGen;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    