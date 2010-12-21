package Upset::View::Template;
use Moose;
use namespace::autoclean;

use MooseX::Types;
use MooseX::Types::Moose ':all';
use MooseX::Params::Validate;
use Template;

with 'Upset::Role::View';

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
    my ($self, $req, $vars) = @_;

    my $resp = $req->new_response(200);
    $resp->content_type('text/html') unless $resp->content_type;

    local $vars->{request}  = $req;
    local $vars->{response} = $resp;

    my $content = "";
    if ($self->_template->process($vars->{file}, $vars, \$content)) {
        $resp->content($content);
    }
    else {
        $resp->content("Error: " . $self->_template->error);
        $resp->content_type('text/plain');
        $resp->status(500);
    }


    return $resp;
}

__PACKAGE__->meta->make_immutable;
1;
