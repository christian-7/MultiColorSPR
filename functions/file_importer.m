line = h{1,1};
FOV = 4;

for i = 2:length(h);
    
    if i == 5;
        
    line = [line, '_', num2str(FOV)]
    
    else
        
    line = [line, '_', h{1,i}]
    
    end
    
end
