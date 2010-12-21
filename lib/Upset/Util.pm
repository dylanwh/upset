package Upset::Util;
use strictures 1;

use HTML::FormFu;

sub get_object {
    my ($this, $form) = @_;
}


sub get_form {
    my ($this, $meta) = @_;
    my $desc = $meta->can('description') ? $meta->description : {} ;
    my $form = HTML::FormFu->new($desc);

    $form->auto_constraint_class('constraint_%t');
    $form->auto_id("%f_%n");
    $form->indicator('submit');
    $form->auto_fieldset(1);
    $form->stash->{class} = $meta->name;

    $form->elements(
        [   
            $this->get_form_elements( $meta ),
            { type => 'Submit', name => 'submit', value => 'Submit' },
            { type => 'Reset',  name => 'clear', value => 'Clear' },
        ]
    );

    return $form;
}

sub get_form_elements {
    my ($this, $meta) = @_;
    my @elements;
    my %order;
    for my $attr ($meta->get_all_attributes) {
        if ($attr->does('MooseX::MetaDescription::Meta::Trait')) {
            my $desc = $attr->description;
            my ($element, $order) = $this->get_form_element($attr, $desc);
            $order{ $element->{name} } = $order;
            push @elements, $element;
        }
    }

    return sort { $order{$a->{name}} <=> $order{$b->{name}} } @elements;
}

sub get_form_element {
    my ($this, $attr, $desc) = @_;
    my %element;

    $element{name}  = $attr->name;
    $element{label} = join(' ', map { ucfirst $_ } split(/_/, $attr->name));
    $element{order} = $attr->insertion_order;

    if ($attr->has_type_constraint) {
        my $tc = $attr->type_constraint;
        $element{type} = 'Text';

        if ($tc->equals('Num')) {
            $element{type} = 'Number';
        }
        elsif ($tc->equals('Bool')) {
            $element{type} = 'Checkbox';
            unless (ref $attr->default) {
                $element{value} = $attr->default;
            }
        }
        elsif ($tc->isa('Moose::Meta::TypeConstraint::Enum')) {
            $element{type} = 'Select';
            $element{options} = [ map { [$_, join(' ', split(/_/, $_))] } @{ $tc->values } ];
        }
    }

    if (ref $desc) {
        for my $k (keys %$desc) {
            $element{$k} = $desc->{$k};
        }
    }

    push @{ $element{constraints} }, 'Required' if $attr->is_required;

    my $order = delete $element{order};
    return \%element, $order
}

1;
