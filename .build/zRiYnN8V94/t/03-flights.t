use v5.12;
use warnings;
use Test::More;
use FindBin qw($RealBin);
use File::Temp qw/ :POSIX /;

use_ok('FR24::Bot');

my $flights = FR24::Bot::parse_flights('', 1);
ok($flights, "Flights are defined");
done_testing();