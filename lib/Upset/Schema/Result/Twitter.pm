package Upset::Schema::Result::Twitter;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('twitter');

__PACKAGE__->add_columns(
    'id' => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
    'inserted_at' => {
        data_type                 => 'datetime',
        is_nullable               => 0,
        datetime_undef_if_invalid => 1,
        timezone                  => 'America/New_York',
    },
    'created_at' => {
        data_type                 => 'datetime',
        is_nullable               => 0,
        datetime_undef_if_invalid => 1,
        timezone                  => 'America/New_York',
    },
    'user_id' => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
    'user_name' => {
        data_type   => 'varchar',
        size        => 50,
        is_nullable => 0,
    },
    'text' => {
        data_type   => 'varchar',
        size        => 140,
        is_nullable => 0,
    },
    'source' => {
        data_type   => 'text',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');

1;
