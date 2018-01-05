function matrix = computeA(N)
matrix = zeros(N,N);
for i=1:N  
    for j=1:N  
        if(i==j)  
            matrix(i, j)=-4; 
        elseif(adjacent(pixel(j), pixel(i)))  
            matrix(i, j)=1;  
        else  
            matrix(i, j)=0;  
        end  
    end  
end 
end