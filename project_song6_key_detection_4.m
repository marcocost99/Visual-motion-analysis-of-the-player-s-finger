
video=VideoReader('song6_side.mp4');




first_f=zeros(size(readFrame(video)));


step=0.05;

for i=25.4:step:27.827
    video.CurrentTime=i;
   

    frame1 = readFrame(video);
    frame1=imrotate(frame1, -2);


    AInv = imcomplement(frame1);
    BInv = imreducehaze(AInv);
    B = imcomplement(BInv);

    figure(1)
    subplot(1,5,4)
    B=B(400:1370,1:540,:);
    image(B);
    title("Original frame")




    bw1= B(:,:,1)>=0 & B(:,:,1)<=255 & B(:,:,2)>=0 & B(:,:,2)<=255 & B(:,:,3)>=120 & B(:,:,3)<=200;



    
    
    piano_tiles=bw1;

    piano_tiles=piano_tiles(1:end,470:500);

    


    if(video.CurrentTime<=25.482)
        first_f=piano_tiles;

    end



  
    subplot(1,5,3)
    image(piano_tiles);
    colormap([0 0 0; 1 1 1]);
    title(sprintf('Current frame; current Time = %.3f sec', video.CurrentTime));
    


    subplot(1,5,5)
    image(first_f);
    
    title("Initial frame - empty keyboard");


    keys_detected=piano_tiles & ~ first_f;

    keys_detected=bwareaopen(keys_detected,17);
    



    subplot(1,5,2)
    image(  keys_detected );
    colormap([0 0 0; 1 1 1]);
    title("Difference current & initial frame");


 
    im=B;
    res=imresize(keys_detected, [971 540]);
    for i=1:size(im,1)
        for j=1:size(im,2)
            if res(i,j)==1
                im(i,j,1)=255;
                im(i,j,2)=0;
                im(i,j,3)=0;
            
            end
        end
    end

    
    
    
    
    subplot(1,5,1)
    image(im)
    title("Detected keys");


    keys = bwlabel(keys_detected);
     
    keyPressed="";
    

    
    for i=1:bwconncomp(keys_detected).NumObjects
        key=keys==i;

        [A1, A2] = find(key);
        upperCoordinateTile=max(A1);
        leftCoordinateTile=min(A2);


         if(355<=upperCoordinateTile & upperCoordinateTile<=360)
            keyPressed= strcat(keyPressed, "E3; ");
         end
    
         if(375<=upperCoordinateTile & upperCoordinateTile<=380)
            keyPressed= strcat(keyPressed, "F3; ");
         end
    
         if(385<=upperCoordinateTile & upperCoordinateTile<=390)
            keyPressed= strcat(keyPressed, "F3b; ");
         end
    
         if(410<=upperCoordinateTile & upperCoordinateTile<=415)
            keyPressed= strcat(keyPressed, "G3; ");
         end

         if(420<=upperCoordinateTile & upperCoordinateTile<=425)
            keyPressed= strcat(keyPressed, "G3b; ");
         end

         if(445<=upperCoordinateTile & upperCoordinateTile<=450)
            keyPressed= strcat(keyPressed, "A3; ");
         end

         if(460<=upperCoordinateTile & upperCoordinateTile<=465)
            keyPressed= strcat(keyPressed, "A3b; ");
         end

         if(485<=upperCoordinateTile & upperCoordinateTile<=490)
            keyPressed= strcat(keyPressed, "B3; ");
         end

    end

    if(keyPressed~="")
        sprintf("Keys pressed: " + keyPressed + " at %.3f sec", video.CurrentTime)
    end
    
    pause(0.0001)
    

end
