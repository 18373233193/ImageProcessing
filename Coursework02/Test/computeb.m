function b = computeb(SourceMask,)

%Number of nonzero matrix elements
[number] = size(SrcBoundry{1});% delete boundary
b = zeros(nnz(uint8(SourceMask))-number(1),1);
I = zeros(nnz(uint8(SourceMask))-number(1),1);

[m,n,c] = size(SourceImg);

index_b = 1;


channel = SourceImg(:,:,1);
channel = channel .* uint8(SourceMask);
channel = double(channel);

S = LaplacianSource(:,:,1);

for i = 1:m
    for j = 1:n
            
        if(0==channel(i,j))
            continue; 
        end

        b(index_b) = S(i,j);

        if(ismember([i,j],SrcBoundry{1},'rows'))

            if(channel(i+1,j) == 0)
                b(index_b) = b(index_b) - TargetImg(i+1,j);
            end

            if(channel(i-1,j) == 0)
                b(index_b) = b(index_b) - TargetImg(i-1,j);
            end

            if(channel(i,j+1) == 0)
                b(index_b) = b(index_b) - TargetImg(i,j+1);
            end

            if(channel(i,j-1) == 0)
                b(index_b) = b(index_b) - TargetImg(i,j-1);
            end
        end

        index_b = index_b + 1;
            
    end
end

end