package Upset::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH       => [ Upset->path_to('root') ],
    POST_CHOMP         => 1,
);

1;
