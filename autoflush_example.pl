    use 5.010;
    use strict;
    use warnings;
     
    my $filename = 'data.txt';
    my $autoflush = shift;
     
    open my $fh, '>', $filename or die;
    say -s $filename; # 0
    
    # can just set autoflush in script when not needing a true / false on the command line
    $fh->autoflush
     
    if ($autoflush) {
        $fh->autoflush;
    }
     
    print $fh "Hello World\n";
    say -s $filename; # 12
     
    print $fh "Hello Back\n";
    say -s $filename; # 23
     
    close $fh;
    say -s $filename; # 23
     

By default a filehandle is buffered. In this example we use the autoflush method of the filehandle object to make it flush to the file automatically.

$ perl examples/autoflush.pl
0
0
0
23

$ perl examples/autoflush.pl 1
0
12
23
23
