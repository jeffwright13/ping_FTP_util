#!/bin/sh

num_loops=1
sleep_time=60
ftp_ip='66.82.228.131' 
username='npsrt'
password='npsrt'
file='1mb.test'

for i in `seq $num_loops`:
do
    perl pingFtpUtil.pl $ftp_ip $username $password $file;
    sleep $sleep_time
done
