classdef A_star
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = A_star_path(obj, map, start, goal, map_size)
            hold on;
            map(round(start(1)), round(start(2))) = 2;
            
            for x = 1: 1: map_size
                for y = 1: 1: map_size
                    if map(x, y, 1) == 1 
                        q.g_cost = 1000;
                        q.h_cost = 1000;
                        q.f_cost = 1000;
                        q.parent = [];
                        q.state = 1;
                        q.data = [x - 0.5, y - 0.5];
                    else
                        q.g_cost = 1000;
                        q.h_cost = 1000;
                        q.f_cost = 1000;
                        q.parent = [];
                        q.state = 0;
                        q.data = [x - 0.5, y - 0.5];
                    end
                    valid_map(x, y) = q;
                end
            end
            
            CLOSED = [];
            
            CURRENT.data = start;
            CURRENT.g_cost = 0;
            CURRENT.h_cost = obj.COST(start, goal);
            CURRENT.f_cost = CURRENT.g_cost + CURRENT.h_cost;
            CURRENT.parent = [];
            CURRENT.state = 2;
            
            valid_map(start(1) + 0.5, start(2) + 0.5) = CURRENT;
            
            while (CURRENT.data(1) ~= goal(1) || CURRENT.data(2) ~= goal(2))
                min_f_cost = 100000;
                
                check = 0;
                for x = 1: 1: map_size
                    for y = 1: 1: map_size
                        if valid_map(x, y).state == 2 && valid_map(x, y).f_cost <= min_f_cost
                            min_f_cost = valid_map(x, y).f_cost;
                            CURRENT = valid_map(x, y);
                            check = 1;
                            disp(valid_map(x, y));
                        end
                    end
                end
                disp('-----------------');
                
                if check == 0
                    break;
                end
            
            %{
            % plot CURRENT (unnecessary)
                if (CURRENT.data(1) ~= start(1) || CURRENT.data(2) ~= start(2)) &&...
                        (CURRENT.data(1) ~= goal(1) || CURRENT.data(2) ~= goal(2))
                    plot(CURRENT.data(1), CURRENT.data(2),'whiteo',...
                        'LineWidth',1,...
                        'MarkerSize',round(300/ map_size),...
                        'MarkerEdgeColor',[0.9, 1, 0.9],...
                        'MarkerFaceColor',[0.9, 1, 0.9]);
                end
            %}

            % remove CURRENT.data from OPEN set add CURRENT.data to CLOSED set
                valid_map(CURRENT.data(1) + 0.5, CURRENT.data(2) + 0.5).state = 3;
                CLOSED = [CLOSED; CURRENT];

            % define neighbor and for each neighbor
                for neighbor_x = CURRENT.data(1)-1: 1: CURRENT.data(1)+1
                    for neighbor_y = CURRENT.data(2)-1: 1: CURRENT.data(2)+1
                        
                    % condition for array index
                        if (neighbor_x > 0) && (neighbor_y > 0)
                            if (neighbor_x ~= CURRENT.data(1) || neighbor_y ~= CURRENT.data(2))...
                                    && check_valid(obj, map, CURRENT.data) == 1
                                
                                this_neighbor.data = [neighbor_x, neighbor_y];
                                
                                plot(neighbor_x, neighbor_y,'whiteo',...
                                    'LineWidth',1,...
                                    'MarkerSize',round(300/ map_size),...
                                    'MarkerEdgeColor',[0.9, 1, 0.9],...
                                    'MarkerFaceColor',[0.9, 1, 0.9]);
                            % if neighbor is CLOSED
                                if (valid_map(round(neighbor_x), round(neighbor_y)).state == 3)
                                    continue;
                                end
                                
                                neighbor_new_g_cost = obj.COST(this_neighbor.data, CURRENT.data) + ...
                                                      CURRENT.g_cost;
                                if valid_map(neighbor_x + 0.5, neighbor_y + 0.5).g_cost > neighbor_new_g_cost
                                    this_neighbor.g_cost = neighbor_new_g_cost;
                                    this_neighbor.h_cost = obj.COST(this_neighbor.data, goal);
                                    this_neighbor.f_cost = this_neighbor.g_cost + this_neighbor.h_cost;
                                    this_neighbor.parent = CURRENT;
                                    this_neighbor.state = 2;
                                    valid_map(neighbor_x + 0.5, neighbor_y + 0.5) = this_neighbor;
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
        
        function check = check_q_new_valid(obj, set, point, cost)
            check = 1;
            for index = 1: 1: length(set)
                if set(index).data == point.data
                    if set(index).g_cost <= cost
                        check = 0;
                        return;
                    end
                    set(index) = [];
                    return;
                end
            end
            return;
        end
    end
end
