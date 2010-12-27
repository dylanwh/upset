package Upset::Adapter::Jobs;
use Moose;
use namespace::autoclean;

use Upset::Schema::Job;

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

has 'config' => (
    is       => 'ro',
    isa      => 'Upset::Config',
    required => 1,
);

=pod

sub BUILD {
    my $self   = shift;
    my $form   = $self->form;
    my $config = $self->config;

    {   
        type        => 'reCAPTCHA',
        name        => 'recaptcha',
        public_key  => $config->get( key => 'recaptcha.public-key' ),
        private_key => $config->get( key => 'recaptcha.private-key' ),
    },
}

=cut

around 'call' => sub {
    my $method = shift;
    my $self   = shift;
    my $scope = $self->model->new_scope;
    $self->$method(@_);
};

sub jobs {
    my ($self, %param) = @_;

    my $model = $self->model;
    my $l     = $model->live_objects;
    return [
        map  { +{ item => $_, uuid => $l->object_to_id($_) } }
        grep { $_->approved == $param{approved} }
        sort { $a->timestamp <=> $b->timestamp } 
        $model->jobs->elements
    ];
}

sub GET {
    my ($self, $req) = @_;
    $self->render($req => { file => 'jobs/index.tt', jobs => $self->jobs(approved => 1) });
}

sub GET_publish {
    my ($self, $req) = @_;
  
    $self->form->action( $req->uri_for('Jobs', { action => $req->action }) );
    $self->form->process($req);
    $self->render($req => { file => 'jobs/publish.tt', form => $self->form });
}

sub POST_publish {
    my ($self, $req) = @_;
    my $model = $self->model;
    my $form  = $self->form;

    if ($form->process($req)) {
        my $job = $form->to_object;
        $model->add_job($job);
        $self->GET($req);
    }
    else {
        $self->render($req => { file => 'jobs/publish.tt', form => $self->form });
    }
}

sub GET_approve {
    my ($self, $req) = @_;
    $self->render($req => { file => 'jobs/approve.tt', jobs => $self->jobs(approved => 0) });
}

# TODO: Redo and use javascript to send a restful DELETE.
sub POST_approve {
    my ($self, $req) = @_;
    my $model  = $self->model;
    my @ids    = $req->body_parameters->get_all("jobs");
    my $button = $req->body_parameters->{button};

    for my $id (@ids) {
        my $job = $model->lookup($id);
        if ($button eq 'Delete') {
            $model->remove_job($job);
        }
        else {
            $model->approve_job($job);
        }
    }

    $self->render($req => { file => 'jobs/index.tt', jobs => $self->jobs(approved => 1)});
}

__PACKAGE__->meta->make_immutable;
1;

