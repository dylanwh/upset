package Upset::Schema::Result::MeetingNote;
use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('meeting_note');

__PACKAGE__->add_columns(
    'meeting_note_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'meeting_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'meeting_note_type_id' => {
        data_type   => 'INTEGER',
        is_nullable => 0,
    },
    'content' => {
        data_type   => 'TEXT',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('meeting_note_id');
__PACKAGE__->belongs_to(
    meeting => 'Upset::Schema::Result::Meeting',
    'meeting_id'
);
__PACKAGE__->belongs_to(
    meeting_note_type => 'Upset::Schema::Result::MeetingNoteType',
    'meeting_note_type_id'
);

1;
