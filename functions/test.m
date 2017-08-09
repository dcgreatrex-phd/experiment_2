function angle = test(DU, mean_thresh, sd)

	sinesound = {};
leftout = 0; rightout = 0; inner = 0;
for i = 1:length(DU); 

    dir = randi(2,1); % randomly select side of central fixation - 1 = left side 2 = right side
    seg = randi(2,1); % randomly select outer or inner segment - 1 = outer 2 = inner

    % raise flag when an area segment has been selected
    if dir == 1 && seg == 1 && leftout == 0; % left outer
        leftout = 1;
    elseif dir == 2 && seg == 1 && rightout == 0; % right outer
        rightout = 1;
    elseif dir == 1 && seg == 2 && inner == 0; % inner (either left or right inner segments)
        inner = 1;
    end

    % stop tones being assigned to more than two of the horizontal segments in one trial
    disp('START\n');
    disp('------------------------------\n');
    disp(strcat('DU value :', num2str(DU(i))));
    disp(strcat('direction :', num2str(dir)));
    disp(strcat('segment :', num2str(seg)));
    disp('------------------------------\n');
    disp(strcat('leftouter flag :', num2str(leftout)));
    disp(strcat('rightouter flag :', num2str(rightout)));
    disp(strcat('inner flag :', num2str(inner)));

    if DU(i) >= 0 && leftout == 1 && rightout == 1
        if seg == 2;
            seg = 1;
        end
    elseif DU(i) >= 0 && leftout == 1 && inner == 1
        if dir == 2 && seg == 1
            dir = 1;
        end
    elseif DU(i) >= 0 && rightout == 1 && inner == 1
        if dir == 1 && seg == 1
            dir = 2;
        end
    end

    disp('--------------------------------\n');
    disp(strcat('new direction :', num2str(dir)));
    disp(strcat('new segment :', num2str(seg)));
    disp('--------------------------------\n');
    disp('END\n');
    disp('--------------------------------\n');

    % calcualate angles associated with DU values
    if dir == 1 % sound on left side of head
        if seg == 1 % outer segment
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = (67.5 + a_change)*-1;

        else % inner segment                
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = (22.5 - a_change)*-1;

        end

    else % sound on right side of head
        if seg == 1 % outer segment  
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = 67.5 + a_change;

        else % inner segment       
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = 22.5 - a_change;

        end
    end 
end   