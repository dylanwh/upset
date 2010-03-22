package Upset::View::TT;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::View::TT' };

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    POST_CHOMP         => 1,
    INCLUDE_PATH       => [
        Upset->path_to('root', 'template'),
        Upset->path_to('root', 'include'),
    ],
    FILTERS => {
        twitter => sub {
            my ($text) = @_;
            $text =~ s!(https?://\S+)(\.\b)?!<a href="$1">$1$2</a>!g;
            $text =~ s!@(\w+)!<a href="http://twitter.com/$1">\@$1</a>!g;
            return $text;
        },
    },
);

1;
