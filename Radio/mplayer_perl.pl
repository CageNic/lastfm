# send the track contents of mplayer output to file
# perl mplayer_perl.pl B | stdbuf -o L grep 'ICY' > tracks.txt
# buffering off autoflush on


#!/usr/bin/perl
use strict;
use warnings;
 
my $chan = shift || help();

if ($chan eq 'A') {
  radio("http://live.argyllfm.com/stream6?ref=RF.m3u");
  }
  elsif ($chan eq 'B') {
    radio("http://streams.deltaradio.de/delta-grunge/aac-64");
  }
  elsif ($chan =~ m/xxxx/) {
    radio();;
  }
  elsif ($chan =~ m/xxxx/) {
    radio();
  }
  elsif ($chan =~ m/xxxx/) {
    radio();
  }
  else { help(); }

sub radio {
 my ($url) = @_;
 system("mplayer $url");
}
 
sub help {
print "Usage: mplayer_perl.pl <channel>" , "\n";
print "Channels: " , "\n";
print "A - Argyll.FM\n";
print "B - Delta Grunge\n";
print "xxxx - something else\n";
print "xxxx - something else\n";
print "xxxx - something else\n";
}
