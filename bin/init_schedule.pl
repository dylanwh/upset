#!/usr/bin/env perl
use strict;
use warnings;
use Upset;
use Plack::Builder;
use Plack::App::File;

use Upset::Container;

my $c      = Upset::Container->new( 
    template_path => ['share/template', 'share/template/include'],
    form_path => 'share/forms',
);

my $model = $c->resolve(type => 'Upset::Model');
my $scope = $model->new_scope;
my $schedule = $model->schedule;

$schedule->bucket(
    pinellas => Upset::Schema::Schedule::Bucket->new(
        events => [
            Upset::Schema::Schedule::Event->new(
                name     => 'pinellas',
                title    => 'Pinellas Unix People',
                location => join( "\n",
                    'Pinellas Park Public Library',
                    '7770 52nd Street North',
                    'Pinellas Park, FL 33781',
                ),
                span => DateTime::Span->from_datetime_and_duration(
                    start => DateTime->new(
                        year   => 2010,
                        month  => 7,
                        day    => 21,
                        hour   => 18,
                        minute => 0,
                    ),
                    duration => DateTime::Duration->new( hours => 2 ),
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
                set      => $set,
                duration => $duration
            );
        },
    ),
);

$schedule->bucket(
    tampa => Upset::Schema::Schedule::Bucket->new(
        events => [
            Upset::Schema::Schedule::Event->new(
                name     => 'tampa',
                location => join( "\n",
                    'Hillsborough Community College',
                    'Dale Mabry Campus',
                    'Technology Bldg, Rm 409',
                    '4001 Tampa Bay Blvd',
                    'Tampa, FL',
                ),
                span => DateTime::Span->from_datetime_and_duration(
                    start => DateTime->new(
                        year   => 2010,
                        month  => 7,
                        day    => 14,
                        hour   => 19,
                        minute => 0,
                    ),
                    duration => DateTime::Duration->new( hours => 2 ),
                ),

            ),
        ],
        spanset => do {
            use DateTime;
            use DateTime::Duration;
            use DateTime::Span;
            use DateTime::SpanSet;
            use DateTime::Event::Recurrence;

            # second thursday of every month
            my $set = DateTime::Event::Recurrence->monthly(
                weeks => 2,
                days  => 4,
            )->map( sub { $_->clone->set( hour => 19 ) } );
            my $duration = DateTime::Duration->new( hours => 2 );

            DateTime::SpanSet->from_set_and_duration(
                set      => $set,
                duration => $duration
            );
        },
    ),
);

$model->store($schedule);
