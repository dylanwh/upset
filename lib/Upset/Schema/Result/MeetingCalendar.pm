package Upset::Schema::Result::MeetingCalendar;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('meeting_calendar');

__PACKAGE__->add_columns(
    'meeting_calendar_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'year' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'month' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('meeting_calendar_id');
__PACKAGE__->add_unique_constraint('year_month', ['year','month']);
__PACKAGE__->has_many(meetings => 'Upset::Schema::Result::Meeting', 'meeting_calendar_id');


1;
