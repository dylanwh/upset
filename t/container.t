#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'Upset::Container';
my $c = Upset::Container->new(include_path => ['pants']);
ok($c, "built");

my $adapter = $c->resolve(type => 'Upset::Adapter::Template');

is_deeply($adapter->template->include_path, ['pants']);



done_testing;

