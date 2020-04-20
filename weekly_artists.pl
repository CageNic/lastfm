##########################
# last fm weekly artists #
##########################

# top 10 weekly artists to barchart
# barchart messy if any more than 10
# not using Last FM cpan module

#!/usr/bin/perl
use strict ;
use warnings ;
use LWP::UserAgent;
use JSON qw(decode);
use Config::Tiny;
use GD::Graph::bars;

my $config_file = "$ENV{HOME}/.lastfm.cnf";
die "$config_file not there" unless -e $config_file;

my $config = Config::Tiny->read($config_file);

my $user    = $config->{lastfm}->{user};
my $api_key = $config->{lastfm}->{api_key};
                  
my $base_url    = "http://ws.audioscrobbler.com/2.0";
my $method_url  = "user.getweeklyartistchart";
my $format      = "json";
my $user_passwd = "user=$user&api_key=$api_key&format=$format";

my $request_url = "$base_url/?method=$method_url&user=$user&api_key=$api_key&format=$format";

# send the request and decode json to perl data structure
# not too much held in memory - no need for content_reference
# or write to disk
my $ua        = LWP::UserAgent->new();
my $request   = $ua->get($request_url);
my $json      = $request->decoded_content;
my $perl_data = decode_json($json);

my (@artists, @playcounts);

# only need the top 10 weekly artists in barchart
my $x = 0;
DATA:
foreach my $thing ( @{$perl_data->{weeklyartistchart}->{artist} } ) {
$x++;
push (@artists,$thing->{'name'});
push (@playcounts,$thing->{'playcount'});
# exit when 10 are reached
last DATA if $x == 10;
}

# artists and playcounts to bar chart
# create the layout
my $data = GD::Graph::Data->new( [ \@artists,\@playcounts ] );
my $graph =  GD::Graph::bars->new();

$graph->set(
            x_label           => 'ARTISTS',
	    y_label           => 'PLAYCOUNT',
            x_labels_vertical => 1,
            bar_spacing       => 1,
            title   => 'Last FM scrobbled data',
           ) or die $graph->error;

$graph->plot($data) or die $graph->error;

# barchart to image file
my $file = 'LastFMTest.png';
open (my $picture,'>',$file) or die "Cannot open file $file $!";
binmode $picture;
print $picture $graph->gd->png;
close $picture;
exit;