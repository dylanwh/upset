package Upset::Schema::ResultSet::Twitter;
use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub recent {
    my ($self, $n) = @_;
    $n ||= 25;

    return $self->search(
        {},
        {
            order_by => { -desc => 'created_at' },
            rows     => $n,
        }
    );
}

sub most_recent {
    my ($self) = @_;
    $self->recent(1)->first;
}

1;
