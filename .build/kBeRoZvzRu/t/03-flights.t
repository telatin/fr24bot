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


done_testing();