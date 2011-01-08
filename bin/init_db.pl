#!/usr/bin/env perl
use strict;
use warnings;

#!/usr/bin/env perl
use strict;
use Upset;
use Plack::Builder;
use Plack::App::File;

use Upset::Container;

my $c  = Upset::Container->new( 
    template_path => ['share/template', 'share/template/include'],
);

my $model = $c->resolve(type => 'Upset::Model');
my $scope = $model->new_scope;
$model->init;
