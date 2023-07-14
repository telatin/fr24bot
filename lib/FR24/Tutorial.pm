#ABSTRACT: A module to explain how to use FR24::Bot
package FR24::Tutorial;

use strict;
use warnings;


=head1 DESCRIPTION

This modules comes with some utilities to run a B<Telegram Bot> 
that interacts with flight data your the B<Flightradar24 antenna>.

It can be installed in the same devide (usually a Raspberry Pi) 
where the Flightradar24 antenna is running, or in another server
which is able to connect to the Flightradar24 antenna webpage. 
For this reason, it mostly parses data from the webserver, but 
it has been mostly tested in the same device.

=head2 Installing the Module

Use CPAN or cpanm to install the module:

    cpanm FR24::Bot


=head2 Setting Up the Module

You will need a configuration file to run the bot. The default location is:

    ~/.config/fr24-bot.ini

The configuration file is an INI file with the following sections:

    [telegram]
    apikey=7908487915:AEEQFftvQtEbavBGcB81iF1cF2koliWFxJE

    [server]
    port=8080
    ip=localhost

    [users]
    everyone=1


To create it you can run the following command:

    config-fr24-bot [-a API_KEY] [-i IP] [-p PORT]

If you don't specify the C<-a> option or the C<-i> options,
the script will ask you to provide them interactively.


=head2 Running the Bot

The main program is C<fr24bot>. You can run it with the following options:

    fr24-bot [-a API_KEY] [-i IP] [-p PORT] [-c CONFIG_FILE] [-v] [-d]


=cut

1;
__END__
