package Upset::Model::Twitter;
use Moose;
use namespace::autoclean;
use Net::Twitter;

extends 'Catalyst::Model';

has 'username' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'password' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'upset_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://unix-people.org',
);

has 'net_twitter' => (
    is         => 'ro',
    init_arg   => undef,
    lazy_build => 1,
    handles    => [qw[ user_timeline ]],
);

has 'twitter_rs' => (
    is       => 'ro',
    required => 1,
    handles  => [qw[ create most_recent recent ]],
);

has 'log' => (
    is       => 'ro',
    required => 1,
);


sub _build_net_twitter {
    my ($self) = @_;
    return Net::Twitter->new(
        traits     => ['API::REST', 'InflateObjects'],
        username   => $self->username,
        password   => $self->password,
        clientname => 'Upset',
        clienturl  => $self->upset_url,
    );
}

around 'COMPONENT' => sub {
    my ($orig, $class, $c, $args) = @_;
    $args->{twitter_rs} = $c->model('DB::Twitter');
    $args->{log}        = $c->log;
    return $class->$orig($c, $args);
};

before 'recent' => sub {
    my ($self, $n) = @_;
    my $tweet      = $self->most_recent;
    my $age        = $tweet ? time - $tweet->inserted_at->epoch : time;

    if ( $age > 60 * 30 ) {
        $self->log->debug("refreshing twitter feed, age = $age");
        my $statuses = $tweet
            ? $self->user_timeline( { since_id => $tweet->id } )
            : $self->user_timeline();
        for my $status (@$statuses) {
            $status->created_at->set_time_zone('America/New_York');
            $self->create(
                {
                    id          => $status->id,
                    inserted_at => DateTime->now,
                    created_at  => $status->created_at,
                    text        => $status->text,
                    user_name   => $status->user->screen_name,
                    user_id     => $status->user->id,
                    source      => $status->source,
                }
            );
        }
    }
};

__PACKAGE__->meta->make_immutable;

