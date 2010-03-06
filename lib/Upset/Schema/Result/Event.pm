package Upset::Schema::Result::Event;
use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('event');
__PACKAGE__->add_columns(
    'id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'creator' => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },
    'name' => {
        data_type   => 'VARCHAR',
        size        => 50,
        is_nullable => 0,
    },
    'description' => {
        data_type   => 'TEXT',
        is_nullable => 1,
    },
    'datetime' => {
        data_type   => 'datetime',
        timezone    => 'America/New_York',
        is_nullable => 0,
    },
    'duration' => {
        data_type   => 'INTEGER',
        is_nullable => 1, # NULL = all day
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to( 'user' => 'Upset::Schema::Result::User' );

1;
