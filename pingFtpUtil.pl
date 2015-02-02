#!/usr/bin/perl -w

use strict;
use Net::FTP;
use File::stat;
use Data::Dumper;

my $logFile = "ping_ftp_data.csv";

if( !(-e $logFile) ) {
   open (LOG, ">$logFile")  or die "Error opening $logFile: $!";
   print LOG "Time,Message,Ping Min,Ping Max,Ping Average,Upload/Download,Success/Failure,Speed(Bytes/sec)\n";
   close LOG or die "Error closing $logFile: $!";
   print"\n# $logFile Created #\n";
   #print "\nNow run with these arguments:\n\n perl pingFtpUtil <host ip> <username> <password> <upload/download file name>\n\n";   
}

if ($#ARGV < 3 ) {
	print "\nusage: perl pingFtpUtil <host ip> <username> <password> <file name>\n";
	exit;
}

my %parm = (
   ftphost => $ARGV[0],
   ftpuser => $ARGV[1],
   ftppass => $ARGV[2]
   );

my %file = (
   source => $ARGV[3],
   dest   => $ARGV[3]
   );

my $pingCount = 100;  #default
if( $#ARGV == 4 ) {
   $pingCount = $ARGV[4];
}

open (LOG, ">>$logFile")  or die "Error opening $logFile: $!";

unless (-r $file{source} ) {
   LogIt('exit', "No read permission on file $file{source}.\n");
}

#ping the ftp server first
my $pingRes = `ping -c $pingCount $parm{ftphost}`;

#parse the response 
#print Dumper $pingRes;

if( $pingRes =~ /TTL/i ) {

	#The max, min and avg stats come after the last ':' character
	my $pingStatsStr = substr( $pingRes, rindex( $pingRes, '=' ) + 2 );

	my @pingStatsArr = split( '/' , $pingStatsStr );
	my ( $minTime, $maxTime, $avgTime );
	#print Dumper \@pingStatsArr;
    $minTime = $pingStatsArr[0];
	$avgTime = $pingStatsArr[1];
	$maxTime = $pingStatsArr[2];
	#print "\n\n$minTime, $maxTime, $avgTime\n\n";
	LogIt('noexit', "Ping done,$minTime,$maxTime,$avgTime");
} else {
    LogIt('exit', "Ping failed. Host unreachable.");
}

#now collect the FTP test data 

my $ftp = Net::FTP->new($parm{ftphost}, Debug=>0) or
LogIt('exit', "Error connecting. Network or server problem,");

$ftp->login($parm{ftpuser}, $parm{ftppass}) or 
LogIt('exit', "Error logging in. Check username/password.");

#use the binary mode
$ftp->binary();

my $sizeOfFile = ${(stat( $file{source} ))}[7]; #7th index is file size
my $startTime = time;
my $speed = 0;
#print "\nSizeof file(Up): $sizeOfFile\n";

$ftp->put($file{source}, $file{dest}) or
LogIt('exit', "Error uploading. Disk space or permissions problems?");

my $uploadTime = time - $startTime;
#print "\nput completed. $uploadTime \n";

if( $uploadTime != 0 ) {
    $speed = $sizeOfFile/$uploadTime;
} else {
    $speed = $sizeOfFile;
}

LogIt('noexit', "Upload done,,,,Upload,Success,$speed");

$sizeOfFile = $ftp->size($file{dest});
$startTime = time;
#print "\nSizeof file(Dn): $sizeOfFile\n";

$ftp->get($file{dest}) or
LogIt('exit', "Error downloading. Disk space or permissions problems?");

my $downldTime = time - $startTime;
#print "\nget completed. $downldTime\n";
if( $downldTime != 0 ) {
    $speed = $sizeOfFile/$downldTime;
} else {
    $speed = $sizeOfFile;
}

LogIt('noexit', "Download done,,,,Download,Success,$speed");

$ftp->quit() or 
LogIt('exit', "Error disconnecting.");

close LOG or die "Error closing $logFile: $!";

###########################################################################
# Print message with date+timestamp to logfile.
# Abort program if instructed to.
sub LogIt {
   my $exit = $_[0];
   my $msg  = $_[1];
   my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = (localtime);
   $year = $year+1900;
   $mon = $mon+1;
   my $time =  "$year-$mon-$mday $hour:$min:$sec";
   
   print LOG "$time,$msg\n";
   	
   if ( $exit eq 'exit' ) {
      close LOG or die "Error closing $logFile: $!";
	  exit;
   }
}
###########################################################################

