#!perl
use strict;
use warnings;
use Plack::Util;

my $remap = Plack::Util::load_psgi("remap.psgi");
my $upset = Plack::Util::load_psgi("upset.psgi");

my $app = sub {
    my $env = shift;
    if ( $env->{PATH_INFO} =~ /\.php/ ) {
        return $remap->($env);
    }
    else {
        return $upset->($env);
    }
};
