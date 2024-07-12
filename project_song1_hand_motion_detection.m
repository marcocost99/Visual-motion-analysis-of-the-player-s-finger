vside=VideoReader('song1_side.mp4');
vup=VideoReader('song1_up.mp4');

delay=1;

step=0.1;
for i=0:step:min(vside.Duration, vup.Duration)
    vside.CurrentTime=i;
    vup.CurrentTime=i+delay;
    frame = readFrame(vside);

    hold on

    AInv = imcomplement(frame);
    BInv = imreducehaze(AInv);
    B = imcomplement(BInv);

    frame1 = readFrame(vup);

    imgGray = rgb2gray(frame1);

    th = 90;
    bw = imgGray < th;
    imgGray = rgb2gray(frame1);
    bw=adapthisteq(imgGray);
    


    imgGray=B(:,:,1)>90 & B(:,:,1)<180 & B(:,:,2)>40 & B(:,:,2)<65 & B(:,:,3)>10 & B(:,:,3)<55;
  
    subplot(1,2,1);
    
    imshow(imgGray);



    
    subplot(1,2,2);
    bw=frame1(:,:,1)>180 & frame1(:,:,1)<=235 & frame1(:,:,2)>=60 & frame1(:,:,2)<=151 & frame1(:,:,3)>50 & frame1(:,:,3)<=146;
    imshow(bw);
    
    pause(0.0001)
    

end
