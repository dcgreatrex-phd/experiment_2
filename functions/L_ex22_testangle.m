function L_ex22_testangle(DU, angle)
    %%% calculate the four possible angles for each of the DU values and 
    %%% save them in an answer array for every onset. Then compare whether 
    %%% the each angle is a member of these answer arrays.

    for i = 1:length(DU)
        
        % angle of segment 1
        % find mid point of segment
        max1 = -45;
        mid1 = -67.5;
        min1 = -90;
        a = ((min1 - max1)/200)*-1;
        b = (a * DU(i))*100;
        answer(1) = mid1 - b;
        
        % angle of segment 2
        % find mid point of segment
        max1 = -0;
        mid1 = -22.5;
        min1 = -45;
        a = ((min1 - max1)/200);
        b = (a * DU(i))*100;
        answer(2) = mid1 - b;

        % angle of segment 3
        % find mid point of segment
        max1 = 45;
        mid1 = 22.5;
        min1 = 0;
        a = ((min1 - max1)/200)*-1;
        b = (a * DU(i))*100;
        answer(3) = mid1 - b;
        
        % angle of segment 4
        % find mid point of segment
        max1 = 90;
        mid1 = 67.5;
        min1 = 45;
        a = ((min1 - max1)/200);
        b = (a * DU(i))*100;
        answer(4) = mid1 - b;
        
        % round answer to 4 decimal points
        answer = round(answer * 10000) / 10000;
        
        % check if the angle(i) is a member of the answer array. If not
        % throw an error and quit the program
        if ismember(angle(i),answer)
            continue;
        else
            disp('angle is incorrect');
            crash; % inject an error to crash the program;
        end  

    end    
            
end