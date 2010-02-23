package Upset::Schema::Result::Message;
use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('message');
__PACKAGE__->add_columns(
    'id' => {
        data_type     => 'INTEGER',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'date' => {
        data_type     => 'datetime',
        size          => undef,
        default_value => undef,
        is_nullable   => 0,
    },
    'list' => {
        data_type     => 'INTEGER',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'author' => {
        data_type     => 'TEXT',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'subject' => {
        data_type     => 'TEXT',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'content' => {
        data_type     => 'BIGTEXT',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'content_type' => {
        data_type     => 'TEXT',
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    'message_id' => {
        data_type     => 'TEXT',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('message_id_unique', ['message_id']);

__PACKAGE__->belongs_to(
  'list' => 'Upset::Schema::Result::List',
  { id => 'list' },
  {},
);

1;
