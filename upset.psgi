#!/usr/bin/env perl
use strict;
use Upset;
use Plack::Builder;
use Plack::App::File;
use Plack::App::Path::Router;

use Upset::Router;
use Upset::Container;

my $c      = Upset::Container->new(include_path => ['share/template', 'share/template/include']);
my $router = Upset::Router->new;

$router->establish_routes( $c );

my $app = Plack::App::Path::Router->new( router => $router );

builder {
    enable "Plack::Middleware::XSendfile";
    mount "/favicon.ico" => Plack::App::File->new(file => 'share/favicon.ico');
    enable "Plack::Middleware::Static" => (
        path => qr{^/static/}, 
        root => 'share',
    );
    mount '/' => $app;
};
