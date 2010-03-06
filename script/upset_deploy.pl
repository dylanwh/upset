#!/usr/bin/env perl
use strict;
use warnings;
use Upset::Schema;

my $dsn = 'dbi:SQLite:dbname=upset.db';
my ($user, $password);

my $schema = Upset::Schema->connect( $dsn, $user, $password, );

if ( !$schema->get_db_version() ) {
    # schema is unversioned
    $schema->deploy();
}
else {
    $schema->upgrade();
}
