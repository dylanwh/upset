#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use DateTime;
use DateTime::Duration;
use DateTime::Span;


use ok 'Upset::Schema::Schedule';
use ok 'Upset::Schema::Schedule::Event';

# without spansets
{
    my $bucket = Upset::Schema::Schedule::Bucket->new;
    my $event = Upset::Schema::Schedule::Event->new(
        name => 'pinellas',
        location    => 'N/A',
        topic       => 'event',
        description => '',
        span        => DateTime::Span->from_datetime_and_duration(
            start    => DateTime->now + DateTime::Duration->new( hours => 2 ),
            duration => DateTime::Duration->new( hours                 => 2 ),
        ),
    );
    my $event2 = Upset::Schema::Schedule::Event->new(
        name => 'pinellas',
        location    => 'N/A',
        topic       => 'event2',
        description => '',
        span        => DateTime::Span->from_datetime_and_duration(
            start    => DateTime->now - DateTime::Duration->new( days => 1 ),
            duration => DateTime::Duration->new( hours                => 2 ),
        ),
    );
    my $event3 = Upset::Schema::Schedule::Event->new(
        name => 'pinellas',
        location    => 'N/A',
        topic       => 'event3',
        description => '',
        span        => DateTime::Span->from_datetime_and_duration(
            start    => DateTime->now + DateTime::Duration->new( days => 2 ),
            duration => DateTime::Duration->new( hours                => 2 ),
        ),
    );

    $bucket->add_event($event);
    $bucket->add_event($event2);
    $bucket->add_event($event3);

    is($bucket->next_event(DateTime->now), $event);
    is($bucket->next_event(DateTime->now +  DateTime::Duration->new(hours => 2)), $event);
    is($bucket->next_event(DateTime->now +  DateTime::Duration->new(hours => 5)), $event3);
    is($bucket->next_event(DateTime->now +  DateTime::Duration->new(days => 7)), undef);
}

done_testing;
