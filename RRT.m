classdef RRT
    methods 
        function [] = RRT_path(obj, map, start, goal, map_size)
            hold on;
            max_dms = 3;
            q_start.data = start;
            q_start.next = [];
            q_start.prev = [];
            ExploredSet = [];
            ExploredSet = [ExploredSet, q_start];
            q_new = q_start;
            while (obj.COST(q_new.data, goal) > max_dms)
                q_target_data = [rand(1) * map_size, rand(1) * map_size];
                min_cost = map_size * 1.41;
                q_nearest = [];
                for index = 1: 1: length(ExploredSet)
                    if obj.COST(ExploredSet(index).data, q_target_data) < min_cost
                        q_nearest = ExploredSet(index);
                        min_cost = obj.COST(q_nearest.data, q_target_data);
                    end
                end
                q_new_x = q_nearest.data(1) + obj.COST_X(q_nearest.data, q_target_data) ...
                            * max_dms / obj.COST(q_nearest.data, q_target_data);
                q_new_y = q_nearest.data(2) + obj.COST_Y(q_nearest.data, q_target_data) ...
                            * max_dms / obj.COST(q_nearest.data, q_target_data);
                q_new.data = [q_new_x, q_new_y];
                
                % plot([q_target(1), q_nearest(1)], [q_target(2), q_nearest(2)], 'r--o');
                
                %{ 
                disp('Set');
                disp(ExploredSet);
                disp('q_target');
                disp(q_target);
                disp('q_nearest');
                disp(q_nearest);
                disp('q_new');
                disp(q_new);
                %}
                if (q_new_x > 1 && q_new_x < map_size && q_new_y > 1 && q_new_y < map_size)
                    check_obs = 0;
                    for d = 1: 0.5: max_dms
                        q_ck_obs_x = q_nearest.data(1) + obj.COST_X(q_nearest.data, q_target_data) ...
                            * d / obj.COST(q_nearest.data, q_target_data);
                        q_ck_obs_y = q_nearest.data(2) + obj.COST_Y(q_nearest.data, q_target_data) ...
                            * d / obj.COST(q_nearest.data, q_target_data);
                        if (map(round(q_ck_obs_x), round(q_ck_obs_y)) ~= 0 ||...
                            map(round(q_ck_obs_x + 0.5), round(q_ck_obs_y)) ~= 0 ||...
                            map(round(q_ck_obs_x), round(q_ck_obs_y + 0.5)) ~= 0 ||...
                            map(round(q_ck_obs_x + 0.5), round(q_ck_obs_y + 0.5)) ~= 0 ||...
                            map(round(q_ck_obs_x), round(q_ck_obs_y)) ~= 0 ||...
                            map(round(q_ck_obs_x - 0.5), round(q_ck_obs_y)) ~= 0 ||...
                            map(round(q_ck_obs_x), round(q_ck_obs_y - 0.5)) ~= 0 ||...
                            map(round(q_ck_obs_x - 0.5), round(q_ck_obs_y - 0.5)) ~= 0)
                            check_obs = 1;
                        end
                    end
                        
                    if (check_obs == 0)
                        q_new.next = [];
                        q_new.prev = q_nearest;
                        ExploredSet = [ExploredSet, q_new];
                        plot([q_new_x, q_nearest.data(1)], [q_new_y, q_nearest.data(2)], 'g-o');
                    end
                end
            end
            point = q_new;
            path= [goal];
            while (point.data(1) ~= start(1)) || (point.data(2) ~= start(2))
                point = point.prev;
                path = [path; point.data];
            end
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
    end
end
