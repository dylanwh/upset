package Upset::Schema::Secret;
use Moose;
use namespace::autoclean;

use Crypt::Random::Source qw(get_weak);

with qw(KiokuDB::Role::ID);

has 'timestamp' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has 'value' => (
    is         => 'ro',
    isa        => 'Str',
    init_arg   => undef,
    lazy_build => 1,
);

sub _build_value {
    my ($self) = @_;
    my $d = Digest->new('SHA-256');
    $d->add(get_weak(14));
    $d->add($self->timestamp);
    return $d->hexdigest;
}

sub kiokudb_object_id {
    my ($self) = @_;
    return 'secret:' . $self->timestamp
}

__PACKAGE__->meta->make_immutable;
1;
