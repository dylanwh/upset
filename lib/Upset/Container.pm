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
use Upset::Adapter::User;
use Upset::Adapter::Schedule;
use Upset::Form;

use Bread::Board;
use Bread::Board::LifeCycle::Singleton::WithParameters;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Upset' );

sub BUILD {
    my $self = shift;

    container $self => as {
        service template_path => ['share/template', 'share/template/include'];
        service confname      => 'etc/upset.ini';
        service passwd        => 'etc/passwd';
        service model_dsn     => 'dbi:SQLite:upset.db';
        service model_args => {
            create        => 1,
            serializer    => 'yaml',
            allow_classes => [ 'DateTime::Span', 'Set::Infinite::_recurrence' ],
        };

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

        service 'logger' => (
            block => sub {
                require Log::Dispatch;
                Log::Dispatch->new(
                    outputs => [
                        [ 
                            'File',
                            min_level => 'debug',
                            filename  => 'logs/debug.log',
                            mode      => '>>',
                            newline   => 1,
                        ]
                    ],
                ),
            }
        );

        Moose::Util::TypeConstraints::class_type('Log::Dispatch');
        typemap 'Log::Dispatch' => 'logger';

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
        typemap 'Upset::Adapter::Schedule' => infer;
        typemap 'Upset::Adapter::User' => infer;
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
