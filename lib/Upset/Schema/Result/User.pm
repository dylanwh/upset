package Upset::Schema::Result::User;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('user');

__PACKAGE__->add_columns(
    'url' => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },
    'realname' => {
        data_type   => 'VARCHAR',
        size        => 100,
        is_nullable => 1,
    },
    'nick' => {
        data_type   => 'VARCHAR',
        size        => 15,
        is_nullable => 1,
    },
    'roles' => {
        data_type     => 'TEXT',
        is_nullable   => 0,
        default_value => 'user',
    },
);

__PACKAGE__->set_primary_key('url');
__PACKAGE__->add_unique_constraint('user_nick_unique', ['nick']);


1;
