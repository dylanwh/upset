package Upset::Schema::Result::MeetingNoteType;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('meeting_note_type');

__PACKAGE__->add_columns(
    'meeting_note_type_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'name' => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('meeting_note_type_id');
__PACKAGE__->has_many(
    notes => 'Upset::Schema::Result::MeetingNote',
    'meeting_note_type_id'
);

1;
