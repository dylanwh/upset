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

{
    my $bucket = Upset::Schema::Schedule::Bucket->new(
        spanset => do {
            use DateTime;
            use DateTime::Duration;
            use DateTime::Span;
            use DateTime::SpanSet;
            use DateTime::Event::Recurrence;

            # third wednesday of every month
            my $set = DateTime::Event::Recurrence->monthly(
                weeks => 3,
                days  => 3,
            )->map( sub { $_->clone->set( hour => 18 ) } );
            my $duration = DateTime::Duration->new( hours => 2 );

            DateTime::SpanSet->from_set_and_duration(
                set => $set,
                duration => $duration
            );
        },
    );
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
        name    => 'pinellas',
        location    => 'N/A',
        topic       => 'event2',
        description => '',
        span        => DateTime::Span->from_datetime_and_duration(
            start    => DateTime->now - DateTime::Duration->new( days => 1 ),
            duration => DateTime::Duration->new( hours                => 2 ),
        ),
    );
    my $event3 = Upset::Schema::Schedule::Event->new(
        name    => 'pinellas',
        location    => 'event 3 location',
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

    is  ($bucket->next_event(DateTime->now), $event);
    is  ($bucket->next_event(DateTime->now + DateTime::Duration->new(hours => 2)), $event);
    is  ($bucket->next_event(DateTime->now + DateTime::Duration->new(hours => 5)), $event3);
    isnt($bucket->next_event(DateTime->now + DateTime::Duration->new(days => 7)), $event3);
    isnt($bucket->next_event(DateTime->now + DateTime::Duration->new(days => 7)), undef);
    is(
        $bucket->next_event(DateTime->now +  DateTime::Duration->new(days => 7))->location,
        'event 3 location',
    );
};

done_testing;

