#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Plack::Response;

my %remap = (
    '/history.php'  => '/page/history.html',
    '/index.php'    => '/',
    '/jobpost.php'  => '/jobs/publish',
    '/jobs.php'     => '/jobs',
    '/join.php'     => '/join',
    '/lists.php'    => '/page/lists.html',
    '/meetings.php' => '/meetings',
    '/treasury.php' => '/page/treasury.html',
);

my $app = sub {
    my $req = Plack::Request->new(shift);
    my $path = $req->path;

    if ($remap{$path}) {
        my $resp = $req->new_response(302);
        $resp->location($remap{$path});
        return $resp->finalize;
    }
    else {
        my $resp = $req->new_response(302);
        $path =~ s/\.php$/.html/g;
        $resp->location("/page$path");
        return $resp->finalize;
    }
}
