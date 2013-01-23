use Carp;
use Email::MIME;
use File::Basename;
use Net::POP3;

my $server         = "mailhost.aeris.net";
my $receiveruname  = "pm";
my $password       = "M\$6\#r0y";
my $attachment_dir = "/root/mail/";

my $pop = Net::POP3->new($server);
die "Couldn't connect to the server.\n\n" unless $pop;
my $num_messages = $pop->login( $receiveruname, $password );
die "No messages" if ($num_message eq "0E0");
die "Connection trouble network password user ..."
    unless defined $num_messages;
print $num_messages;

for my $i ( 1 .. $num_messages ) {
    print "$i";
    my $aref = $pop->get($i);
    my $em = Email::MIME->new( join '', @$aref );
    for ( my @parts = $em->parts ) {
	print $_->content_type, "\n";
	next unless $_->content_type =~ m(^application/octet-stream)i;
	my $filename = basename( $_->filename || '' );
	my $basefilename = $filename || 'UNNAMED';
	my $cnt = 0;
	while ( -e "$attachment_dir/$filename" ) {
	    my ( $d, $m, $y ) = (localtime)[ 3 .. 5 ];
      $filename = sprintf( "%s_%04d%02d%02d_%04d",
                           $basefilename, $y + 1900, $m + 1, $d, ++$cnt );
	
	    print "did it";
	}
	open my $fh, ">", "$attachment_dir/$filename" or die $!;
	binmode $fh;
	print $fh $_->body;
	$pop->delete($i);
    }
}
$pop->quit;
