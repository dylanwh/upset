#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'Upset::Model';
use ok 'Upset::Schema::Member';
use ok 'Upset::Schema::Job';

my $model = Upset::Model->new(dsn => 'hash');
my $scope = $model->new_scope;

$model->init;

$model->add_member(
    Upset::Schema::Member->new(
        name              => 'Dylan William Hardison',
        email             => 'dylan@hardison.net',
        subscription_pref => 'SubscribeMain',
        meeting_location  => 'Pinellas',
        distribution      => 'Ubuntu',
    ),
);

$model->add_job(
    Upset::Schema::Job->new(
        title            => 'Software Developer',
        description      => 'write software for dylan for free',
        long_description => 'looking for slave developer.',
        requirements     => 'insane',
        contact          => 'Dylan William Hardison',
        contact_email    => 'dylan@hardison.net',
        contact_phone    => '(555) 555-5555',
    )
);

is_deeply([ map { $_->name } $model->members->elements  ], ['Dylan William Hardison']);
is_deeply([ map { $_->title } $model->jobs->elements  ], ['Software Developer']);



done_testing;

