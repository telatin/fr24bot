use v5.12;
use warnings;
use Test::More;
use FindBin qw($RealBin);
# Skip under windows
if ($^O =~ /Win32/) {
    plan skip_all => "Test not supported under Windows";
    exit;
}
my $perl = $^X;
# Set DEBUG variable
$ENV{PHOTOBEAR_DEBUG} = 1;
$ENV{PHOTOBEAR_TEST} = 1;
$ENV{PHOTOBEAR_API_KEY} = "C0FFEE-C0FFEE-C0FFEE-C0FFEE";
my $system_temp = $ENV{TEMP} || $ENV{TMP} || '/tmp';
my $cmd = "$perl -Ilib bin/config-fr24-bot -c $RealBin/config.ini -a default -i 127.0.0.1 --no-write";
my $out = `$cmd`;
ok(defined $?, "Command executed: $cmd [$?]");
ok($out =~/127\.0\.0\.1/, "IP is set to 127.0.0.1");


done_testing();