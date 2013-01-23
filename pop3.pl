#!/usr/local/bin/perl
use strict;
use warnings;
use diagnostics;
use Mail::POP3Client;
use MIME::Parser;

my $pop = new Mail::POP3Client(
                 USER     => "pm",
                 PASSWORD => "M\$6\#r0y",
                 HOST     => "mailhost.aeris.net"
    );

## for HeadAndBodyToFile() to use
my $fh = new IO::Handle();

## Initialize stuff for MIME::Parser;
my $outputdir = "/root/mail/";
my $parser = new MIME::Parser;
$parser->output_dir($outputdir);

my $i;
## process all messages in pop3 inbox
for ($i = 1; $i <= $pop->Count(); $i++) {
    open (MAILOUT, ">pop3.msg$i");
    $fh->fdopen( fileno( MAILOUT ), "w" );
   ## write current msg to file
    $pop->HeadAndBodyToFile( $fh, $i );
    close MAILOUT;
   ## MIME::Parser handles only one msg at-a-time
    open (MAILIN, "<pop3.msg$i");
   ## flush all attachments this msg to ./mimemail dir using internal filename
    my $entity = $parser->read(\*MAILIN);
    close MAILIN;
}
