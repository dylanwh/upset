#!/usr/bin/env perl
use strict;
use warnings;
use Upset::Schema;
use Email::Folder;
use Email::Address;
use DateTime::Format::Mail;
use DateTime;
use Try::Tiny;
use Date::Parse;
use Digest::SHA1;

my $dsn  = 'dbi:SQLite:dbname=upset.db';
my $file = 'slug.all';

my $schema = Upset::Schema->connect($dsn);
my $list = $schema->resultset('List')->find_or_create({ name => 'slug' });
my $msg_rs = $schema->resultset('Message');

my $folder = Email::Folder->new($file);

while (my $email = $folder->next_message) {
    try {
        my $date   = get_date($email->header('Date'));
        my $msg_id = $email->header('Message-Id') || sha1_hex($email->body);
        $msg_rs->create(
            {   
                list         => $list,
                author       => ( Email::Address->parse( $email->header('From') ) )[0],
                content_type => scalar $email->header('Content-Type'),
                message_id   => $msg_id,
                subject      => scalar $email->header('Subject'),
                date         => $date,
                content      => scalar $email->body,
            },
        );
    } catch {
        if (!/message.subject may not be NULL/) { warn "ERROR: $_\n" }

    };
}

sub get_date {
    my $str = shift;
    my $pf = DateTime::Format::Mail->new;
    try  { 
        $str =~ s!\s+US/Eastern\s*!!;
        $pf->parse_datetime( $str )
    } catch {
        try {
            DateTime->from_epoch(epoch => str2time($str, 'US/Eastern'));
        } catch {
            die "invalid date: $str\n";
        };
    };
}
