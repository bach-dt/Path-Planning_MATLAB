classdef RRT_connect
    methods 
        function [] = RRT_connect_path(obj, map, start, goal, map_size)
            hold on;
            max_dms = 3;
            
            q_start.data = start;
            q_start.next = [];
            q_start.prev = [];
            
            q_goal.data = goal;
            q_goal.next = [];
            q_goal.prev = [];
            
            ExploredStartSet = [];
            ExploredStartSet = [ExploredStartSet, q_start];
            
            ExploredGoalSet = [];
            ExploredGoalSet = [ExploredGoalSet, q_goal];
            
            q_start_new = q_start;
            q_goal_new = q_goal;
            
            while (obj.COST(q_start_new.data, q_goal_new) > max_dms)
                q_target_data = [rand(1) * map_size, rand(1) * map_size];
                min_cost = map_size * 1.41;
                q_nearest = [];
                for index = 1: 1: length(ExploredStartSet)
                    if obj.COST(ExploredStartSet(index).data, q_target_data) < min_cost
                        q_nearest = ExploredStartSet(index);
                        min_cost = obj.COST(q_nearest.data, q_target_data);
                    end
                end
                q_new_x = q_nearest.data(1) + obj.COST_X(q_nearest.data, q_target_data) ...
                            * max_dms / obj.COST(q_nearest.data, q_target_data);
                q_new_y = q_nearest.data(2) + obj.COST_Y(q_nearest.data, q_target_data) ...
                            * max_dms / obj.COST(q_nearest.data, q_target_data);
                q_start_new.data = [q_new_x, q_new_y];
                
                if (q_new_x > 1 && q_new_x < map_size && q_new_y > 1 && q_new_y < map_size)
                    if (obj.check_valid(map, max_dms, q_start_new.data) == 1)
                        q_start_new.next = [];
                        q_start_new.prev = q_nearest;
                        q_start_new.cost = obj.COST(q_nearest.data, q_start_new.data);
                        ExploredStartSet = [ExploredStartSet, q_start_new];
                        plot([q_new_x, q_nearest.data(1)], [q_new_y, q_nearest.data(2)], 'g-o');
                    else 
                        q_start_new.data = start;
                    end
                end
            end
            point = q_start_new;
            path= [goal];
            disp('cost');
            while (point.data(1) ~= start(1)) || (point.data(2) ~= start(2))
                path = [path; point.data];
                point = point.prev;
            end
            path = [path; start];
            plot(path(:, 1), path(:, 2),'r-o'); 
            
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
        function check = check_valid(obj, map, max_dms, point)
            check = 1;
            for x = round(point(1)) - round(max_dms / 2): 1: round(point(1)) + round(max_dms / 2)
                for y = round(point(2)) - round(max_dms / 2): 1: round(point(2)) + round(max_dms / 2)
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
