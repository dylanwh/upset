#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use Upset::Container;
my $c = Upset::Container->new(template_path => ['share/template'], form_path => 'share/forms');

my $join = $c->resolve(type => 'Upset::Adapter::Join');
is($join->name, "Join");



done_testing;

