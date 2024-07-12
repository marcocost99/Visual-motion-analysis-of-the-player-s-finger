
video=VideoReader('song6_side.mp4');




first_f=zeros(size(readFrame(video)));


step=0.02;

for i=3.48:step:3.690
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

    


    if(video.CurrentTime<=3.51)
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

    keys_detected=bwareaopen(keys_detected,10);
    



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


        
         
        
         if(320<=upperCoordinateTile & upperCoordinateTile<=330)
            keyPressed= strcat(keyPressed, "D3; ");
         end

         if(385<=upperCoordinateTile & upperCoordinateTile<=390)
            keyPressed= strcat(keyPressed, "F3b; ");
         end
    
         if(440<=upperCoordinateTile & upperCoordinateTile<=450)
            keyPressed= strcat(keyPressed, "A3; ");
         end
    
         if(540<=upperCoordinateTile & upperCoordinateTile<=550)
            keyPressed= strcat(keyPressed, "D4; ");
         end
    
         if(653<=upperCoordinateTile & upperCoordinateTile<=668)
            keyPressed= strcat(keyPressed, "F4b; ");
         end

         if(700<=upperCoordinateTile & upperCoordinateTile<=710)
            keyPressed= strcat(keyPressed, "A4; ");
         end

    end

    if(keyPressed~="")
        sprintf("Keys pressed: " + keyPressed + " at %.3f sec", video.CurrentTime)
    end
    


    

   
    


    pause(0.0001)
    

end
