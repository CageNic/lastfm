# send the track contents of mplayer output to file
# perl mplayer_perl.pl A or B or C or D or E

# adding stdbuf grep and file redirect to system call in subroutine
# this sends STDOUT of these grepped lines to file
# IO::Tee can send it to standard output and the file


# use IO:Tee;
# my $teelog = "tee.log"
# open my $tee, ">", $teelog or die "open tee failed.\n";
# $tee = new IO:Tee(\*STDOUT, $tee);
# print $tee "First line in log\n";

# system("date | tee -a ${teelog}");
# system("jibberish 2>&1 | tee -a ${teelog}");

# open $tee, ">>", $teelog or die "open tee failed.\n";  # append mode
# $tee = new IO:Tee(\*STDOUT, $tee);

# streams to add to hash and help menu
# http://streams.deltaradio.de/100/aac-64
# http://streams.deltaradio.de/101/aac-64
# http://streams.deltaradio.de/delta-alternative/aac-64
# http://streams.deltaradio.de/delta-poprock/aac-64
# http://streams.deltaradio.de/delta-foehnfrisur/aac-64
# http://streams.deltaradio.de/delta-live/aac-64
# http://streams.deltaradio.de/delta-sommer/aac-64




#!/usr/bin/perl
use strict;
use warnings;

my %hash = (
            'A' => "http://live.argyllfm.com/stream6?ref=RF.m3u",
            'B' => "http://streams.deltaradio.de/delta-grunge/aac-64",
            'C' => "http://streams.deltaradio.de/delta-unplugged/aac-64",
            'D' => "http://streams.deltaradio.de/delta-indie/aac-64"
           );

my $log_file = 'tracks.txt';
my $chan = shift || help();

if ($chan eq 'A') {
  radio($hash{A});
  }
  elsif ($chan eq 'B') {
    radio($hash{B});
  }
  elsif ($chan eq 'C') {
    radio($hash{C});;
  }
  elsif ($chan eq 'D') {
    radio($hash{D});
  }
  elsif ($chan =~ m/xxxx/) {
    radio();
  }
  else { help(); };

sub radio {
 my $url = shift @_;
 system("mplayer $url | stdbuf -o L grep 'ICY' >> 'tracks.txt'");
}
 
sub help {
print "Usage: mplayer_perl.pl <channel>" , "\n";
print "Channels: " , "\n";
print "A - Argyll.FM\n";
print "B - Delta Grunge\n";
print "C - Delta Unplugged\n";
print "D - Delta Indie\n";
print "xxxx - something else\n";
}
