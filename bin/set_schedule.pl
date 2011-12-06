#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
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

$schedule->clear;

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
            "Suite 400 (4th floor)",
            "5426 Bay Center Drive",
            "Tampa, FL 33609",
            "After 7:00 PM you may need to call Cliff at 727-495-5981"
        ),
    },
    hack => { 
        name => 'Hacking Session',
        location => join("\n",
            "Panera Bread",
            "10801 Starkey Road",
            "Largo, Florida 33777",
        ),
        content => join("\n",
            "Definition: (2) hack [very common] ",
            "1. n. Originally, a quick job that produces what is needed, but not well. ",
            "2. n. An incredibly good, and perhaps very time-consuming, piece of work that produces exactly",
            "what is needed. ",
            "",
            "Come join your fellow geeks for an afternoon of social coding.",
        ),
    },
);

my %span_set = (
    pinellas => sub {
        # third wednesday of every month
        my $duration = DateTime::Duration->new( hours => 2 );
        my $set = DateTime::Event::Recurrence->monthly( 
            start => DateTime->new(year => 2011, month => 12, day => 21),
            week_start_day => '1mo',
            weeks => 3,
            days  => 3,
        )->map( sub { $_->clone->set( hour => 18 ) } );

        DateTime::SpanSet->from_set_and_duration(
            set      => $set,
            duration => $duration
        );
    },
    hack  => sub {
        my $duration = DateTime::Duration->new(hours => 3, minutes => 30);
        my $set = DateTime::Event::Recurrence->monthly(
            start => DateTime->new(year => 2011, month => 12, day => 10),
            week_start_day => '1mo',
            interval => 3,
            weeks => 1,
            days => 'sa',
        )->map( sub { $_->clone->set( hour => 13 ) } );

        DateTime::SpanSet->from_set_and_duration(
            set      => $set,
            duration => $duration
        );
    },
    tampa => sub {
        # second tuesday of every month
        my $set = DateTime::Event::Recurrence->monthly(
            start => DateTime->new(year => 2011, month => 12, day => 13),
            week_start_day => '1mo',
            weeks => 2,
            days  => 2,
        )->map( sub { $_->clone->set( hour => 19 ) } );
        my $duration = DateTime::Duration->new( hours => 2 );

        DateTime::SpanSet->from_set_and_duration(
            set      => $set,
            duration => $duration
        );
    },
);


foreach my $name (keys %template) {
    my $now = DateTime->now;
    for (1..3) {
        my $span  = $span_set{$name}->()->next($now);
        my $event = Upset::Schema::Schedule::Event->new(
            %{ $template{$name} },
            span => $span,
        );
        $schedule->add_event( $event );
        print "[$now] $name ", $span->start, "\n";

        $now = $span->end;
    }
}



$model->store($schedule);
