package Upset::Schema::Result::Meeting;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('meeting');

__PACKAGE__->add_columns(
    'meeting_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'meeting_calendar_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'meeting_type_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'location' => {
        data_type   => 'TEXT',
        is_nullable => 0,
    },
    'summary' => {
        data_type   => 'TEXT',
        is_nullable => 0,
    },
    'time' => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('meeting_id');
__PACKAGE__->belongs_to(
    type => 'Upset::Schema::Result::MeetingType',
    'meeting_type_id'
);
__PACKAGE__->belongs_to(
    calendar => 'Upset::Schema::Result::MeetingCalendar',
    'meeting_calendar_id'
);
__PACKAGE__->has_many(
    notes => 'Upset::Schema::Result::MeetingNote',
    'meeting_id',
);
1;
