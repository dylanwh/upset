package Upset::App::Remap;
use Moose;
use MooseX::NonMoose;

extends 'Plack::Middleware';

my %remap = (
    '/history.php'  => '/page/history.html',
    '/index.php'    => '/',
    '/jobpost.php'  => '/jobs/publish',
    '/jobs.php'     => '/jobs',
    '/join.php'     => '/join',
    '/lists.php'    => '/page/lists.html',
    '/meetings.php' => '/meetings',
    '/treasury.php' => '/page/treasury.html',
);

sub call {
    my ($self, $env) = @_;
    my $req = Plack::Request->new($env);
    my $path = $req->path;

    if ($remap{$path}) {
        my $resp = $req->new_response(302);
        $resp->location($remap{$path});
        return $resp->finalize;
    }
    elsif ($path =~ /\.php$/) {
        my $resp = $req->new_response(302);
        $path =~ s/\.php$/.html/g;
        $resp->location("/page$path");
        return $resp->finalize;
    }
    else {
        return $self->app->( $env );
    }
}

__PACKAGE__->meta->make_immutable;
1;
