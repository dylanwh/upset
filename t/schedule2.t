#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'Upset::Schema::Schedule';
use ok 'Upset::Schema::Schedule::Event';
use ok 'Upset::Schema::Schedule::Bucket';

my $schedule = Upset::Schema::Schedule->new;

$schedule->bucket(
    pinellas => Upset::Schema::Schedule::Bucket->new(
        events => [
            Upset::Schema::Schedule::Event->new(
                name => 'pinellas',
                location => 'pinellas park library',
                span => DateTime::Span->from_datetimes(
                    start => DateTime->new(year => 1970),
                    end   => DateTime->new(year => 1970),
                ),
            ),
        ],
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
    ),
);

$schedule->bucket(
    tampa => Upset::Schema::Schedule::Bucket->new(
        events => [
            Upset::Schema::Schedule::Event->new(
                name => 'tampa',
                location => 'HCC',
                span => DateTime::Span->from_datetimes(
                    start => DateTime->new(year => 1970),
                    end   => DateTime->new(year => 1970),
                ),
            ),
        ],
        spanset => do {
            use DateTime;
            use DateTime::Duration;
            use DateTime::Span;
            use DateTime::SpanSet;
            use DateTime::Event::Recurrence;

            # third wednesday of every month
            my $set = DateTime::Event::Recurrence->monthly(
                weeks => 2,
                days  => 4,
            )->map( sub { $_->clone->set( hour => 19 ) } );
            my $duration = DateTime::Duration->new( hours => 2 );

            DateTime::SpanSet->from_set_and_duration(
                set => $set,
                duration => $duration
            );
        },
    ),
);

{
    my $now = DateTime->new( year => 2011, day => 7, month => 1 );

    my @events = $schedule->next_events($now);
    ok(@events == 2, "two events");
    my @days = map { $_->span->start->day_name } @events;
    is_deeply([qw[ Thursday Wednesday ]], \@days);
    is($events[1]->span->start->hour, 18);
}

{
    my $now = DateTime->new( year => 2011, day => 15, month => 1 );

    my @events = $schedule->next_events($now);
    ok(@events == 2, "two events");
    my @days = map { $_->span->start->day_name } @events;
    is_deeply([qw[ Wednesday Thursday  ]], \@days);
    is($events[0]->span->start->month, 1, "second meeting is this month");
    is($events[1]->span->start->month, 2, "second meeting is next month");
    is($events[0]->span->start->hour, 18);

    $schedule->add_event(
        $schedule->bucket('pinellas')->next_event($now)->clone( topic => 'perl' ),
    );

    @events = $schedule->next_events($now);
    is($events[0]->topic, "perl");

    # however, the next pinellas meeting after the tampa meeting is not about perl.
    my $event = $schedule->bucket('pinellas')->next_event($events[1]->span->start);
    isnt($event->topic, "perl");
}


done_testing;
