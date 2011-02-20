package Upset::Adapter::Schedule;
use Moose;
use namespace::autoclean;

use Upset::Schema::Schedule;

extends 'Upset::Adapter';
with (
    'Upset::Role::Adapter::Transactional',
    'Upset::Role::Adapter::TemplateView',
);

sub _build_template_vars {
    my ($self) = @_;

    my $schedule = $self->model->schedule;
    return +{
        events => [ $schedule->next_events( DateTime->now ) ],
    };
}

sub GET_list {
    my ($self, $req) = @_;

    return $self->render( $req => { file => 'schedule/list.tt' });
}


__PACKAGE__->meta->make_immutable;
1;
