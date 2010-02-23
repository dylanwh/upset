package Upset::Schema::Result::List;
use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('list');
__PACKAGE__->add_columns(
    'id' => {
        data_type     => 'INTEGER',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
    'name' => {
        data_type     => 'VARCHAR(255)',
        default_value => undef,
        is_nullable   => 0,
        size          => undef,
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('name_unique', ['name']);

__PACKAGE__->has_many(
  'message' => 'Upset::Schema::Result::Message',
  { 'foreign.list' => 'self.id' },
);

1;
