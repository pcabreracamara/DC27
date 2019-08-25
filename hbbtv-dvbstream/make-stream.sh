#!/bin/sh


export INPUT1="norse.avi"
export INPUT2="norse.avi"

mkdir output
mkdir tmp

ffmpeg -i $INPUT1 -an -vcodec mpeg2video -f mpeg2video -b 5000k -maxrate 5000k -minrate 5000k -bf 2 -bufsize 1835008 -y tmp/video1.mp2
esvideompeg2pes tmp/video1.mp2 > tmp/video1.pes
pesvideo2ts 2064 25 112 5270000 0 tmp/video1.pes > tmp/video1.ts

ffmpeg -i $INPUT1 -ac 2 -vn -acodec mp2 -f mp2 -ab 128000 -ar 48000 -y tmp/audio1.mp2
esaudio2pes tmp/audio1.mp2 1152 48000 768 -1 3600 > tmp/audio1.pes
pesaudio2ts 2065 1152 48000 768 -1 tmp/audio1.pes > tmp/audio1.ts

ffmpeg -i $INPUT2 -an -vcodec mpeg2video -f mpeg2video -b 5000k -maxrate 5000k -minrate 5000k -bf 2 -bufsize 1835008 -y tmp/video2.mp2
esvideompeg2pes tmp/video2.mp2 > tmp/video2.pes
pesvideo2ts 2066 25 112 5270000 0 tmp/video2.pes > tmp/video2.ts

ffmpeg -i $INPUT2 -ac 2 -vn -acodec mp2 -f mp2 -ab 128000 -ar 48000 -y tmp/audio2.mp2
esaudio2pes tmp/audio2.mp2 1152 48000 768 -1 3600 > tmp/audio2.pes
pesaudio2ts 2067 1152 48000 768 -1 tmp/audio2.pes > tmp/audio2.ts


python ./create-metadata-ts.py

tscbrmuxer c:2300000 tmp/video1.ts b:188000 tmp/audio1.ts b:2300000 tmp/video2.ts b:188000 tmp/audio2.ts b:3008 pat.ts b:3008 pmt0.ts b:3008 pmt1.ts b:1400 nit.ts b:1500 sdt.ts b:1400 ait0.ts b:1400 ait1.ts > output/final.ts

