function [oldknotplot] = ConstructCurveVelocitySpinRate(oldknotplot,newknotplot, deltaT)

    % a function to take 2 successive (smoothed) curves, fill in the velocity
    % data, and the spin rate for the older one, and return it

    oldpoints = oldknotplot.POINTS;
    NPold = length(oldpoints);
    newpoints = newknotplot.POINTS;
    NPnew = length(newpoints);

    [closestintersection,location] = MatchPoints(oldpoints,newpoints);

    v = (closestintersection - oldpoints)/deltaT;

    % and their decompositions into the frennet frame
    t = oldknotplot.t;
    n = oldknotplot.n;
    b = oldknotplot.b;
    oldA = oldknotplot.A;

        
    spinrate = zeros(NPold,1);
    for i = 1:NPold
        
        oldknotplot.vdotn(i,:)=dot(v(i,:),n(i,:)).*n(i,:);
        oldknotplot.vdotb(i,:)=dot(v(i,:),b(i,:)).*b(i,:);
        
        % now, we interpolate the right A values - for now i'll just take
        % the nearest one we know - really we should interpolate.
    
        A1 = newknotplot.A(location(i),:);
        A2 = newknotplot.A(incp(location(i),1,NPnew),:);
        
        points1 = newpoints(location(i),:);
        points2 = newpoints(incp(location(i),1,NPnew),:);
        
        lambda = norm(closestintersection(i,:) - points1) /norm(points2 - points1) ;
         
        newA =  A1 + lambda*(A2 - A1);
        newA = newA/norm(newA);
        
        circularvelocity = (newA -oldA(i,:))/deltaT;
        component = dot( t(i,:),circularvelocity).*circularvelocity;
        circularvelocity = circularvelocity - component;
        % get the size
        spinrate(i) = norm(circularvelocity);
    
    end
    
    oldknotplot(:).spinrate = spinrate;

end