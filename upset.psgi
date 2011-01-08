#!/usr/bin/env perl
use strict;
use Plack::Builder;
use Plack::App::File;
use Upset::Container;

my $c   = Upset::Container->new;
my $app = $c->resolve(type => 'Upset::App');

$app->establish_routes($c);

builder {
    enable "Plack::Middleware::XSendfile";
    mount "/favicon.ico" => Plack::App::File->new(file => 'share/favicon.ico');
    enable "Plack::Middleware::Static" => (
        path => qr{^/static/}, 
        root => 'share',
    );
    mount '/' => $app;
};
