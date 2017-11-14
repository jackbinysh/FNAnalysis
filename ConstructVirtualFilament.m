function [ VirtualFilament ] = ConstructVirtualFilament(listofcurves,windowsize)
    % a function which takes a curve, and a window a curves taken at
    % neighboring time points, and from the trajectories of the points
    % constructs a smoothed "virtual filament" for the original curve.
    % the list of curves shoud have the structure xxx ... xxC MIDDLE xx...xxx, where 
    % C is the curve of interest - i.e EVEN length and curve one behind the
    % "middle"

    traj = [];

    % first of all, construct the trajectory data.
    curve = listofcurves{(windowsize)/2};

    % do the ones ahead of the current curve
    oldpoints = curve;
    for index = ((windowsize)/2):1:windowsize
        points = listofcurves{index};  
        
        closestapproach = MatchPoints(oldpoints,points);

        traj = [traj {closestapproach}];
        oldpoints=closestapproach;
    end

    % now do the ones behind
    oldpoints = curve;
    for index = ((windowsize/2)-1):-1:1

        points = listofcurves{index} ; 
        closestapproach = MatchPoints(oldpoints,points);
        traj = [ {closestapproach} traj];
        oldpoints=closestapproach;
    end
    
    %reshape this array a little so each cell is a trajectory, not the
    %curve.
    trajectories = {};
    for i = 1:length(traj{1})
        trajectory = [];
        for j = 1:length(traj)
            points = traj{j}(i,:);
            trajectory = [trajectory; points];
        end
        trajectories{i} = trajectory;
    end
  
    % okay now we have the trajectories as a list of cells. Lets do the
    % smoothing
    
    % grab each trajectory, and smooth it using a filter
    
    filteredtrajectories = trajectories;
    for trajindex = 1:length(trajectories)
        for q = 1:3
                 
            data = trajectories{trajindex}(:,q);
            n = 50;
            Wn = 0.01;
            b = fir1(n,Wn,kaiser(n+1,9) );
            output = filter(b,1,data);
            filteredtrajectories{trajindex}(:,q) = output;            
            
        end
    end
    
% finally, grab the middle filament
    VirtualFilament = zeros(length(filteredtrajectories),3);
    for i = 1:length(filteredtrajectories)
        VirtualFilament(i,:) = filteredtrajectories{i}((windowsize)/2,:);
    end
    
end