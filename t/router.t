#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN {
    package Upset::Adapter::Test;
    use Moose;
    extends 'Upset::Adapter';
}

use ok 'Upset::Router';

my $r = Upset::Router->new;

$r->add_route('/',
    target => Upset::Adapter::Test->new,
);
$r->add_route('/foo/:bar',
    target => Upset::Adapter::Test->new,
);

is($r->uri_for('Test'), '');
is($r->uri_for('Test', bar => "pants"), "foo/pants");


done_testing;

