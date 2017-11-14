function [] = ConstructCurveVelocities(start,finish,deltaT,datadir)
    % for all the knotplots between start and end, construct the smoothed
    % filament, and write to file

    for index = start:1:(finish)
        filename = strcat(datadir,'Smoothedknotplot0_',num2str(index),'.vtk') ; 
        oldknotplot = CurveRead(filename); 
        filename = strcat(datadir,'Smoothedknotplot0_',num2str(index+deltaT),'.vtk') ; 
        newknotplot = CurveRead(filename); 
        
        oldknotplotwithvelocity = ConstructCurveVelocitySpinRate(oldknotplot,newknotplot,deltaT);
        
        CurveWrite(oldknotplotwithvelocity,strcat(datadir,'Smoothedknotplot0_',num2str(index),'.vtk'));

        index
    end

end