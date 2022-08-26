classdef dynamic_A_star
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = repeat_dynamic_A_star(obj, map, start, goal, obstacle, map_size)
            global path;
            global last_map;
            last_map(obstacle(1) + 0.5, obstacle(2) + 0.5).state = 1;
            
            q = path(1);
            old_path = [];
            while last_map(q.data(1) + 0.5, q.data(2) + 0.5).state ~=  1
                old_path = [old_path, q];
                q = q.parent;
            end
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        end
        function [] = dynamic_A_star_path(obj, map, start, goal, map_size)
            hold on;
            global path;
            global last_map;    
            for x = 1: 1: map_size
                for y = 1: 1: map_size
                    if map(x, y, 1) == 1 
                        q.h = 1000;
                        q.k = 1000;
                        q.parent = [];
                        q.state = 1;
                        q.data = [x - 0.5, y - 0.5];
                    else
                        q.h = 1000;
                        q.k = 1000;
                        q.parent = [];
                        q.state = 0;
                        q.data = [x - 0.5, y - 0.5];
                    end
                    valid_map(x, y) = q;
                end
            end
            q_goal.h = 0;
            q_goal.k = 0;
            q_goal.parent = [];
            q_goal.data = [goal(1), goal(2)];
            q_goal.state = 2;
            valid_map(goal(1) + 0.5, goal(2) + 0.5) = q_goal;
            
            X = q_goal;
            while X.data(1) ~= start(1)|| X.data(2) ~= start(2)
                h_min = 100000;
                check = 0;
                for x = 1: 1: map_size
                    for y = 1: 1: map_size
                        if valid_map(x, y).state == 2 && valid_map(x, y).h <= h_min
                            h_min = valid_map(x, y).h;
                            X = valid_map(x, y);
                            check = 1;
                            disp(valid_map(x, y));
                        end
                    end
                end
                disp('-----------------');
                
                if check == 0
                    break;
                end
                    
                k_old = X.k;
                valid_map(X.data(1) + 0.5, X.data(2) + 0.5).state = 3;

                if k_old < X.h
                    for neighbor_x = X.data(1)-1: 1: X.data(1)+1
                        for neighbor_y = X.data(2)-1: 1: X.data(2)+1
                            if (neighbor_x > 0) && (neighbor_y > 0)
                                Y = valid_map(neighbor_x + 0.5, neighbor_y + 0.5);
                                if Y.state == 0 && Y.h <= k_old && X.h > Y.h + obj.COST(valid_map, X, Y)
                                    X.parent = Y;
                                    X.h = Y.h + obj.COST(X, Y);
                                end
                            end
                        end
                    end
                end
                if k_old == X.h
                    for neighbor_x = X.data(1)-1: 1: X.data(1)+1
                        for neighbor_y = X.data(2)-1: 1: X.data(2)+1
                            if (neighbor_x > 0) && (neighbor_y > 0) && (neighbor_x ~= X.data(1) || neighbor_y ~= X.data(2))
                                Y = valid_map(neighbor_x + 0.5, neighbor_y + 0.5);
                                if Y.state == 0 || (obj.COMPARE(Y.parent, X) && Y.h ~= X.h + obj.COST(valid_map, X, Y)) ...
                                                || (~obj.COMPARE(Y.parent, X) && Y.h > X.h + obj.COST(valid_map, X, Y))
                                    valid_map(Y.data(1) + 0.5, Y.data(2) + 0.5) = obj.re_valid(Y, X, X.h + obj.COST(valid_map, X, Y));
                                    plot(neighbor_x, neighbor_y,'whiteo',...
                                        'LineWidth',1,...
                                        'MarkerSize',round(300/ map_size),...
                                        'MarkerEdgeColor',[0.9, 1, 0.9],...
                                        'MarkerFaceColor',[0.9, 1, 0.9]);
                                end
                            end
                        end
                    end
                end
            end
            
            path = [start];
            point = X;
            
            while (point.data(1) ~= goal(1) || point.data(2) ~= goal(2))
                point = point.parent;
                path = [path; point.data];
            end
            path = [path; goal];
            path(length(path), :) = [];
            plot(path(:, 1), path(:, 2), 'm-p');
            
            last_map = valid_map;
        end
        function cost = COST(obj, map, X, Y)
            for x = round(Y.data(1)) - 1: 1: round(Y.data(1)) + 1
                for y = round(Y.data(2)) - 1: 1: round(Y.data(2)) + 1
                    if map(x, y).state == 1
                        cost = 100000;
                        return;
                    end
                end
            end
            for x = round(X.data(1)) - 1: 1: round(X.data(1)) + 1
                for y = round(X.data(2)) - 1: 1: round(X.data(2)) + 1
                    if map(x, y).state == 1 
                        cost = 100000;
                        return;
                    end
                end
            end
            if X.data(1) == Y.data(1) || X.data(2) == Y.data(2)
                cost = 1;
                return;
            else 
                cost = 1.4;
                return;
            end
        end
        function v = re_valid(obj, X, parent, h_new)
            if X.k > h_new
                X.k = h_new;
            end
            X.h = h_new;
            X.parent = parent;
            X.state = 2;
            v = X;
        end
        function com = COMPARE(obj, X, Y)
            try
                if (X.data(1) == Y.data(1) && X.data(2) == Y.data(2))
                    com = 1;
                    return
                end
            end
            com = 0;
            return;
        end
    end
end
