classdef RRT_connect
    methods 
    % set Ta <- Start
    % set Tb <- Goal
    
    % 1: Reacherd
    % 2: Advanced
    % 0: Trapped
    
    % MAIN FUNCTION
        function [] = RRT_connect_path(obj, map, start, goal, map_size)
            hold on;
            global last_q_target;
            global last_q_new;
            global q_new;
            global Ta;
            global Tb;
            
            origin.data = [0, 0];
            
            q_start.data = start;
            q_start.parent = origin;
            q_start.cost = 0;
            
            q_goal.data = goal;
            q_goal.parent = origin;
            q_goal.cost = 0;
            
            Ta = [q_start];
            Tb = [q_goal];
            
            while 1
                pause(0.05);
                q_target.data = [rand(1) * map_size, rand(1) * map_size];
                if (obj.Extend(q_target, map_size, map) ~= 0)
                    if (obj.Connect(q_new, map_size, map) == 1)
                        break;
                    end
                end
            end
            
            point_chain_A = last_q_new;
            point_chain_B = last_q_target;
            
            chain_A = [];
            chain_B = [];
            
            while (point_chain_A.data(1) ~= 0 && point_chain_A.data(2) ~= 0)
                chain_A = [chain_A; point_chain_A.data];
                point_chain_A = point_chain_A.parent;
            end
            while (point_chain_B.data(1) ~= 0 && point_chain_B.data(2) ~= 0)
                chain_B = [chain_B; point_chain_B.data];
                point_chain_B = point_chain_B.parent;
            end
            
            disp(chain_A);
            plot(chain_A(:, 1), chain_A(:, 2), 'm-^');
            plot(chain_B(:, 1), chain_B(:, 2), 'm-^');
            plot([last_q_new.data(1), last_q_target.data(1)],...
                 [last_q_new.data(2), last_q_target.data(2)], 'm-^');
        end
        
    % EXTEND FUNCTION
        function extend = Extend(obj, q_target, map_size, map)
            
            max_dms = 5;
            
            global last_q_target;
            global last_q_new;
            global Ta;
            global q_new;
            
            extend = 0;
        % find q_nearest
            min_cost = 100000;
            for index = 1: 1: length(Ta)
                if obj.COST(Ta(index).data, q_target.data) < min_cost
                    q_nearest = Ta(index);
                    min_cost = obj.COST(q_nearest.data, q_target.data);
                end
            end
            
        % define & check valid of q_new
            q_new_x = q_nearest.data(1) + obj.COST_X(q_nearest.data, q_target.data) ...
                            * max_dms / obj.COST(q_nearest.data, q_target.data);
            q_new_y = q_nearest.data(2) + obj.COST_Y(q_nearest.data, q_target.data) ...
                        * max_dms / obj.COST(q_nearest.data, q_target.data);
                    
            if (q_new_x > 1 && q_new_x < map_size && q_new_y > 1 && q_new_y < map_size)
            % if q_new is valid
                if (obj.check_valid(map, max_dms, [q_new_x, q_new_y]) == 1)
                    q_new.data = [q_new_x, q_new_y];
                    q_new.parent = q_nearest;
                    q_new.cost = obj.COST(q_nearest.data, q_new.data);
                    Ta = [Ta, q_new];
                    
                    plot([q_new_x, q_nearest.data(1)], [q_new_y, q_nearest.data(2)], 'y-^');
                    
                    
                % reached q_target_data or not
                    if obj.COST(q_new.data, q_target.data) < max_dms
                        last_q_new = q_new;
                        last_q_target = q_target;
                        extend = 1;
                        return
                    else
                        extend = 2;
                        return
                    end
                end
            end
        % if not valid
            extend = 0; 
            return;
        end
        
    % CONNECT FUNCTION
        function connect = Connect(obj, q, map_size, map)
            global Tb;
            global Ta;
            
        % swap Ta, Tb
            T = Ta;
            Ta = Tb;
            Tb = T;
            connect = obj.Extend(q, map_size, map);
            while connect == 2
                connect = obj.Extend(q, map_size, map);
            end
            return;
        end
        
    % IMPLEMENT FUNCTION
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
