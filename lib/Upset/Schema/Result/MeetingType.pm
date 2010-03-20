package Upset::Schema::Result::MeetingType;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('meeting_type');

__PACKAGE__->add_columns(
    'meeting_type_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'name' => {
        data_type   => 'VARCHAR',
        size        => '255',
        is_nullable => 0,
    },
    'short_name' => {
        data_type   => 'VARCHAR',
        size        => '20',
        is_nullable => 0,
    },
    'rule' => {
        data_type   => 'text',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('meeting_type_id');
__PACKAGE__->has_many(meetings => 'Upset::Schema::Result::Meeting', 'meeting_type_id');

1;
