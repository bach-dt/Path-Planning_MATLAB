classdef A_star
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = A_star_path(obj, map, start, goal, map_size)
            hold on;
        % COST_MAP(point_x, point_y) = [G_COST, H_COST, F_COST, parent_x, parent_y]  
            COST_MAP = zeros(map_size - 1, map_size - 1, 5);
            COST_MAP(round(start(1)), round(start(2)), 1) = 0;
            COST_MAP(round(start(1)), round(start(2)), 2) = obj.COST(start, goal);
            COST_MAP(round(start(1)), round(start(2)), 3) = ...
                COST_MAP(round(start(1)), round(start(2)), 1) + ...
                COST_MAP(round(start(1)), round(start(2)), 2);
            
            OPEN = [start(1),start(2),COST_MAP(round(start(1)), round(start(2)), 3)];
            map(round(start(1)), round(start(2))) = 2;
            CLOSED = [];
            CURRENT = start;
            while (CURRENT(1) ~= goal(1) || CURRENT(2) ~= goal(2))
                min_f_cost = map_size * 2;
                CURRENT_index = 0;
                for index = 1: 1: length(OPEN)/3
                    if OPEN( 3 * index ) < min_f_cost
                        min_f_cost = OPEN( 3 * index );
                        CURRENT = [OPEN(3 * index - 2), OPEN(3 * index - 1)];
                        CURRENT_index = 3 * index - 2;
                    end
                end
                
                disp('current: ');
                disp(CURRENT);
                disp('open: ');
                disp(OPEN);
                if (CURRENT(1) ~= start(1) || CURRENT(2) ~= start(2)) &&...
                        (CURRENT(1) ~= goal(1) || CURRENT(2) ~= goal(2))
                    plot(CURRENT(1), CURRENT(2),'whiteo',...
                        'LineWidth',1,...
                        'MarkerSize',round(360/ map_size),...
                        'MarkerEdgeColor',[0.9, 1, 0.9],...
                        'MarkerFaceColor',[0.9, 1, 0.9]);
                end

            % remove CURRENT from OPEN set
                    OPEN(CURRENT_index) = [];
                    OPEN(CURRENT_index) = [];
                    OPEN(CURRENT_index) = [];
            % add CURRENT to CLOSED set
                CLOSED = [CLOSED; CURRENT];
                map(round(CURRENT(1)), round(CURRENT(2))) = 3; 

            % continue
                neighbor = [];
                for neighbor_x = CURRENT(1)-1: 1: CURRENT(1)+1
                    for neighbor_y = CURRENT(2)-1: 1: CURRENT(2)+1
                        if (neighbor_x > 0) && (neighbor_y > 0)
                            if (neighbor_x ~= CURRENT(1) || neighbor_y ~= CURRENT(2))...
                                    && map(round(neighbor_x), round(CURRENT(2))) ~= 1 ...
                                    && map(round(CURRENT(1)), round(neighbor_y)) ~= 1 
                                
                                this_neighbor = [neighbor_x, neighbor_y];
                                neighbor = [neighbor; this_neighbor];
                        % for each neighbor
                                if (map(round(neighbor_x), round(neighbor_y)) == 1 || map(round(neighbor_x), round(neighbor_y)) == 3)
                                    continue;
                                end
                                neighbor_new_g_cost = obj.COST(this_neighbor, CURRENT) + ...
                                                      COST_MAP(round(CURRENT(1)), round(CURRENT(2)), 1);

                                if (COST_MAP(round(this_neighbor(1)), round(this_neighbor(2)), 3) == 0 || ...
                                    neighbor_new_g_cost < COST_MAP(round(this_neighbor(1)), round(this_neighbor(2)), 1))

                                    COST_MAP(round(this_neighbor(1)), round(this_neighbor(2)), :) ...
                                        = [neighbor_new_g_cost, obj.COST(this_neighbor, goal), ...
                                        neighbor_new_g_cost + obj.COST(this_neighbor, goal), ...
                                        CURRENT];


                                    if (map(round(this_neighbor(1)), round(this_neighbor(2))) ~= 2)

                                        disp('neighbor')
                                        disp(this_neighbor);
                                        map(round(this_neighbor(1)), round(this_neighbor(2))) = 2;
                                        OPEN = [OPEN, this_neighbor(1), this_neighbor(2), neighbor_new_g_cost + obj.COST(this_neighbor, goal)];
                                    end

                                end

                            end
                        end
                    end
                end
            end
            
        % print path
            path = [];
            point = CURRENT;
            while (point(1) ~= start(1) || point(2) ~= start(2))
                point = [COST_MAP(round(point(1)), round(point(2)), 4),...
                    COST_MAP(round(point(1)), round(point(2)), 5)];
                path = [path; point];
                disp(point);
            end
            
            path(length(path), :) = [];
            rand_r = rand(1) / 2 + 0.5;
            rand_g = rand(1) / 2 + 0.5;
            rand_b = rand(1) / 2 + 0.5;
            plot(path(:, 1), path(:, 2),'whiteo',...
                'LineWidth',1,...
                'MarkerSize',round(360/ map_size),...
                'MarkerEdgeColor',[rand_r, rand_g, rand_b],...
                'MarkerFaceColor',[rand_r, rand_g, rand_b]); 
                
        end
        function cost = COST(obj, A, B)
            cost = + min(abs(A(1) - B(1)), abs(A(2) - B(2))) * 0.41 + ...
                    max(abs(A(1) - B(1)), abs(A(2) - B(2))) * 1;
        end

    end
end
