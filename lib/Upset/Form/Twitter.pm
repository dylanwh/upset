package Upset::Form::NewsPost;
use Moose;
use namespace::autoclean;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';

has '+item_class' => ( default => 'Twitter' );

has_field 'text' => (
    type      => 'TextArea',
    cols      => 35,
    rows      => 2,
    maxlength => 140,
    required  => 1,
);

has_field 'submit' => ( type => 'Submit', value => 'Post' );
has_field 'reset'  => ( type => 'Reset',  value => 'Clear' );

__PACKAGE__->meta->make_immutable;

1;
