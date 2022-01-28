img = imread('re1.jpg');
imshow(img)
mask = roipoly(img,100,100); 