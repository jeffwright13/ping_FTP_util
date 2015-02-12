#!/bin/sh

num_loops=24
sleep_time=3500
ftp_ip='66.82.228.131' 
username='npsrt'
password='npsrt'
file='1mb.test'

for i in `seq $num_loops`
do
    printf 'Iteration %s\n' $i
    perl pingFtpUtil.pl $ftp_ip $username $password $file;
    if [ "$i" -lt "$num_loops" ]; then
        sleep $sleep_time
    fi
done
