use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Upset' }
BEGIN { use_ok 'Upset::Controller::List' }

ok( request('/list')->is_success, 'Request should succeed' );
done_testing();
