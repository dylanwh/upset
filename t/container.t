#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use Upset::Schema::Job;

use ok 'Upset::Container';
my $c = Upset::Container->new(template_path => ['pants'], form_path => 'share/forms');
ok($c, "built");

{
    my $adapter = $c->resolve(type => 'Upset::Adapter::Template');
    is_deeply($adapter->view->include_path, ['pants']);
}

{
    my $form = $c->resolve(
        type => 'Upset::Form', 
        parameters => { schema => Upset::Schema::Member->meta }
    );

    $form->process(
        {   
            name   => 'Dylan William Hardison',
            email  => 'dylan@hardison.net',
            submit => 'Submit'
        }
    );
    use YAML::XS;
    is($form->form->param_value('name'), 'Dylan William Hardison');
    is($form->form->param_value('email'), 'dylan@hardison.net');
    my $member = $form->to_object;
    isa_ok($member, 'Upset::Schema::Member');
    is($member->name, 'Dylan William Hardison');
    is($member->email, 'dylan@hardison.net');
}


done_testing;

