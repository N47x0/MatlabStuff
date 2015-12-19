function mut_child = MutateOp(child)
    
    mut_child = child;
    mut_chromo = child.chromo;
    rt_idx = randperm(child.numRoutes);
    rand_route = child.routes(rt_idx(1));
    
    if (size(rand_route,2)>2)
        nd_idx = randperm(size(rand_route,2));
        nd = rand_route(nd_idx(1));
        cm_idx = find(mut_chromo==nd);
        if(rand > 0.5)
            t_nd = mut_chromo(cm_idx + 1);
            mut_chromo(cm_idx+1) = nd;
            mut_chromo(cm_idx) = t_nd;
        else
            t_nd = mut_chromo(cm_idx + 2);
            mut_chromo(cm_idx+2) = mut_chromo(cm_idx+1);
            mut_chromo(cm_idx+1) = mut_chromo(cm_idx);
            mut_chromo(cm_idx) = t_nd;
        end
        % chromo still unique (all nodes visited)
        assert(numel(unique(mut_chromo)) == numel(mut_chromo)); 
    end
    
    mut_child = DecodeChromosome(mut_chromo);
    
end