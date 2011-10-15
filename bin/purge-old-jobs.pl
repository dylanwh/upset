#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Upset::Container;

my $c = Upset::Container->new;

my $model = $c->resolve( type => 'Upset::Model' );
my $scope = $model->new_scope;
my $live  = $model->live_objects;
my $jobs  = $model->jobs;

my $cutoff = DateTime->now->subtract(weeks => 4);
foreach my $job ($jobs->elements) {
    if ($job->timestamp < $cutoff) {
        $jobs->remove($job);
    }
}

$model->store($jobs);
