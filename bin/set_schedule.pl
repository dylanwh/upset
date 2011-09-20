#!/usr/bin/env perl
use strict;
use warnings;
use Upset;
use Plack::Builder;
use Plack::App::File;

use DateTime;
use DateTime::Duration;
use DateTime::Span;
use DateTime::SpanSet;
use DateTime::Event::Recurrence;

use Upset::Container;

my $c = Upset::Container->new;

my $model    = $c->resolve(type => 'Upset::Model');
my $scope    = $model->new_scope;
my $schedule = $model->schedule;

my %template = (
    pinellas => {
        name     => 'pinellas',
        title    => 'Pinellas Unix People',
        location => join( "\n",
            'First Room',
            'Pinellas Park Public Library',
            '7770 52nd Street North',
            'Pinellas Park, FL 33781',
        ),
    },
    tampa => {
        name     => 'tampa',
        location => join( "\n",
            "HDR",
            "5426 Bay Center Drive",
            "Tampa, FL",
        ),
    }
);

my %span_set = (
    pinellas => (sub {
        # third wednesday of every month
        my $duration = DateTime::Duration->new( hours => 2 );
        my $set = DateTime::Event::Recurrence->monthly( 
            weeks => 3,
            days  => 3,
        )->map( sub { $_->clone->set( hour => 18 ) } );

        DateTime::SpanSet->from_set_and_duration(
            set      => $set,
            duration => $duration
        );
    })->(),
    tampa => do {
        # second wednesday of every month
        my $set = DateTime::Event::Recurrence->monthly(
            weeks => 2,
            days  => 3,
        )->map( sub { $_->clone->set( hour => 19 ) } );
        my $duration = DateTime::Duration->new( hours => 2 );

        DateTime::SpanSet->from_set_and_duration(
            set      => $set,
            duration => $duration
        );
    },
);

my $now = DateTime->now;
foreach my $name (keys %template) {
    my $event = Upset::Schema::Schedule::Event->new(
        %{ $template{$name} },
        span => $span_set{$name}->next($now),
    );
    $schedule->add_event( $event );
    my $span = $span_set{$name}->next($now);
    print "[$now] $name ", $span->start, "\n";
}



$model->store($schedule);
