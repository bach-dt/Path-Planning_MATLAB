classdef Dijkstra
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = Dijkstra_path(obj, map, start, goal)
            hold on;
                        
            COST_MAP = zeros(29, 29, 5);
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
                min_f_cost = 30 * 1.41;
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
                        if ((neighbor_x ~= CURRENT(1)) || (neighbor_y ~= CURRENT(2)) && (neighbor_x > 0) && (neighbor_y > 0))
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
            
        % print path
            path = [];
            point = CURRENT;
            while (point(1) ~= start(1) || point(2) ~= start(2))
                point = [COST_MAP(round(point(1)), round(point(2)), 4),...
                    COST_MAP(round(point(1)), round(point(2)), 5)]
                path = [path; point];
                disp(point);
            end
            
            path(length(path), :) = [];
            rand_r = rand(1, 1) / 2 + 0.5;
            rand_g = rand(1, 1) / 2 + 0.5;
            rand_b = rand(1, 1) / 2 + 0.5;
            plot(path(:, 1), path(:, 2),'whites',...
                    'LineWidth',1,...
                    'MarkerSize',15,...
                    'MarkerEdgeColor',[rand_r, rand_g, rand_b],...
                    'MarkerFaceColor',[rand_r, rand_g, rand_b]); 
                
        end
        function cost = COST(obj, A, B)
            cost = + min(abs(A(1) - B(1)), abs(A(2) - B(2))) * 0.41 + ...
                    max(abs(A(1) - B(1)), abs(A(2) - B(2))) * 1;
        end

    end
end
