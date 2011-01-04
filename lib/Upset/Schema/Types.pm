package Upset::Schema::Types;
use MooseX::Types -declare => [qw[
    Member
    Job
    Distribution
    MeetingLocation
    Event
    Bucket
    Schedule
]];
use MooseX::Types::Moose ':all';

class_type Member,   { class => 'Upset::Schema::Member' };
class_type Job,      { class => 'Upset::Schema::Job' };
class_type Schedule, { class => 'Upset::Schema::Schedule' };
class_type Event,    { class => 'Upset::Schema::Schedule::Event' };
class_type Bucket,   { class => 'Upset::Schema::Schedule::Bucket' };

enum MeetingLocation,  qw[ None Pinellas Tampa IRC Mailing_List ];
enum Distribution, qw[
    N/A
    Ubuntu
    Debian
    Gentoo
    Arch
    Slackware
    Fedora
    SUSE
    OpenBSD
    FreeBSD
    NetBSD
    DragonflyBSD
    Solaris
    OSX
];

1;
