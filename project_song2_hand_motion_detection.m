vside=VideoReader('song2_side.mp4');
vup=VideoReader('song2_up.MOV');

delay=0;

step=0.5;
startv=4.80;
endv=min(vside.Duration, vup.Duration);
for i=startv:step:endv
    vside.CurrentTime=i;
    vup.CurrentTime=i+delay;
    frame = readFrame(vside);

   

    AInv = imcomplement(frame);
    BInv = imreducehaze(AInv);
    B = imcomplement(BInv);

    frame1 = readFrame(vup);


    


  
    imgGray = rgb2gray(frame1);

    th = 90;
    bw = imgGray < th;
    imgGray = rgb2gray(frame1);
    bw=adapthisteq(imgGray);
    


    imgGray= B(:,:,1)>=225 & B(:,:,1)<=248 & B(:,:,2)>=140 & B(:,:,2)<=230 & B(:,:,3)>=110 & B(:,:,3)<=200;
  

    figure(1)
    
   
 

    AInv = imcomplement(frame1);
    BInv = imreducehaze(AInv);
    B = imcomplement(BInv);

   
    bw= B(:,:,1)>=195 & B(:,:,1)<=255 & B(:,:,2)>=120 & B(:,:,2)<=172 & B(:,:,3)>=0 & B(:,:,3)<=255;

    bw=bwareaopen(bw, 400);


    boundariesl=edge(bw,"canny");
   


    imshow(boundariesl);
    title("hands edges extracted")




   
    pause(0.0001)


   
    

end
