package Upset::View::Template;
use Moose;
use namespace::autoclean;

use MooseX::Types;
use MooseX::Types::Moose ':all';
use MooseX::Params::Validate;
use Template;

has '_template' => (
    is         => 'ro',
    isa        => 'Template',
    lazy_build => 1,
);

has 'include_path' => (
    is       => 'ro',
    isa      => ArrayRef [Str],
    required => 1,
);

sub _build__template {
    my $self = shift;
    Template->new({ INCLUDE_PATH => $self->include_path, POST_CHOMP => 1 });
}

sub render {
    my $self = shift;
    my ($resp, $vars) = pos_validated_list(
        \@_,
        { isa => 'Plack::Response' },
        { isa => HashRef },
    );

    $resp->content_type('text/html') unless $resp->content_type;
    my $content = "";
    $self->_template->process($vars->{file}, $vars, \$content)
        or die $self->_template->error;
    $resp->content($content);

    return $resp;
}

__PACKAGE__->meta->make_immutable;
1;
