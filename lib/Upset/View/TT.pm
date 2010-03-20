package Upset::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH       => [
        Upset->path_to('root', 'template'),
        Upset->path_to('root', 'include'),
    ],
    POST_CHOMP         => 1,
    WRAPPER            => 'page.tt',
);

1;
