function [A,b] = constructEquation(n,im_target,im_mask,lap,indexMatrix)
    %At most, there are 5 coefficients per row 
    %
    coeff_num = 5;

    %create the sparse matrix to save memory
    A = spalloc(n, n, n*coeff_num);
    
    b = zeros(n,1);
    
    index = 0;
    
    for x=1:size(indexMatrix,1)
        for y=1:size(indexMatrix,2)
            
            if im_mask(x,y)==1
                
                index = index+1;
                A(index,index)=4; %the diagonal represent the current pixel

                %check the boundary
                if im_mask(x-1,y)==0 %known left pixel
                    b(index)=im_target(x-1,y); %add it to B
                else %unknown boundary
                    A(index,indexMatrix(x-1,y))=-1; %set its coefficient to -1
                end
                if im_mask(x+1,y)==0 %known right pixel
                    b(index)=b(index)+im_target(x+1,y); %add it to B
                else %unknown boundary
                    A(index,indexMatrix(x+1,y))=-1; %set its coefficient to -1
                end
                if im_mask(x,y-1)==0 %known bottom pixel
                    b(index)=b(index)+im_target(x,y-1); %add it to B
                else %unknown boundary
                    A(index,indexMatrix(x,y-1))=-1; %set its coefficient to -1
                end
                if im_mask(x,y+1)==0 %known top pixel
                    b(index)=b(index)+im_target(x,y+1); %add it to B
                else %unknown boundary
                    A(index,indexMatrix(x,y+1))=-1; %set its coefficient to -1
                end
                
                %update the B vector with the laplacian value
                
                b(index)=b(index)-lap(x,y);

            end
            
        end
    end
    
end