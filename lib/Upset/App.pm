package Upset::App;
use Moose;
use namespace::autoclean;

use Plack::Middleware::Auth::Basic;

extends 'Plack::App::Path::Router::PSGI';

has '+router' => ( isa => 'Upset::Router' );

sub establish_routes {
    my ($self, $c) = @_;
    my $router = $self->router;

    $router->add_route('/',
        target   => $c->resolve(type => 'Upset::Adapter::Template'),
    );

    $router->add_route('/page/:page',
        target => $c->resolve(type => 'Upset::Adapter::Template'),
    );

    my $members = $c->resolve(
        type       => 'Upset::Adapter::Members',
        parameters => {
            form => $c->resolve(
                type       => 'Upset::Form',
                parameters => { schema => Upset::Schema::Member->meta },
            )
        },
    );
    $router->add_route('/members',
        target => Plack::Middleware::Auth::Basic->new(app => $members, authenticator => sub { 1 }),
        name   => $members->name,
    );
    $router->add_route('/join', target => $members, defaults => { action => 'join' });

    my $jobs = $c->resolve(
        type       => 'Upset::Adapter::Jobs',
        parameters => {
            form => $c->resolve(
                type       => 'Upset::Form',
                parameters => { schema => Upset::Schema::Job->meta },
            )
        },
    );
    $router->add_route( '/jobs', 
        target => $jobs
    );
    $router->add_route( '/jobs/approve', 
        target   => $jobs,
        defaults => { action => 'approve' }
    );
    $router->add_route( '/jobs/create',
        target   => $jobs,
        defaults => { action => 'create' },
    );
}

__PACKAGE__->meta->make_immutable;
1;

