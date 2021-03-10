NB. Base on "image_processing.ijs" by Marshall Lochbaum.
NB. Discusses some standard image processing techniques, particularly
NB. convolution, and ends up with some nice utilities.
NB. Try them out on some pictures!

require 'plot viewmat'  NB. remove gtk
load 'ide/qt/qtlib'             NB. At least since v. 8.07
read_image=: readimg_jqtide_
write_image=: writeimg_jqtide_

NB.* BWFiles: write files as black and white image.
BWFiles=: 4 : 0
   'dd tdd'=. x
   fl=. 3 rgb read_image dd,y
   newflnm=. tdd,'BW' ('.jpg' ,~ [ ,~ ] {.~ '.' i.~ ]) y
   (1 2 0|:(],],:]) <.0.5+255*765%~+/"1 fl)write_image newflnm
   newflnm
)

NB.* squareUpPix: grayify and trim longer side of picture on both ends->square aspect ratio.
squareUpPix=: 4 : 0
   'srcdir destdir'=. '/' (],[#~[~:[:{:]) &.> x rplc&.><'\/'  NB. Fwd slashes, end slash
   totrim=. <.0.5+-:|-/2{.$imgN1=. grayify 3 rgb read_image srcdir,y
   pfx=.(] {.~ '.' i:~ ])y
   totrim=. (-</2{.$imgN1)|.3{.totrim
   ((-totrim)}.totrim}.imgN1) write_image destdir,'256x256/',pfx,'Trimmed.jpg'
 NB.EG ('E:/amisc/pix/Photos/FuzzyNon/';'E:/amisc/work/imageProcessing/') squareUpPix 'N0122.jpg'
 )
 
NB.* calcLapVar: calculate variance of Laplacian convolved image
calcLapVar=: 13 : 'var ,x convolve_m grayify rgb3 read_image y'
NB.* convolve: apply convolution filter x to image y.
NB. convolve=: 4 : '(1 1,:$x) ((+/@:,@:*)&x) ;._3 y'

NB.* viewgray: view a greyscale image (values from 0 to 255)
viewgray=: 'rgb' viewmat (256#.1 1 1) * <.
NB.* norm: Rescale to 0-255
norm =: 255 * (%>./@,)@:(-<./@,)

NB. Load the blue J icon
NB. If GTK libraries aren't available or don't work, try the image3 or
NB. platimg addons.
NB. J =: readimg_jgtk_ jpath'~bin/icons/jblue.png'
J =: read_image jpath'~bin/icons/jblue.png'
NB. Here we use grayscale images.
NB. To support an rgb image, separate into a length three array of
NB. images and run the algorithm on each.
NB. Make it grayscale (otherwise convolution becomes more complicated).
J =: (+/%#)"1 ]256&#.^:_1 J

NB. The stupid padding algorithm.
NB.* pad: Add a border of width x to image y, dupe existing borders.
pad =: 4 :'({.,],{:)@|:^:(+:x) y'
NB. The smart padding algorithm. Also handles a vector right argument,
NB. which can have length less than the rank of y.
pad =: 4 :0
r=._ for_p. ({.($x),(#$y)) $ x do.
  y =. p ((#1&{.),],(#_1&{.))"r y
  r =. <: (*~:&_) r
end.
y
)

NB.* convolve_nopad: convolve image w/o padding
convolve_nopad =: 2 :0
:
(1,:$x) (u/@:(,/)@:(x&v));._3 y
)
NB.* convolve: convolution conjunction: keep the size of y constant.
convolve =: 2 :'[ u convolve_nopad v -:@<:@$@[ pad ]'
NB. standard multiplicative convolution
convolve_m =: +convolve*

NB. Gaussian and derivatives
NB. x is the standard deviation, y is distance from mean
NB.* G: Gaussian distribution
G =: ((%:2p1)*[) %~ ^@-@-:@*:@%~
NB.* dG: first derivative of Gaussian distribution
dG =: _2*(%*:)~ * G
NB.* ddG: second derivative of Gaussian distribution
ddG =: *:@[ %~ 2 * (+:@%&*:~ - 1:)*G

NB. Some kernels which are important to convolution. Try:
NB. viewgray kernel_k convolve J
NB. For kernels other than blur_k, call norm before viewgray.
NB. You can change the sigma value to adjust the sharpness or
NB. susceptibility to noise.
NB. I recommend keeping the size of the kernel large to ensure
NB. that the value is sufficiently small at the edges.
blur_k =: */~ 5 G i:10          NB. large Gaussian blur
dx_k =: 2 (G */ dG) i:4         NB. derivative in x
dy_k =: |: dx_k                 NB. derivative in y
NB. The laplace operator. We subtract the mean to remove artifacts
NB. from the discrete nature of the kernel.
laplace_k =: (- (+/%#)@,) (+|:) 2 (G */ ddG) i:4
laplacianK0=: _1 _1 _1,_1 8 _1,:_1 _1 _1
laplacianK1=: 0 1 0,1 _4 1,:0 1 0

NB. To find "edginess," a step on the way to effective edge
NB. detection, we can use the gradient magnitude
NB. dx +&.:*: dy
NB.* getedginess: 
getedginess =: dx_k&convolve_m +&.:*: dy_k&convolve_m

NB. The distance transform computes the distance at a point from
NB. the outside of the image.
NB. This means it is zero in the background.
NB. It uses a black-and-white (binary) image as input.
NB. To compute it, we start with the crudest of upper bounds:
NB. 0 outside the image and _ inside.
NB. Then to refine this, we add a distance kernel (which simply
NB. give distance from the center) to the points around each point,
NB. and take the minimum of the results.
NB. We do this until the image stops converging (with ^:_).
NB. Replacing _ with a: will give you an array of successive images,
NB. which you can view to get an intuition for how the process works.
dist_k =: +/~&.:*: i:5
distancetransform =: dist_k (<. convolve +)^:_ (_&*)

NB. The medial axis transform computes a center line (more like a
NB. tree) along the image. This line consists of ridges in the
NB. distance transform, where the distance from two different edges
NB. is the same.
NB. The laplace kernel, which gives the curvature (in a sense) of the
NB. surface, is perfect for this.
NB. However, it also produces a negative value at edges and curves,
NB. so to obtain only the medial axis apply 0&>. to the results.
medialaxistransform =: (-laplace_k) + convolve * distancetransform

NB. =========================================================
NB. As a bonus, you get the NL-means algorithm, with very little
NB. explanation.
NB. Simply apply to an image to sharpen it.
NB. This implementation is slow, but the results are quite impressive.
NB. I highly recommend this paper for an introduction to the topic.
NB. http://bengal.missouri.edu/~kes25c/nl2.pdf

crop =: [ }. -@[ }. ] NB. take from all edges
NB. The image distance of the central point from other points
similarity =: (*:255*7%6) %~ 7 7&crop +convolve_nopad(*:@-) ]
NB. The weighted average at a single point
avg =: ^@:-@:similarity ([ (%~&(+/@,)) *) 3 3&crop
nlmeans =: (1 1,:21 21) avg;._3 (10&pad)

NB. applyFilter: apply convolution filter x to image y.
applyFilter=: 4 : '($x) (x&([: +/ [: , *)) ;._3 y'

NB.* rgb3: convert 2D matrix of 24-bit numbers to 3D array of 3-color planes & back.
rgb3=: (256 256 256&#:)`(256&#.) @. ((3 = [: {: $) *. 3 = [: # $)

NB.* splitRGBPlanes: split RGB 3D into 3 planes.
splitRGBPlanes=: [: |:&.> [: <"2 |:

NB.* rgb: convert 2D matrix of (x*8)-bit numbers to 3D array of x-color planes & back.
rgb=: 4 : '(x$256)&#:`(256&#.)@.((x = [: {: $) *. 3 = [: # $) y'

NB.* pic2bits: convert 2D matrix of x-bit numbers to 3D array of x-bit Booleans.
pic2bits=: 4 : '(x$2)&#:`#.@.((x = [: {: $) *. 3 = [: # $) y'

NB.* norm255: normalize array of numbers into the range 0-255.
norm255=: [:<.0.5+255 * (% >./@,)@:(- <./@,)

NB.* grayify: convert rgb3 to grayscale3.
grayify=: [: |: [: ([: norm255 ] , ,:~) [: |: +/&.|:

NB.* reduceSize: reduce mat y on both dims based
NB. on bool x extended over each axis; work on 2D or 3D.
reduceSize=: 13 : '(x$~1{$y)#"(<:#$y)(x$~{.$y)#y'

NB.* showJPG: rely on Windows having a JPG viewer attached to the suffix.
showJPG=: 3 : 'shell flnm [ y write_image flnm=. ''XXtempXX.jpg'''

NB. require '~Code/image_processing.ijs' NB. All duped here
NB.* progBlurring: progressive blurring
progBlurring=: 3 : 0
   (10;blur_k) progBlurring y
:
   rr=. 0
   img=. y
   for_ix. i.>{.x do. rr=. rr,+/|,y-img=. norm255 ($img)$(>1{x) convolve_Gblur img end.
   rr
)

SIMPBLUR=: (+&*:)"0/~i:1

NB.* mat-mult convolution of mat y.
convolve_Gblur=: 13 : ',/"2 x convolve_m y'

fattenFlat2rgb3=: 13 : '(] , ,:~)&.|:y'  NB.* fattenFlat2rgb3: duplicate 1 plane mat->3 identical planes
