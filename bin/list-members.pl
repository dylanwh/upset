#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Upset::Container;
use YAML::XS;

my $c       = Upset::Container->new;
my $model   = $c->resolve( type => 'Upset::Model' );
my $scope   = $model->new_scope;
my $live    = $model->live_objects;
my $members = $model->members;

my $count = 0;
foreach my $member ( sort { $b->timestamp <=> $a->timestamp } $members->elements) {
    printf "%s <%s>\n", $member->name, $member->email;
    printf "    Date: %s\n", $member->timestamp->ymd;
    printf "    Homepage: %s\n", $member->homepage if $member->has_homepage;
    printf "    Distro: %s\n", $member->distribution if $member->has_distribution;
    printf "    Location: %s\n", $member->meeting_location if $member->has_meeting_location;
    printf "    Mailing List? %s | Announcements? %s\n",
        $member->mailing_list  ? 'Yes' : 'No',
        $member->announcements ? 'Yes' : 'No';
    if ( $member->has_comments && $member->comments) {
        printf "    Comments:\n%s\n", map { (' ' x 8) . $_ . "\n" } split(/\n/, $member->comments);
    }
    print "\n";
    $count++;
}
print "$count total\n";
