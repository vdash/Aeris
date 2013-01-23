#!/usr/local/bin/perl
use warnings;
use WWW::Curl::Easy;
use XML::CSV;
use WWW::Curl::Form;

@timeData = localtime(time);

@months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
@weekDays = (00 .. 31);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
#$theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
my $date = "$year-$months[$month]-$weekDays[$dayOfMonth]";


my $curl = WWW::Curl::Easy->new;
my $user = "patrick";
my $pwd = "pmccoy123";
my $url = "http://slw001:8787/Orion/Login.aspx?ReturnUrl=%2fOrion%2fReport.aspx%3fReport%3dAvailability-Yesterday%26DataFormat%3dcsv&amp;Report=Availability-Yesterday&amp;DataFormat=csv";
#my $auth = "Basic " . MIME::Base64::encode( $user . ":" . $pass );

print "";
my $curlf = WWW::Curl::Form->new;
    $curlf->formadd("username",$user);
    $curlf->formadd("password", $pwd);

$curl->setopt(CURLOPT_HTTPPOST, $curlf); 
$curl->setopt(CURLOPT_HEADER, true);
$curl->setopt(CURLOPT_URL, $url);
#$curl->setopt(CURLOPT_POST, TRUE);
#$curl->setopt(CURLOPT_POSTFIELDS, $data);
$curl->setopt(CURLOPT_HTTPAUTH, CURLAUTH_ANY);
$curl->setopt(CURLOPT_VERIFYHOST, FALSE);
$curl->setopt(CURLOPT_VERIFYPEER, FALSE);
#$curl->setopt(CURLOPT_USERPWD,"$user:$pwd");
$curl->setopt(CURLOPT_RETURNTRANSFER, 1);

        # A filehandle, reference to a scalar or reference to a typeglob can be used here.
my $response_body;
$curl->setopt(CURLOPT_WRITEDATA,\$response_body);

        # Starts the actual request
my $retcode = $curl->perform;

        # Looking at the results...
if ($retcode == 0) {
    print("Transfer went ok\n");
  my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
                # judge result and next action based on $response_code
   print("Received response: $response_body\n");
} else {
                #Error code, type of error, error message
   print("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
}

#my $csv_obj = XML::CSV-new();

#$filepath="/tmp/kpi/hw/$date.csv";
#open(CSV, ">$filepath") || die "Can't open file: $!\n";

#printf CSV $response_body;
#close(CSV);
$done = "done\n\n";
print $done;
