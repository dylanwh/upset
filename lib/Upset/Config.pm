package Upset::Config;
use Moose;
use namespace::autoclean;

use Path::Class;

extends 'Config::GitLike';

sub dir_file { $_[0]->confname }

sub load_dirs {
    my ($self, $path) = @_;
    $path ||= Cwd::cwd();

    my $file = dir($path)->file( $self->dir_file );
    $self->load_file( $file );
}

__PACKAGE__->meta->make_immutable;
1;
