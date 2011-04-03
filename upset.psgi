#!/usr/bin/env perl
use strict;
use Plack::Builder;
use Plack::App::File;
use Upset::Container;

my $c      = Upset::Container->new;
my $logger = $c->resolve(type => 'Log::Dispatch');
my $app    = $c->resolve(type => 'Upset::App');

$app->establish_routes($c);

builder {
    enable 'LogDispatch', logger => $logger;
    enable 'XSendfile';
    enable 'Session';
    enable "Static" => (
        path => qr{^/static/}, 
        root => 'share',
    );
    mount  '/favicon.ico' => Plack::App::File->new(file => 'share/favicon.ico');

    enable '+Upset::App::Remap';
    mount '/' => $app;
};
