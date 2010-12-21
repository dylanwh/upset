package Upset::Adapter::Members;
use Moose;
use namespace::autoclean;

use Upset::Schema::Member;

extends 'Upset::Adapter';

has 'model' => (
    is       => 'ro',
    isa      => 'Upset::Model',
    required => 1,
);

has 'view' => (
    is       => 'ro',
    isa      => 'Upset::View::Template',
    required => 1,
    handles => ['render'],
);

has 'form' => (
    is       => 'ro',
    isa      => 'Upset::Form',
    required => 1,
);

sub GET {
    my ($self, $req) = @_;

    $self->render($req => { file => 'members/list.tt' });
}

sub GET_join {
    my ($self, $req) = @_;
  
    $self->form->action( $req->uri_for('Members', { action => 'join' }) );
    $self->form->process($req);
    $self->render($req => { file => 'members/join.tt', form => $self->form });
}

sub POST_join {
    my ($self, $req) = @_;
    my $model = $self->model;
    my $form  = $self->form;
    my $scope = $model->new_scope;

    if ($form->process($req)) {
        my $member = $form->to_object;
        $model->add_member($member);
        $self->render( $req => { file => 'members/thanks.tt' });
    }
    else {
        $self->GET($req);
    }
}

__PACKAGE__->meta->make_immutable;
1;

