use v5.12;
use warnings;
use Test::More;
use FindBin qw($RealBin);

use_ok('FR24::Bot');
my $conf_api = '7908487915:AEEQFftvQtEbavBGcB81iF1cF2koliWFxJE';
my $conf_ip = 'localhost';

my $conf = FR24::Bot::loadconfig("$RealBin/config.ini");
ok($conf->{"telegram"}->{"apikey"}, "API key is set");
ok($conf->{"telegram"}->{"apikey"} eq $conf_api, "API key is correct: $conf_api");

ok($conf->{"server"}->{"ip"}, "IP is set");
ok($conf->{"server"}->{"ip"} eq $conf_ip, "IP is correct: $conf_ip");

ok(not defined $conf->{"other"}->{"debug"}, "Debug is NOT set");
done_testing();