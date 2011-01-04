package Upset::Model;
use Moose;
use namespace::autoclean;

use MooseX::Params::Validate;
use MooseX::Types::Moose ':all';
use Upset::Schema::Types ':all';

use KiokuDB::Util qw(set);
use Upset::Schema::Schedule;

use constant MEMBERS  => 'set:members';
use constant JOBS     => 'set:jobs';
use constant SCHEDULE => 'schedule';

extends 'KiokuX::Model';

sub init {
    my $self    = shift;
    $self->store(MEMBERS() => set());
    $self->store(JOBS()    => set());
    $self->store(SCHEDULE() => Upset::Schema::Schedule->new);
}

sub add_member {
    my $self = shift;
    my ($member) = pos_validated_list(\@_,
        { isa => Member, coerce => 1 }
    );

    my $members = $self->lookup(MEMBERS);
    $self->store_nonroot($member);
    $members->insert($member);
    $self->update( $members );
}

sub add_job {
    my $self = shift;
    my ($job) = pos_validated_list(\@_,
        { isa => Job, coerce => 1 }
    );
    my $jobs = $self->jobs;
    $self->store_nonroot($job);
    $jobs->insert($job);
    $self->update($jobs);
}

sub remove_job {
    my $self = shift;
    my ($job) = pos_validated_list(\@_,
        { isa => Job  }
    );
    my $jobs = $self->jobs;
    $jobs->remove($job);
    $self->update($jobs);
}

sub approve_job {
    my $self = shift;
    my ($job) = pos_validated_list( \@_, { isa => Job } );
    $job->approved(1);
    $self->update($job);
}

sub members {
    my $self = shift;

    return $self->lookup(MEMBERS);
}

sub jobs {
    my $self = shift;

    return $self->lookup(JOBS);
}

sub schedule {
    my $self = shift;

    return $self->lookup(SCHEDULE);
}

__PACKAGE__->meta->make_immutable;
1;

