#!/bin/sh
user=$1
current=`date "+[%Y-%m-%d %H:%M:%S]"`
tar_url=`curl -s https://twitcasting.tv/$1/metastream.m3u8 | grep ts-220.m3u8`
filename=$user$(echo -n "_")
output_format=ts
output_dir=/root/TwitcastingRecorder/rec/$user
sleep_time=5

if [ ! -d $output_dir ]; then
	mkdir $output_dir
fi

while :
do
	curl -s https://twitcasting.tv/$user/metastream.m3u8 | grep -q ts-220.m3u8 
	if [ $? -eq 0 ]; then
		echo -n `date "+[%Y-%m-%d %H:%M:%S]"`
		echo " Casting! Start to record!"
		ffmpeg -i $tar_url $output_dir/$filename$(date "+%Y%m%d-%H:%M:%S").$output_format
		echo -n `date "+[%Y-%m-%d %H:%M:%S]"`
		echo " Recording finished!"
		echo -n `date "+[%Y-%m-%d %H:%M:%S]"` >> /root/TwitcastingRecorder/rec/$user/record.log
		echo " Recorded." >> /root/TwitcastingRecorder/rec/$user/record.log
	else
		echo -n `date "+[%Y-%m-%d %H:%M:%S]"`
		echo " Not casting!"
	fi
	sleep $sleep_time
done

