package Upset::Schema::Result::User;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('user');

__PACKAGE__->add_columns(
    'url' => {
        data_type   => 'TEXT',
        size        => undef,
        is_nullable => 0,
    },
    'user_name' => {
        data_type   => 'TEXT',
        size        => undef,
        is_nullable => 1,
    },
    'user_role' => {
        data_type     => 'TEXT',
        size          => undef,
        is_nullable   => 0,
        default_value => 'user',
    },
);

__PACKAGE__->set_primary_key('url');
__PACKAGE__->add_unique_constraint('user_name_unique', ['user_name']);


1;
