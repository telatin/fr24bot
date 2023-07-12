use v5.12;
use warnings;
use Test::More;
use FindBin qw($RealBin);
use File::Temp qw/ :POSIX /;
use Data::Dumper;
use_ok('FR24::Bot');

my $flights = FR24::Bot::parse_flights('', 1);

# Function is working (will return a valid structure even if empty)
ok($flights->{"status"}, "Flights are defined");

# Got flights?
say STDERR Dumper $flights;
done_testing();