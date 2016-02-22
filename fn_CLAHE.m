% This program is used to perform Contrast Limited Adaptive Histogram
% Equalization to the given image.
% Author : Ashwini Singh-HW 2 Computer Vision
% Input  : london.jpg(RGB image)

function []=fn_CLAHE(filename)
%% First pass: Count equal pixels
data=imread(filename);                 % filename : 'london.jpg'
data=rgb2gray(data);
t=1;                                   % start index of the window (row)
limit=8;                               % window size of the contextual area
endt=limit;                            % end index of the window (row)
eqdata=zeros(size(data,1),size(data,2));
for x=1:size(data,1)
    q=1;                                % start index of the window (column)
    endq=limit;                         % end index of the window (column)
    %% TO move Window to right and bottom, after exceeding the limit 
        for y=1:size(data,2)
        eqdata(x,y)=0;
        if (x>t+limit-1)
            t=t+limit;
            endt=limit+t-1;
        end
        if (y>q+limit-1)
            q=q+limit;
            endq=limit+q-1;
        end
        if (endt>size(data,1))
            % t=t-64;
            endt=size(data,1);
        end
        if (endq>size(data,2))
            %  q=q-64;
            endq=size(data,2);
        end
    %% Counting the number of pixels in each contextual area    
        for i=t:endt
            for j=q:endq
                
                if data(x,y)==data(i,j)
                    eqdata(x,y)=eqdata(x,y)+1;
                end
                
            end
        end
        
        
    end
end

%% Second Pass: Calculate partial rank, redistributed area and output values.

output=zeros(size(data,1),size(data,2));
cliplimit=0.3;                                  % Cliplimit can vary between 0 to 1.
t=1;
endt=limit;
for x=1:size(data,1)
    q=1;
    endq=limit;
    %% TO move Window to right and bottom, after exceeding the limit
    for y=1:size(data,2)
        
        cliptotal=0;
        partialrank=0;
        if (x>t+limit-1)
            t=t+limit;
            endt=limit+t-1;
        end
        if (y>q+limit-1)
            q=q+limit;
            endq=limit+q-1;
        end
        if (endt>size(data,1))
            % t=t-64;
            endt=size(data,1);
        end
        if (endq>size(data,2))
            % q=q-64;
            endq=size(data,2);
        end
        
        %% For each pixel (x,y), compare with cliplimit and accordingly do the clipping. Calculate partialrank. 
        for i=t:endt
            for j=q:endq
                
                
                if eqdata(i,j)>cliplimit
                    
                    incr=cliplimit/eqdata(i,j);
                else
                    incr=1;
                    
                end
                cliptotal=cliptotal+(1-incr);
                
                if data(x,y)>data(i,j)
                    partialrank=partialrank+incr;
                    
                end
                
            end
            
        end
        %% New distributed pixel values can be found from redistr and will be incremented by partial rank.
        
        redistr=(cliptotal/(limit*limit)).*data(x,y);
        output(x,y)=partialrank+redistr;
        
    end
end
figure('name','ASHWINI SINGH','NumberTitle','off')
%da=adapthisteq(data);
imshow([data uint8(output)]);          % Concatenate original and CLAHE image


end