#!/usr/local/bin/perl
@timeData = localtime(time);

@months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
@weekDays = (00 .. 31);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
my $myTime = "$year-$months[$month]-$weekDays[$dayOfMonth]";
print $weekDays;
print $myTime;
