package Upset;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Authentication
    Authorization::Roles
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

Upset->config(
    name => 'Upset',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    default_view                                => 'TT',
);

Upset->setup();

1;
