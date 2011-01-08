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
                service    => 'form',
                parameters => {
                    schema    => Upset::Schema::Member->meta,
                    recaptcha => $c->resolve( service => 'recaptcha' ),
                },
            )
        },
    );
    $router->add_route('/join', target => $members, defaults => { action => 'join' });

    my $jobs = $c->resolve(
        type       => 'Upset::Adapter::Jobs',
        parameters => {
            form => $c->resolve(
                service    => 'form',
                parameters => {
                    schema    => Upset::Schema::Job->meta,
                    recaptcha => $c->resolve( service => 'recaptcha' ),
                },
            )
        },
    );
    $router->add_route( '/jobs', target => $jobs );
    $router->add_route( '/jobs/approve',
        target => $c->resolve(
            service    =>  'auth_basic',
            parameters => { app => $jobs },
        ),
        name     => $jobs->name,
        defaults => { action => 'approve' }
    );
    $router->add_route( '/jobs/publish',
        target   => $jobs,
        defaults => { action => 'publish' },
    );

    $router->add_route( '/meetings',
        target   => $c->resolve( type => 'Upset::Adapter::Schedule' ),
        defaults => { action          => 'list' },
    );

}

__PACKAGE__->meta->make_immutable;
1;

