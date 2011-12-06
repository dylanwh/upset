#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Upset;
use Plack::Builder;
use Plack::App::File;

use Upset::Container;

chdir "$FindBin::Bin/..";

my $c = Upset::Container->new;

my $model    = $c->resolve( type => 'Upset::Model' );
my $scope    = $model->new_scope;
my $schedule = $model->schedule;

my @events = $schedule->next_events( @ARGV ? DateTime->from_epoch(epoch => shift) : DateTime->now);

print <<HEAD;
==================================================
Suncoast Linux Users Group (SLUG) Meeting Schedule
==================================================

HEAD

my $stars = 58;
for my $event (@events) {
    my $name = uc $event->name;
    print "$name ", "*" x ($stars - (length($name)+1)), "\n";
    print "(", $event->title, ")\n" if $event->has_title;
    print "\n";
    
    my $start = $event->span->start;
    my $end = $event->span->end;
    printf("    %s, %s %s, %d @ %s - %s\n\n",
        $start->day_name,
        $start->month_name,
        $start->day,
        $start->year,
        $start->hms,
        $end->hms,
    );

    if ($event->has_topic) {
        print "    Topic: ", $event->topic, "\n";
        print "\n";
    }

    if ($event->has_content) {
        print "    $_\n" for split(/\n/, $event->content);
        print "\n";
    }

    print "    Location:\n";
    print "        $_\n" for split(/\n/, $event->location);
    print "\n";
}


=head1 NAME

schedule.pl


