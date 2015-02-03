# ping_FTP_util
TODO:
====
Fix scipt to call appropriate "count" variable for ping command.
In Linux, 'ping -c' is how to specify # ping counts.
In the Windows GNU Core Utils, it's 'ping -n'.
Investigate if Perl has module to detect the underlying OS, and then fix script to use appropriate flag option based on that.

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

NOTE: for Windows use, install GitHub for Windows (https://windows.github.com/) in order to get a Linux-like environment on your PC. Then install the GNU Core Utils (http://gnuwin32.sourceforge.net/packages/coreutils.htm). This adds the "seq" command, which loop.sh relies on.
