#!/usr/bin/env perl
use strict;
use Pod::Usage;
use Getopt::Long;
use Upset::Schema;

my $dsn = 'dbi:SQLite:dbname=upset.db';
my ($user, $password);

my ( $preversion, $help );
GetOptions( 'p|preversion:s' => \$preversion, ) or die pod2usage;

my $schema = Upset::Schema->connect( $dsn, $user, $password);
my $sql_dir = './sql';
my $version = $schema->schema_version();
$schema->create_ddl_dir( 'SQLite', $version, $sql_dir, $preversion );
