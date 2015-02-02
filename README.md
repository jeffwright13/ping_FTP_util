# ping_FTP_util
Repo to hold the Perl script "pingFtpUtil.pl"

usage: perl pingFtpUtil <host ip> <username> <password> <file name>

You will need to create a file that you want to upload and download in the directory you run the script from. The script creates a file called ping_ftp_data.csv that has the results.

The syntax to run the script is
perl pingFtpUtil.pl <host ip> <username> <password> <file name> <ping count (optional, default = 100)> 

Here is the output when run from prompt - 

Time,Message,Ping Min,Ping Max,Ping Average,Upload/Download,Success/Failure,Speed(Bytes/sec)
2015-1-30 17:50:32,Ping done,0.564,0.921,0.744
2015-1-30 17:50:33,Upload done,,,Upload,Success,5020253
2015-1-30 17:50:33,Download done,,,Download,Success,5020253

You can run a for loop in order to run the script in a continuous loop. E.g.:

for i in {1..10}; 
do 
perl pingFtpUtil.pl <host ip> <username> <password> <file name> <ping count (optional, default = 100)>;
done

The above will run the script 10 times.
