package Upset::Schema::Role::ID;
use Moose::Role;
use namespace::autoclean;

with qw[KiokuDB::Role::ID KiokuDB::Role::UUIDs];

has 'id' => (
    is      => 'ro',
    isa     => 'Str',
    builder => 'generate_uuid',
);

sub kiokudb_object_id { $_[0]->id }


1;
