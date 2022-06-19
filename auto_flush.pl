use strict;
use warnings;
 
my $filename = 'data.txt';
my $autoflush = shift;
 
open my $fh, '>', $filename or die;
say -s $filename; # 0

# if true - i.e. 1 as the argument on command line
# if script requires autoflush - don't bother with the if true for autoflush
# just $fh->autoflush

if ($autoflush) {
    $fh->autoflush;
}
 
print $fh "Hello World\n";
say -s $filename; # 12
 
print $fh "Hello Back\n";
say -s $filename; # 23
 
close $fh;
say -s $filename; # 23

# no autoflush

$ perl examples/autoflush.pl
0
0
0
23

# autoflush

$ perl examples/autoflush.pl 1
0
12
23
23
