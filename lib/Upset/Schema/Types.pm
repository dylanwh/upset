package Upset::Schema::Types;
use MooseX::Types -declare => [qw[
    Member
    Job
    Distribution
    MeetingLocation
    SubscriptionPref
]];
use MooseX::Types::Moose ':all';

class_type Member, { class => 'Upset::Schema::Member' };
class_type Job,    { class => 'Upset::Schema::Job' };

coerce Member, from HashRef, via { 
    require Upset::Schema::Member;
    return Upset::Schema::Member->new($_);
};
coerce Job, from HashRef, via { 
    require Upset::Schema::Job;
    return Upset::Schema::Job->new($_);
};

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
