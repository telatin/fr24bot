#ABSTRACT: Subroutines for FR24-Bot
use v5.12;
use warnings;
package FR24::Bot;

our $VERSION = "0.0.1";
use JSON::PP;
use Exporter qw(import);
# Export version
our @EXPORT = qw($VERSION);
our @EXPORT_OK = qw(loadconfig saveconfig url_exists parse_flights);

sub parse_flights {
    my ($json_text, $test) = @_;
    $json_text = '{"4067ef":["4067ef",0,0,0,37000,0,"0000",0,"","",1689143713,"","","",false,0,""],"4bb28f":["4bb28f",0,0,96.47746,19450,460,"4730",0,"","",1689143721,"","","",false,2240,""],"4cac55":["4cac55",0,0,0,34175,488,"3416",0,"","",1689143721,"","","",false,960,""],"3c5eee":["3c5eee",0,0,0,11775,0,"0000",0,"","",1689143665,"","","",false,0,""],"4ca848":["4ca848",51.35,1.024,90.472534,26025,482,"0572",0,"","",1689143719,"","","",false,-992,"RYR60UD"],"40775c":["40775c",53.42,-1.145,101.46763,23475,429,"3426",0,"","",1689143722,"","","",false,2112,"RUK72VQ"],"406d4e":["406d4e",0,0,123.77186,16475,388,"6226",0,"","",1689143698,"","","",false,-1472,""],"485789":["485789",51.94,0.9666,64.76496,38275,539,"6250",0,"","",1689143721,"","","",false,-1216,"KLM702"],"4d21ee":["4d21ee",51.99,1.463,65.96107,25875,464,"3460",0,"","",1689143712,"","","",false,2176,"RYR8YJ"],"4070e1":["4070e1",53.92,-1.082,139.22684,30100,478,"3446",0,"","",1689143721,"","","",false,2304,"EXS15RF"],"4791a0":["4791a0",51.94,1.264,73.30076,39225,512,"6241",0,"","",1689143722,"","","",false,640,"MDT12"],"4ca640":["4ca640",53.23,-0.6868,96.604836,34975,478,"4646",0,"","",1689143719,"","","",false,-64,"EIN3JE"],"4cadf4":["4cadf4",53.9,-0.5286,119.27368,37000,482,"3451",0,"","",1689143721,"","","",false,0,"RYR2BQ"],"406d90":["406d90",0,0,0,21000,0,"3423",0,"","",1689143706,"","","",false,0,""],"4079f7":["4079f7",51.7,0.9323,263.7267,15700,276,"4632",0,"","",1689143707,"","","",false,-1536,"BAW811"],"4019f0":["4019f0",0,0,0,2300,0,"7000",0,"","",1689143721,"","","",false,0,""],"4076b1":["4076b1",52.36,0.4034,92.24087,32300,500,"4740",0,"","",1689143712,"","","",false,1184,"TOM15H"],"4ca621":["4ca621",52.32,0.2067,100.06673,26950,451,"4653",0,"","",1689143722,"","","",false,1728,"RYR9YY"],"40769a":["40769a",52.24,1.311,99.09946,32450,500,"4741",0,"","",1689143722,"","","",false,896,"TOM11K"],"3c6753":["3c6753",53.29,0.1518,279.62204,36000,413,"2544",0,"","",1689143722,"","","",false,0,"DLH7MF"],"40756e":["40756e",53.2,-0.1399,103.48089,25050,450,"6342",0,"","",1689143722,"","","",false,0,"EZY42PG"],"aaf968":["aaf968",53,1.002,96.21782,36950,518,"6315",0,"","",1689143721,"","","",false,-2560,"DAL258"],"40799b":["40799b",0,0,0,37700,0,"4447",0,"","",1689143719,"","","",false,0,""],"471f35":["471f35",0,0,276.65442,13275,241,"6605",0,"","",1689143689,"","","",false,-64,"WZZ1154"],"485e30":["485e30",53.01,0.8713,110.196785,34850,503,"6251",0,"","",1689143722,"","","",false,-1344,"KLM602"],"ab4c1d":["ab4c1d",52.77,1.862,85.17478,27300,462,"6330",0,"","",1689143672,"","","",false,-960,"DAL48"],"3c6708":["3c6708",53.21,0.913,110.19787,43000,524,"2027",0,"","",1689143717,"","","",false,0,"DLH481"],"a4ffb7":["a4ffb7",0,0,98.704956,26850,420,"6312",0,"","",1689143674,"","","",false,-960,"DAL56"]}' if defined $test;
    my $answer = {
        'status' => 'UNKNOWN',
        'total' => 0,
        'data' => {},
        'raw' => {},
    };

    if (length($json_text) == 0) {
        return $answer;
    }

    my $json = JSON::PP->new->utf8->pretty->canonical;
    my $json_data;
    eval {
        $json_data = $json->decode($json_text);
    };
    if ($@) {
        $answer->{'status'} = 'JSON_ERROR';
        return $answer;
    }

    $answer->{'status'} = 'OK';
    $answer->{'total'} = scalar keys %{$json_data} if defined $json_data;
    
    if (not defined $json_data) {
        return $answer;
    }
    for my $flight (sort keys %{$json_data}) {

       my $info = $json_data->{$flight};
       my $flight_hash = {
            'lat'  => 0 + $info->[1],
            'long' => 0 +$info->[2],
            'alt'  => 0 + $info->[4],
            'callsign' => $info->[16],
       };
       $answer->{'data'}->{$flight} = $flight_hash;
       $answer->{'raw'}->{$flight} = $info;
    }
    return $answer;
}


sub loadconfig {
    my $filename = shift;
    if (! -e "$filename") {
        return {};
    }
    open my $fh, '<', $filename or Carp::croak "Can't open $filename: $!";
    my $config = {
        'server' => { 
            'ip' => 'localhost',
        }
    };
    $config = {};
    my $section = "default";
    while (my $line = readline($fh)) {
        chomp $line;
        
        # Skip comment lines
        
        next if $line =~ /^#/;
        if ($line =~ /^\[(.*)\]$/) {
            $config->{lc("$1")} = {};
            $section = lc("$1");
            next;
        } elsif ($line =~/=/) {
            my ($key, $value) = split /=/, $line;
            $config->{"$section"}->{lc("$key")} = $value;
        }
        
    }
    return $config;
}

sub saveconfig {
    my ($filename, $config) = @_;
    open my $fh, '>', $filename or Carp::croak "Can't open $filename: $!";

    foreach my $section (keys %$config) {
        print $fh "[$section]\n";
        foreach my $key (keys %{$config->{$section}}) {
            my $value = $config->{$section}->{$key};
            print $fh "$key=$value\n";
        }
        print $fh "\n";
    }
    
    close $fh;
}

sub url_exists {
    my ($url) = @_;

    # Create an HTTP::Tiny object
    my $http = HTTP::Tiny->new;

    # Send a HEAD request to check the URL
    my $response = $http->head($url);
    
    # If the response status is success (2xx), the URL exists
    if ($response->{success}) {
        return 1;
    } elsif ($response->{status} == 599) {
        # Try anothe method: SSLeay 1.49 or higher required
        
        eval {
            require LWP::UserAgent;
            my $ua = LWP::UserAgent->new;
            $ua->ssl_opts(verify_hostname => 0);  # Disable SSL verification (optional)
            my $response = $ua->get($url);
            
            if ($response->is_success) {
                return 1;
            } else {
                return 0;
            }
        };
        if ($@) {
            my $cmd = qq(curl --silent -L -I $url);
            my @output = `$cmd`;
            for my $line (@output) {
                chomp $line;
                if ($line =~ /^HTTP/ and $line =~ /200/) {
                    return 1;
                }
            }
        }

    } else {
        return 0;
    }
}
1;
