classdef A_star
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = A_star_path(obj, map, start, goal, map_size)
            hold on;
            map(round(start(1)), round(start(2))) = 2;
            CLOSED = [];
            CURRENT.data = start;
            CURRENT.g_cost = 0;
            CURRENT.h_cost = obj.COST(start, goal);
            CURRENT.f_cost = CURRENT.g_cost + CURRENT.h_cost;
            CURRENT.parent = [];
            OPEN = [];
            OPEN = [OPEN, CURRENT];
            
            G_COST_MAP = zeros(map_size, map_size, 1);
            G_COST_MAP(round(start(1)), round(start(2)), 1) = 0;
            
            while (CURRENT.data(1) ~= goal(1) || CURRENT.data(2) ~= goal(2))
                min_f_cost = map_size * 2;
                CURRENT_index = 0;
                for index = 1: 1: length(OPEN)
                    if OPEN(index).f_cost < min_f_cost
                        min_f_cost = OPEN(index).f_cost;
                        CURRENT = OPEN(index);
                        CURRENT_index = index;
                    end
                end
                
            % plot CURRENT (unnecessary)
                if (CURRENT.data(1) ~= start(1) || CURRENT.data(2) ~= start(2)) &&...
                        (CURRENT.data(1) ~= goal(1) || CURRENT.data(2) ~= goal(2))
                    plot(CURRENT.data(1), CURRENT.data(2),'whiteo',...
                        'LineWidth',1,...
                        'MarkerSize',round(300/ map_size),...
                        'MarkerEdgeColor',[0.9, 1, 0.9],...
                        'MarkerFaceColor',[0.9, 1, 0.9]);
                end

            % remove CURRENT.data from OPEN set
                OPEN(CURRENT_index) = [];
                    
            % add CURRENT.data to CLOSED set
                CLOSED = [CLOSED; CURRENT];
                map(round(CURRENT.data(1)), round(CURRENT.data(2))) = 3; 

            % define neighbor and for each neighbor
                for neighbor_x = CURRENT.data(1)-1: 1: CURRENT.data(1)+1
                    for neighbor_y = CURRENT.data(2)-1: 1: CURRENT.data(2)+1
                        
                    % condition for array index
                        if (neighbor_x > 0) && (neighbor_y > 0)
                            if (neighbor_x ~= CURRENT.data(1) || neighbor_y ~= CURRENT.data(2))...
                                    && check_valid(obj, map, CURRENT.data) == 1
                                
                                this_neighbor.data = [neighbor_x, neighbor_y];
                                
                            % if neighbor is CLOSED
                                if (map(round(neighbor_x), round(neighbor_y)) == 3)
                                    continue;
                                end
                                
                                neighbor_new_g_cost = obj.COST(this_neighbor.data, CURRENT.data) + ...
                                                      CURRENT.g_cost;

                                if G_COST_MAP(this_neighbor.data(1) + 0.5, this_neighbor.data(2) + 0.5, 1) == 0 ||...
                                        neighbor_new_g_cost < G_COST_MAP(this_neighbor.data(1) + 0.5, this_neighbor.data(2) + 0.5, 1)
                                    this_neighbor.g_cost = neighbor_new_g_cost;
                                    this_neighbor.h_cost = obj.COST(this_neighbor.data, goal);
                                    this_neighbor.f_cost = this_neighbor.g_cost + this_neighbor.h_cost;
                                    this_neighbor.parent = CURRENT;
                                    if map(round(this_neighbor.data(1)), round(this_neighbor.data(2))) ~= 2
                                        G_COST_MAP(this_neighbor.data(1) + 0.5, this_neighbor.data(2) + 0.5, 1) = neighbor_new_g_cost;
                                        map(round(this_neighbor.data(1)), round(this_neighbor.data(2))) = 2;
                                        OPEN = [OPEN, this_neighbor];
                                    end
                                end

                            end
                        end
                    end
                end
            end
            
        % print path
            path = [goal];
            point = CURRENT;
            while (point.data(1) ~= start(1) || point.data(2) ~= start(2))
                point = point.parent;
                path = [path; point.data];
            end
            path = [path; start];
            
            path(length(path), :) = [];
            rand_r = rand(1) / 2 + 0.5;
            rand_g = rand(1) / 2 + 0.5;
            rand_b = rand(1) / 2 + 0.5;
            plot(path(:, 1), path(:, 2), 'b-s');
                
        end
        function cost = COST(obj, A, B)
            cost = + min(abs(A(1) - B(1)), abs(A(2) - B(2))) * 0.41 + ...
                    max(abs(A(1) - B(1)), abs(A(2) - B(2))) * 1;
        end
        function check = check_valid(obj, map, point)
            check = 1;
            for x = round(point(1)) - 1: 1: round(point(1)) + 1
                for y = round(point(2)) - 1: 1: round(point(2)) + 1
                    if (x > 0 && y > 0)
                        if map(x, y) == 1
                            check = 0;
                            return;
                        end
                    end
                end
            end           
        end
    end
end
