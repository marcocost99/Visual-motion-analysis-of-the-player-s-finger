vside=VideoReader('song2_side.mp4');
vup=VideoReader('song2_up.MOV');

delay=0;

step=0.01;
startv=4.80;
endv=4.81; %min(vside.Duration, vup.Duration)
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
    subplot(1,6,1);
    
    imshow(imgGray);
    title(sprintf('Current Time = %.3f sec', vside.CurrentTime));



    AInv = imcomplement(frame1);
    BInv = imreducehaze(AInv);
    B = imcomplement(BInv);

   
    bw= B(:,:,1)>=195 & B(:,:,1)<=255 & B(:,:,2)>=120 & B(:,:,2)<=172 & B(:,:,3)>=0 & B(:,:,3)<=255;

    bw=bwareaopen(bw, 400);



    
    n = ceil(size(bw,2)/2)+78;
    right_h = bw(1:size(bw,1)-480,1+140:n-240);
    left_h = bw(1:size(bw,1)-350,n+1:end);
    

    subplot(1,6,3);
    imshow(left_h);
    subplot(1,6,2);
    imshow(right_h);
    
   
    boundariesl=edge(left_h,"canny");
   


    subplot(1,6,5);
    imshow(boundariesl);
    title("left hand edges extracted")



    boundariesr=edge(right_h,"canny");
   


    subplot(1,6,4);
    imshow(boundariesr);
    title("right hand edges extracted")



    boundarieslcropped=boundariesl(1:end,1:end);

    boundariesrcropped=boundariesr(1:end,1:end);
   
   

   


    boundarieslcroppedpalm=boundarieslcropped(1:floor(size(boundarieslcropped,1)/2),floor(size(boundarieslcropped,2)/3):end-100);


    boundarieslcroppedpalm=boundarieslcroppedpalm(1+50:end,1+20:end-50);
    
  
    
    [distance_transforml,IDX] = bwdist(boundarieslcroppedpalm,'chessboard');
    

    
    distance_transforml(distance_transforml<90)=0;

    

  
    [distance_transforml,IDX] = bwdist(boundarieslcroppedpalm,'chessboard');
    mat2gray(distance_transforml);
   


    distance_transforml_filter=mat2gray(distance_transforml);

    

    v = max(distance_transforml_filter(:));         
    [ii,jj] = find(distance_transforml_filter == v);

   
    figure(2)
    imshow(distance_transforml_filter);

    figure(3)
    

    xc=floor(mean(ii,'all'))
    yc=floor(mean(jj,'all'))

    imshow(boundarieslcroppedpalm)
    title("left hand edges extracted")
    hold on
    plot(xc,yc,"*")








    
    [distance_transformr,IDX] = bwdist(boundariesrcropped,'chessboard');
    distance_transformr(distance_transformr<90)=0;
    distance_transformr_filter=mat2gray(distance_transforml);
    figure(6)
    imshow(distance_transformr_filter)


     vr = max(distance_transformr_filter(:)) ;        
    [ir,jr] = find(distance_transformr_filter == vr);


    figure(7)
    

    xr=floor(mean(ir,'all'))
    yr=floor(mean(jr,'all'))

    imshow(right_h)
    title("center of the palm right hand")
    hold on
    plot(xr+150,yr-100,"*")



    

  

   


    distance_transforml_filter=mat2gray(distance_transforml);





    
    
    hold off

    
     
    figure(4)
    imshow(left_h)
    title("center of the palm left hand")
    hold on
    plot(xc+400,yc+15,"*")
    
    
    hold off

    figure(5)


    [columnsInImage rowsInImage] = meshgrid(1:size(left_h,2), 1:size(left_h,1));
    % Create the circle in the image.
    centerX = xc+405;
    centerY = yc-10;
    radius = 260;
    circlePixels = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= radius.^2;

    
    
     
    
    figers_l=left_h & ~circlePixels;

    image(figers_l);
    colormap([0 0 0; 1 1 1]);
 
    title('Motion of the fingers of the left hand');




    figure(8)


    [columnsInImage rowsInImage] = meshgrid(1:size(right_h,2), 1:size(right_h,1));
    % Create the circle in the image.
    centerX = xr+170;
    centerY = yr-125;
    radius = 270;
    circlePixels = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= radius.^2;

    
    
    

    
    figers_r=right_h & ~circlePixels;
   
    image(figers_r);
    colormap([0 0 0; 1 1 1]);
 
    title('Motion of the fingers of the right hand');


    filter_figers_r = bwlabel(figers_r,4);
    figure(9)
    
    subplot(2,4,1)
    
    little_finger_r=filter_figers_r==1;
    image(little_finger_r);
    title('Little finger right hand');
    colormap([0 0 0; 1 1 1]);


    subplot(2,4,5)
    
    edge_little_finger_r=edge(little_finger_r(215:420,53:160),"canny");
    imshow(edge_little_finger_r);


    hold on

    BW0=edge_little_finger_r;
    BW=bwperim( bwconvhull(bwareaopen(edge_little_finger_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off


    

 

   





    middle_finger_r=filter_figers_r==4;


    middle_finger_r=imrotate(middle_finger_r, -60);

    subplot(2,4,2)
    image(middle_finger_r);
    title('Middle finger right hand');
    colormap([0 0 0; 1 1 1]);

    subplot(2,4,6)
    
    edge_middle_finger_r=edge(middle_finger_r(300:570,200:400),"canny");


   
    
    imshow(edge_middle_finger_r);

    hold on

    BW0=edge_middle_finger_r;
    BW=bwperim( bwconvhull(bwareaopen(edge_middle_finger_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')

    
   


   



    hold off







   





    
    

    index_finger_r=filter_figers_r==6;

    index_finger_r=imrotate(index_finger_r, -60);

    subplot(2,4,3)
    image(index_finger_r);
    title('Index finger right hand');
    colormap([0 0 0; 1 1 1]);

    subplot(2,4,7)
    
    edge_index_finger_r=edge(index_finger_r(420:620,260:450),"canny");

    imshow(edge_index_finger_r);

     hold on

    BW0=edge_index_finger_r;
    BW=bwperim( bwconvhull(bwareaopen(edge_index_finger_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off

    


 



    


    thumb_finger_r=filter_figers_r==19;
    subplot(2,4,4)
    image(thumb_finger_r);
    title('Thumb finger right hand');
    colormap([0 0 0; 1 1 1]);

    subplot(2,4,8)
    edge_thumb_finger_r=edge(thumb_finger_r(240:380,470:600));
    imshow(edge_thumb_finger_r);



    hold on

    BW0=edge_thumb_finger_r;
    BW=bwperim( bwconvhull(bwareaopen(edge_thumb_finger_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off





    filter_figers_l = bwlabel(figers_l,4);
    figure(10)
    title('Left hand');
    subplot(2,2,1)
    
    thumb_finger_l=filter_figers_l==1;
    image(thumb_finger_l);
    title('Thumb finger left hand');
    colormap([0 0 0; 1 1 1]);

    subplot(2,2,3)
    


    edge_thumb_finger_l=edge(thumb_finger_l(120:440,130:330),"canny");
    imshow(edge_thumb_finger_l);

    hold on

    BW0=edge_thumb_finger_l;
    BW=bwperim( bwconvhull(bwareaopen(edge_thumb_finger_l,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off



    subplot(2,2,2)
    little_finger_l=filter_figers_l==17;
    image(little_finger_l);
    title('Little finger left hand');
    colormap([0 0 0; 1 1 1]);


    subplot(2,2,4)
    
    edge_little_finger_l=edge(little_finger_l(350:550,730:860),"canny");
    imshow(edge_little_finger_l);

    hold on

    BW0=edge_little_finger_l;
    BW=bwperim( bwconvhull(bwareaopen(edge_little_finger_l,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off

    
   
    figure(11);
    imgSide=bwareaopen(imgGray, 400);
    imgSidecropped=imgSide(500:850,1:570);
    imshow(imgSidecropped);
    title("Side view");

     boundariesSide=edge(imgSidecropped(20:200,10:400),"canny");
     figure(12);
     


     [distance_transformside,IDX] = bwdist(boundariesSide,'chessboard');
    

    
   

    figure(12)
    imshow(mat2gray(distance_transformside));
    hold on

    vr = max(distance_transformside(:)) ;        
    [i,j] = find(distance_transformside == vr);

    x=floor(mean(i,'all'))
    y=floor(mean(j,'all'))

  
    
    plot(x+57,y-63,"*")
    hold off

    figure(13)
    

    [columnsInImage rowsInImage] = meshgrid(1:size(imgSidecropped,2), 1:size(imgSidecropped,1));
    
    centerX = x-300;
    centerY = +150;
    r = 405;
    r1=420;



    
  


        
    rect=centerX-r<=rowsInImage & rowsInImage<=centerX+r & centerY-r1<=columnsInImage & columnsInImage<=centerY+r1;

    rect=imrotate(rect, 32);

    rect=rect(100:450,82:651);

    filter_imgSidecropped=imgSidecropped & ~rect;

    filter_imgSidecropped=filter_imgSidecropped(50:320,230:565);
    
    image(filter_imgSidecropped);


    colormap([0 0 0; 1 1 1]);



    filter_figers_side = bwlabel(filter_imgSidecropped,4);
    figure(14)
    
    subplot(2,5,1)
    
    littleandringfingerSide_r=filter_figers_side==1;
    image(littleandringfingerSide_r);
    title('Little and ring finger right hand');

   
     
    




    [columnsInImage rowsInImage] = meshgrid(1:size(littleandringfingerSide_r,2), 1:size(littleandringfingerSide_r,1));
    % Create the rectangle in the image.
    centerX = 100;
    centerY = 100;
    r = 43;
    r1=300;

    rect=centerX-r<=rowsInImage & rowsInImage<=centerX+r & centerY-r1<=columnsInImage & columnsInImage<=centerY+r1;

    rect=imrotate(rect, -20);
   

    rect=rect(1:271,1:336);

    filter_img_littleandringfingerSide_r= littleandringfingerSide_r & ~ rect;

    littlefingerSide_r= bwareaopen(filter_img_littleandringfingerSide_r,200);

    subplot(2,5,2)
    littlefingerSide_r_resied=littlefingerSide_r(135:end,:);
    image(littlefingerSide_r_resied);
    title('Little finger right hand');


    edge_littlefingerSide_r=edge(littlefingerSide_r_resied,"canny");


    subplot(2,5,7)
    image(edge_littlefingerSide_r);
    hold on

    BW0=littlefingerSide_r_resied;
    BW=bwperim( bwconvhull(bwareaopen(edge_littlefingerSide_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off



    subplot(2,5,3)

    ringfingerSide_r= littleandringfingerSide_r & ~ littlefingerSide_r;

    ringfingerSide_r=bwareaopen(ringfingerSide_r,300);
    ringfingerSide_r=ringfingerSide_r(110:210,80:230);


    image(ringfingerSide_r);
    title('Ring finger right hand');

    edge_ringfingerSide_r=edge(ringfingerSide_r,"canny");


    subplot(2,5,8)
    image(edge_ringfingerSide_r);
    hold on

    BW0=edge_ringfingerSide_r;
    BW=bwperim( bwconvhull(bwareaopen(edge_ringfingerSide_r,100)) );
    [I,J]=find(BW);
    [~,p]=min(I);
    [~,l]=min(J);
    [~,r]=max(J);
    Ip=I(p); Jp=J(p);
    Il=I(l); Jl=J(l);
    Ir=I(r); Jr=J(r);
    Ic=min(Il,Ir);
    Im=round((Ip+Ic)/2);
    BW(Ic:end,:)=0;
    BW(1:Im,:)=0;
    reg=regionprops(BW,'PixelList');
    for i=1:2
      x = reg(i).PixelList(:,1);
      y = reg(i).PixelList(:,2);
      
      reg(i).p=polyfit(x,y,1);
    end

    x1=1:Jp;
    y1=polyval(reg(1).p,x1);
    
    x2=Jp:size(BW,2);
    y2=polyval(reg(2).p,x2);
    
    plot(x1,y1,'rx')
    plot(x2,y2,'rx')



 

   


   



    hold off

    









    subplot(2,5,4)
    indexesSide_l_r=filter_figers_side==8;
    image(indexesSide_l_r);
    title('Index fingers right and left hand');
    colormap([0 0 0; 1 1 1]);

    subplot(2,5,5)
    
    littlefingerSide_l=filter_figers_side==30;
    image(littlefingerSide_l);
    title('Little finger left hand');
    
    pause(0.0001)


   
    

end
