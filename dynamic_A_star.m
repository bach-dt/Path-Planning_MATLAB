classdef dynamic_A_star
    methods 
        % 2: OPEN set
        % 3: CLOSED set
        function [] = repeat_dynamic_A_star(obj, map, start, goal, obstacle, map_size)
            clc;
            global path;
            global last_map;
            global map_size;
            
            plot(path(:, 1), path(:, 2), 'y-s');
            
        % update last_map
            if map(obstacle(1) + 0.5, obstacle(2) + 0.5) == 1
                last_map(obstacle(1) + 0.5, obstacle(2) + 0.5).obs = 1;
            else
                last_map(obstacle(1) + 0.5, obstacle(2) + 0.5).obs = 0;
            end
            
            for x = round(obstacle(1)) - 2: 1: round(obstacle(1)) + 2
                for y = round(obstacle(2)) - 2: 1: round(obstacle(2)) + 2
                    last_map(x, y).state = 2;
                end
            end

            disp('*******************************************');
            disp(last_map(obstacle(1) + 0.5, obstacle(2) + 0.5));
            disp('*******************************************');
        
        % old path
            old_path = [];
            for index = 1: 1: length(path) - 2
                old_path = [old_path; path(index, :)];
                if obj.check_valid(last_map, [path(index + 2, 1) + 0.5, path(index + 2, 2) + 0.5]) == 0
                    break;
                end
            end    
        % process with new_map
            obj.process(last_map, path(index, :), goal, map_size, old_path);            
        end
        
        function [] = dynamic_A_star_path(obj, map, start, goal, map_size)
            hold on;  
            
            for x = 1: 1: map_size
                for y = 1: 1: map_size
                    if map(x, y, 1) == 1 
                        q.h = 1000;
                        q.k = 1000;
                        q.parent = [];
                        q.state = 0;
                        q.data = [x - 0.5, y - 0.5];
                        q.obs = 1;
                    else
                        q.h = 1000;
                        q.k = 1000;
                        q.parent = [];
                        q.state = 0;
                        q.data = [x - 0.5, y - 0.5];
                        q.obs = 0;
                    end
                    valid_map(x, y) = q;
                end
            end
            q_goal.h = 0;
            q_goal.k = 0;
            q_goal.parent = [];
            q_goal.data = [goal(1), goal(2)];
            q_goal.state = 2;
            q_goal.obs = 0;
            valid_map(goal(1) + 0.5, goal(2) + 0.5) = q_goal;
            
            obj.process(valid_map, start, goal, map_size, []);
        end
        
        function process(obj, valid_map, start, goal, map_size, old_path)
            global last_map;
            global path;
            while 1
                k_min = 100000;
                check = 0;
                for x = 1: 1: map_size
                    for y = 1: 1: map_size
                        if valid_map(x, y).state == 2 && valid_map(x, y).k <= k_min
                            k_min = valid_map(x, y).k;
                            X = valid_map(x, y);
                            check = 1;
                        end
                    end
                end
                disp('-----------------');
                disp(X);
                try
                    disp(X.parent.data);
                end
                
                if check == 0
                    break;
                end
                    
                k_old = X.k;
                valid_map(X.data(1) + 0.5, X.data(2) + 0.5).state = 3;

                if k_old < X.h
                    for neighbor_x = X.data(1)-1: 1: X.data(1)+1
                        for neighbor_y = X.data(2)-1: 1: X.data(2)+1
                            if (neighbor_x > 0) && (neighbor_y > 0) && ...
                               (neighbor_x <= map_size) && (neighbor_y <= map_size) && ...
                               (neighbor_x ~= X.data(1) || neighbor_y ~= X.data(2))
                           
                                Y = valid_map(neighbor_x + 0.5, neighbor_y + 0.5);
                                disp(Y);
                                if Y.state ~= 0 && X.h > Y.h + obj.COST(valid_map, X, Y) && ~obj.COMPARE(Y.parent, X)
                                    valid_map(X.data(1) + 0.5, X.data(2) + 0.5) = obj.re_valid(X, Y, Y.h + obj.COST(valid_map, X, Y));
                                    X = valid_map(X.data(1) + 0.5, X.data(2) + 0.5);
                                    if X.obs ~= 1
                                        plot(X.data(1), X.data(2),'whiteo',...
                                            'LineWidth',1,...
                                            'MarkerSize',round(300/ map_size),...
                                            'MarkerEdgeColor',[1, 1, 1],...
                                            'MarkerFaceColor',[1, 1, 1]);
                                        if (X.parent.data(1) == X.data(1) && X.parent.data(2) == X.data(2) + 1)
                                            plot(X.data(1), X.data(2), 'g^');
                                        elseif (X.parent.data(1) == X.data(1) && X.parent.data(2) == X.data(2) - 1)
                                            plot(X.data(1), X.data(2), 'gv');
                                        elseif (X.parent.data(1) + 1 == X.data(1) && X.parent.data(2) == X.data(2) + 1)
                                            plot(X.data(1), X.data(2), 'gx');
                                        elseif (X.parent.data(1) - 1 == X.data(1) && X.parent.data(2) == X.data(2) + 1)
                                            plot(X.data(1), X.data(2), 'gx');
                                        elseif (X.parent.data(1) + 1 == X.data(1) && X.parent.data(2) == X.data(2) - 1)
                                            plot(X.data(1), X.data(2), 'gx');
                                        elseif (X.parent.data(1) - 1 == X.data(1) && X.parent.data(2) == X.data(2) - 1)
                                            plot(X.data(1), X.data(2), 'gx');
                                        elseif (X.parent.data(1) + 1 == X.data(1) && X.parent.data(2) == X.data(2))
                                            plot(X.data(1), X.data(2), 'g<');
                                        elseif (X.parent.data(1) - 1 == X.data(1) && X.parent.data(2) == X.data(2))
                                            plot(X.data(1), X.data(2), 'g>');
                                        end
                                    end
                                end
                                if (obj.COMPARE(Y.parent, X) && Y.h ~= X.h + obj.COST(valid_map, X, Y))...
                                    || (~obj.COMPARE(Y.parent, X) && Y.h > X.h + obj.COST(valid_map, X, Y))
                                    valid_map(Y.data(1) + 0.5, Y.data(2) + 0.5) = obj.re_valid(Y, X, X.h + obj.COST(valid_map, X, Y));
                                    Y = valid_map(Y.data(1) + 0.5, Y.data(2) + 0.5);
                                    disp(Y);
                                    if Y.obs ~= 1
                                        plot(Y.data(1), Y.data(2),'whiteo',...
                                            'LineWidth',1,...
                                            'MarkerSize',round(300/ map_size),...
                                            'MarkerEdgeColor',[1, 1, 1],...
                                            'MarkerFaceColor',[1, 1, 1]);
                                        if (Y.parent.data(1) == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'g^');
                                        elseif (Y.parent.data(1) == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gv');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2))
                                            plot(Y.data(1), Y.data(2), 'g<');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2))
                                            plot(Y.data(1), Y.data(2), 'g>');
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if k_old == X.h
                    for neighbor_x = X.data(1)-1: 1: X.data(1)+1
                        for neighbor_y = X.data(2)-1: 1: X.data(2)+1
                            if (neighbor_x > 0) && (neighbor_y > 0) && ...
                               (neighbor_x <= map_size) && (neighbor_y <= map_size) && ...
                               (neighbor_x ~= X.data(1) || neighbor_y ~= X.data(2))
                           
                                Y = valid_map(neighbor_x + 0.5, neighbor_y + 0.5);
                                
                                
                                if Y.state == 0 || (obj.COMPARE(Y.parent, X) && Y.h ~= X.h + obj.COST(valid_map, X, Y)) ...
                                                || (~obj.COMPARE(Y.parent, X) && Y.h > X.h + obj.COST(valid_map, X, Y))
                                    valid_map(Y.data(1) + 0.5, Y.data(2) + 0.5) = obj.re_valid(Y, X, X.h + obj.COST(valid_map, X, Y));
                                    %{
                                    plot(neighbor_x, neighbor_y,'whiteo',...
                                        'LineWidth',1,...
                                        'MarkerSize',round(300/ map_size),...
                                        'MarkerEdgeColor',[0.9, 1, 0.9],...
                                        'MarkerFaceColor',[0.9, 1, 0.9]);
                                    %}
                                    Y = valid_map(neighbor_x + 0.5, neighbor_y + 0.5);
                                    disp(Y);
                                    if Y.obs ~= 1
                                        plot(Y.data(1), Y.data(2),'whiteo',...
                                            'LineWidth',1,...
                                            'MarkerSize',round(300/ map_size),...
                                            'MarkerEdgeColor',[1, 1, 1],...
                                            'MarkerFaceColor',[1, 1, 1]);
                                        if (Y.parent.data(1) == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'g^');
                                        elseif (Y.parent.data(1) == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gv');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) + 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2) - 1)
                                            plot(Y.data(1), Y.data(2), 'gx');
                                        elseif (Y.parent.data(1) + 1 == Y.data(1) && Y.parent.data(2) == Y.data(2))
                                            plot(Y.data(1), Y.data(2), 'g<');
                                        elseif (Y.parent.data(1) - 1 == Y.data(1) && Y.parent.data(2) == Y.data(2))
                                            plot(Y.data(1), Y.data(2), 'g>');
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            point = start;
            path = [old_path; point];
            while (point(1) ~= goal(1) || point(2) ~= goal(2))
                point = valid_map(point(1) + 0.5, point(2) + 0.5).parent.data;
                path = [path; point];
            end
            disp(path);
            disp('---------------------------');
            disp(valid_map(6, 5).parent);
            plot(path(:, 1), path(:, 2), 'b-s');
            last_map = valid_map;
        end
        
        function cost = COST(obj, map, X, Y)
            global map_size;
            for x = max(1, round(Y.data(1)) - 1): 1: min(map_size, round(Y.data(1)) + 1)
                for y = max(1, round(Y.data(2)) - 1): 1: min(map_size, round(Y.data(2)) + 1)
                    if map(x, y).obs == 1
                        cost = 100000;
                        return;
                    end
                end
            end
            for x = round(X.data(1)) - 1: 1: round(X.data(1)) + 1
                for y = round(X.data(2)) - 1: 1: round(X.data(2)) + 1
                    if map(x, y).obs == 1 
                        cost = 100000;
                        return;
                    end
                end
            end
            %{
            if map(X.data(1) + 0.5, X.data(2) + 0.5).obs == 1 ||...
                    map(Y.data(1) + 0.5, Y.data(2) + 0.5).obs == 1
                cost = 100000;
                return;
            end
            %}
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
        function check = check_valid(obj, map, point)
            global map_size;
            check = 1;
            for x = max(1, point(1) - 1): 1: min(map_size, point(1) + 1)
                for y = max(1, point(2) - 1): 1: min(map_size, point(2) + 1)
                    if map(x, y).obs == 1
                        check = 0;
                        return;
                    end
                end
            end
        end
    end
end
