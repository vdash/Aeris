use warnings;
use WWW::Curl::Easy;
use XML::CSV;

my $curl = WWW::Curl::Easy->new;
        
my $user = "monitor";
my $pwd = "0psmon0";



#!/usr/local/bin/perl
@timeData = localtime(time);

@months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
print $theTime;

$curl->setopt(CURLOPT_HEADER,1);
$curl->setopt(CURLOPT_URL, 'http://10.2.0.200/kpi/hw/exportall.php');
$curl->setopt(CURLOPT_GET, 1);
#$curl->setopt(CURLOPT_VERIFYHOST, 0);
#$curl->setopt(CURLOPT_VERIFYPEER, 0);
#$curl->setopt(CURLOPT_USERPWD,"$user:$pwd" );
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
                # Error code, type of error, error message
    print("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
}

my $csv_obj = XML::CSV-new();

