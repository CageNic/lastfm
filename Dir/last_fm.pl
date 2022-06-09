################################################
# script to push data to lastfm from text file #
################################################

# CPAN modules are declared in pm file (csv_grab module)
# csv_grab module loads CPAN modules and uses a subroutine that creates an array of hashes from text file

#!/usr/bin/perl
use strict;
use warnings;
use lib '.'; # module and script in same directory
use csv_grab ':all';


pp capture_csv('test_send_me_to_a_sub.csv');

my $aoh = capture_csv('test_send_me_to_a_sub.csv');

print ref $aoh , "\n";

# no need for api keys - not a web app
# standard password will suffice

my $config_file = "$ENV{HOME}/.lastfm.cnf";
die "$config_file not there" unless -e $config_file;

my $config = Config::Tiny->read($config_file);
my $user     = $config->{lastfm}->{user};
my $password = $config->{lastfm}->{password};

my $submit = Net::LastFM::Submission->new(
	    user      => $user,
	    password  => $password,
);

$submit->handshake;

# submit list

$submit->submit(
    artist => 'Big Country',
    title  => 'Chance',
    time   => time - 10*60, # 10 minutes ago
);
# submit hashref (treated as array of hashes)

# $submit->submit(
 #    {
 #        artist => 'Freddie Mercury',
 #        title  => 'Love Kills',
 #        time   => time - 20*60,
 #    },
 #    {
 #        artist => 'The Clash',
 #        title  => 'London Calling',
 #        time   => time - 10*60,
 #    }
 
######################################################
# loop over array of hashes from csv_grab / csv file #
# get at inner hash reference to submit              #
######################################################

 # submit the array of hashes created by subroutine from csv_grab module 
 for (@{$aoh}) {
   print ref $_ , "\n";
   print join ( " => " , %{$_} )  , "\n";
   $submit->submit($_);
   }

# submit(%args)
# 
# Submission of full track data at the end of the track for statistical purposes. See http://www.lastfm.ru/api/submissions#subs.
# 
# It takes list of parameters (information about one track) or list of hashref parameters (limit of Last.FM is 50).
# 
# # list
# $submit->submit(
#     artist => 'Artist name',
#     title  => 'Track title',
# );
# 
# # hashref
# $submit->submit(
#     {
#         artist => 'Artist name 1',
#         title  => 'Track title 1',
#         time   => time - 10*60,
#     },
#     {
#         artist => 'Artist name 2',
#         title  => 'Track title 2',
#     }
# );
# 
# This is a list of support parameters:
#     artist
#     The artist name. Required.
#     title
#     The track name. Required.
#     time
#     The time the track started playing, in UNIX timestamp format. Optional. Default value is current time.
#     source
#     The source of the track. Optional. Default value is R.
#     rating
#     A single character denoting the rating of the track. Empty if not applicable.
#     length
#     The length of the track in seconds. Required when the source is P, optional otherwise.
#     album
#     The album title, or an empty string if not known.
#     id
#     The position of the track on the album, or an empty string if not known.
#     mb_id
#     The MusicBrainz Track ID, or an empty string if not known.
#     enc
#     The encoding of the data, the module tries to encode the data (artist/title/album) unless the data is UTF-8. Optional.
# If the submit is successful, the returned hashref should be the following format:
# {
#     'status' => 'OK',
# }
# Else:
# {
#     'error'  => 'ERROR/BADSESSION/FAILED',
#     'code'   => '200/500', # code of status line response
#     'reason' => '...'      # reason of error
# }
# FUNCTIONS
# encode_data($data, $enc)
# Function tries encode $data from $enc to UTF-8 and remove BOM-symbol. See Encode.
# use Net::LastFM::Submission 'encode_data';
# encode_data('foo bar in cp1251', 'cp1251');
# Encoding of all data for Last.fm must be UTF-8.
# GENERATE REQUESTS AND PARSE RESPONSES
# Module can generate a requests for handshake, now playing and submit operations. These methods return HTTP::Request instance. One request has support parameters same as method.
#     _request_handshake()
#     Generate GET request for handshake. See handshake() method.
#     _request_now_playing(%args)
#     Generate POST request for now playing. See now_playing(%args) method.
#     _request_submit(%args)
#     Generate POST request for submit. See submit(%args) method.
# Also module can parse a response (HTTP::Response instance) of these requests.
# _response($response)
# my $request  = $self->_request_handshake; # generate request for handshake, return HTTP::Request instance
# my $response = send_request($request); # send this request, return HTTP::Response instance
# $self->_response($response); # parse this request
