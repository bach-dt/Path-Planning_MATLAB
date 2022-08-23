classdef dynamic_RRT_star
    properties
        % nothing  :)
    end
    methods 
        function repeat_dynamic_RRT_star(obj, map, goal, map_size)
            hold on;
            global path;
            global radiusK;
            met_obs = 0;
            
            plot(path(:, 1), path(:, 2),'y-*'); 
            
            for index = 1: 1: length(path)
                if obj.check_valid(map, radiusK, path(index, :)) == 0
                    obs_index = index;
                    met_obs = 1;
                end
            end
            if (met_obs == 1)
                old_path = path(obs_index + 2 : length(path), :);
                obj.dynamic_RRT_star_path(map, path(obs_index + 1, :), goal, map_size, old_path);
            end
            
        end
        
        function path = dynamic_RRT_star_path(obj, map, start, goal, map_size, old_path)
            global radiusK;
            global path;
            hold on;
            
        % define dimension
            max_dms = 5;
            
            q_start.data = start;
            q_start.next = [];
            q_start.prev = [];
            q_start.cost = 0;
            ExploredSet = [];
            ExploredSet = [ExploredSet, q_start];
            q_new = q_start;
            
        % define node_number
            node_number = 2;
        % define planning constant
            gamma = 15;
            
            while (obj.COST(q_new.data, goal) > max_dms)
                q_target = [rand(1) * map_size, rand(1) * map_size];
                min_cost = 100000;
                q_nearest = [];
                
            % calculate radiusK
                radiusK = gamma*((log(node_number) / node_number)^(1/max_dms)); 
                
                disp(radiusK);
                disp(node_number);
                
                for index = 1: 1: length(ExploredSet)
                    if obj.COST(ExploredSet(index).data, q_target) < min_cost
                        q_nearest = ExploredSet(index);
                        min_cost = obj.COST(q_nearest.data, q_target);
                    end
                end
                q_new_x = q_nearest.data(1) + obj.COST_X(q_nearest.data, q_target) ...
                            * max_dms / obj.COST(q_nearest.data, q_target);
                q_new_y = q_nearest.data(2) + obj.COST_Y(q_nearest.data, q_target) ...
                            * max_dms / obj.COST(q_nearest.data, q_target);
                
                if (q_new_x > 1 && q_new_x < map_size && q_new_y > 1 && q_new_y < map_size)
                    if (obj.check_valid(map, radiusK, [q_new_x, q_new_y]) == 1)
                        
                        node_number = node_number + 1;
                        
                        q_new.data = [q_new_x, q_new_y];
                        q_new.next = [];
                        
                        min_cost = 100000;
                        for index = 1: 1: length(ExploredSet)
                            if obj.COST(ExploredSet(index).data, q_new.data) < radiusK && ...
                               obj.COST(ExploredSet(index).data, q_new.data) + ...
                                           ExploredSet(index).cost < min_cost
                            
                                q_nearest = ExploredSet(index);
                                min_cost = obj.COST(ExploredSet(index).data, q_new.data) + ...
                                           ExploredSet(index).cost;
                            end
                        end
                    % define parent
                        q_new.prev = q_nearest;
                        q_new.cost = obj.COST(q_nearest.data, q_new.data) + q_nearest.cost;
                        
                        ExploredSet = [ExploredSet, q_new];
                        plot([q_new_x, q_nearest.data(1)], [q_new_y, q_nearest.data(2)], 'c-*');
                    end
                end
            end
            point = q_new;
            path= [goal];
            disp('cost');
            while (point.data(1) ~= start(1)) || (point.data(2) ~= start(2))
                path = [path; point.data];
                disp(obj.COST(point.data, point.prev.data));
                point = point.prev;
            end
            path = [path; start; old_path];
            plot(path(:, 1), path(:, 2),'k-*');
        % disp path
            disp(path);
            
        end
        function cost = COST(obj, A, B)
            dis_x = A(1) - B(1);
            dis_y = A(2) - B(2);
            cost = sqrt(dis_x * dis_x + dis_y * dis_y);
        end
        function cost_x = COST_X(obj, A, B)
            cost_x = B(1) - A(1);
        end
        function cost_y = COST_Y(obj, A, B)
            cost_y = B(2) - A(2);
        end
        function check = check_valid(obj, map, radiusK, point)
            check = 1;
            for x = round(point(1)) - round(radiusK / 2): 1: round(point(1)) + round(radiusK / 2)
                for y = round(point(2)) - round(radiusK / 2): 1: round(point(2)) + round(radiusK / 2)
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