package Upset::Container;
use Moose;
use namespace::autoclean;

use Path::Router;

use Upset::App;
use Upset::Router;
use Upset::Config;
use Upset::Model;
use Upset::View::Template;
use Upset::Adapter::Template;
use Upset::Adapter::Members;
use Upset::Adapter::Jobs;
use Upset::Form;


use Bread::Board;
use Bread::Board::LifeCycle::Singleton::WithParameters;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Upset' );

has 'template_path' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

sub BUILD {
    my $self = shift;

    container $self => as {
        service template_path => $self->template_path;

        service model_dsn     => 'bdb:dir=data';
        service model_args => {
            create          => 1,
            allow_classes => [ 'DateTime::Span', 'DateTime::SpanSet', 'Set::Infinite::_recurrence'],
        };
        service confname      => 'upset';
        service passwd        => 'passwd';

        service config => (
            class        => 'Upset::Config',
            dependencies => wire_names('confname'),
            lifecycle    => 'Singleton',
        );

        service recaptcha => (
            block => sub {
                my $s = shift;
                my $config = $s->param('config');
                return +{
                    public_key  => $config->get( key => 'recaptcha.public-key' ),
                    private_key => $config->get( key => 'recaptcha.private-key' ),
                };
            },
            dependencies => wire_names('config'),
        );

        service authenticator => (
            class        => 'Authen::Simple::Passwd',
            dependencies => wire_names('passwd'),
        );

        service form => (
            class        => 'Upset::Form',
            parameters   => { schema => { optional => 0 }, recaptcha => { optional => 1 } },
            lifecycle    => 'Singleton::WithParameters',
        );

        service auth_basic => (
            class        => 'Plack::Middleware::Auth::Basic',
            dependencies => wire_names('authenticator'),
            parameters   => ['app'],
            lifecycle    => 'Singleton::WithParameters',
        );

        typemap 'Upset::Config' => 'config';
        typemap 'Upset::Form'   => 'form';
        typemap 'Upset::Router' => infer;
        typemap 'Upset::App'    => infer;

        typemap 'Upset::Model' => infer(
            dependencies => {
                dsn        => depends_on('model_dsn'),
                extra_args => depends_on('model_args'),
            },
            lifecycle    => 'Singleton',
        );

        typemap 'Upset::View::Template' => infer(
            dependencies => { 'include_path' => depends_on('template_path') },
            lifecycle    => 'Singleton',
        );

        typemap 'Upset::Adapter::Template' => infer;
        typemap 'Upset::Adapter::Members' => infer(
            parameters => { form => { optional => 0 } },
        );
        typemap 'Upset::Adapter::Jobs' => infer(
            parameters => { form => { optional => 0 } },
        );
    };
}

__PACKAGE__->meta->make_immutable;
1;
