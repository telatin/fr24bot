use v5.12;
use warnings;
use Test::More;
use FindBin qw($RealBin);
use File::Temp qw/ :POSIX /;
use Data::Dumper;
use_ok('FR24::Bot');

my $flights = FR24::Bot::parse_flights('', 1);

# Function is working (will return a valid structure even if empty)
ok($flights, "Function is working");
ok($flights->{"status"}, "Got status");
ok($flights->{"status"} eq "OK", "Got status: OK " . $flights->{"status"}); 
ok($flights->{"total"} == 28, "Got expected flights: 28==" . $flights->{"total"});

# Specific flight?
my $id = "3c6708";
my $callsign = "DLH481";
my $flight = $flights->{"data"}->{$id};
ok($flight, "Got flight $id");
say Dumper $flight;
ok($flight->{"callsign"} eq $callsign, "Got expected callsign: $callsign==" . $flight->{"callsign"});
done_testing();

__DATA__
{
  "3c6708": [
    "3c6708", 
    53.21,
    0.913,
    110.556046,
    43000,
    521,
    "2027",
    0,
    "",
    "",
    1689143761,
    "",
    "",
    "",
    false,
    0,
    "DLH481"
  ],
...