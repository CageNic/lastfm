use strict;
use warnings;
package csv_grab;
use Data::Dump qw(pp);
use Carp qw(croak);
use Config::Tiny;
use Net::LastFM::Submission;

our $VERSION = 0.01;

use base 'Exporter';
our @EXPORT_OK = qw(capture_csv pp croak);
our %EXPORT_TAGS = ( all => \@EXPORT_OK);

sub capture_csv {
  my $file = shift;
  croak unless $file;
  my @array;
  open (my $fh,'<',$file);
  while (my $lines = <$fh>) {
    chomp $lines;
    $lines =~ s/ICY Info: StreamTitle=//;
    next if $lines =~ m/www.deltaradio.de/;
    $lines =~ s/'//g;
    $lines =~ s/;$//;
    
    my $arr = [split (/ - /,$lines)];
    
    my $hash = {
		'artist' => $arr->[0],
		'title'  => $arr->[1],
               };
    push ( @array , $hash );
}
close $fh;
return \@array;
} 

1;  
