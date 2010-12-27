package Upset::Form;
use Moose;
use namespace::autoclean;

use HTML::FormFu;
use MooseX::Types::Moose ':all';
use MooseX::Types::Structured 'Dict';

has 'form' => (
    is         => 'ro',
    isa        => 'HTML::FormFu',
    lazy_build => 1,
    handles    => [qw[ render action submitted_and_valid]],
);

has 'description' => (
    is         => 'ro',
    isa        => HashRef,
    lazy_build => 1,
);

has 'recaptcha' => (
    is        => 'ro',
    isa       => Dict[ public_key => Str, private_key => Str ],
    predicate => 'has_recaptcha',
);

has 'schema' => (
    is       => 'ro',
    isa      => 'Moose::Meta::Class',
    required => 1,
);

sub _build_description {
    my ($self) = @_;
    my $desc = $self->schema->can('description')
             ? $self->schema->description
             : {};
    return $desc;
}

sub _build_form {
    my ($self) = @_;
    my $form   = HTML::FormFu->new( $self->description );
    my $schema = $self->schema;

    $form->auto_constraint_class('constraint_%t');
    $form->auto_id("%f_%n");
    $form->auto_fieldset(1);
    $form->indicator('submit');

    my @elements;
    for my $attr ( $schema->get_all_attributes ) {
        if ( $attr->does('MooseX::MetaDescription::Meta::Trait') ) {
            push @elements, my $el = $self->_build_form_element($attr);
        }
    }

    @elements = sort { $a->{stash}{order} <=> $b->{stash}{order} } @elements;

    if ($self->has_recaptcha) {
        push @elements, {
            type => 'reCAPTCHA',
            name => 'recaptcha',
            %{ $self->recaptcha },
        };
    }

    push(@elements,
        { type => 'Submit', name => 'submit', value => 'Submit' },
        { type => 'Reset',  name => 'clear',  value => 'Clear' }
    );
    $form->elements(\@elements);

    return $form;
}

sub _build_form_element {
    my ( $self, $attr ) = @_;
    my $desc    = $attr->description;
    my $word    = sub { join(' ', map { ucfirst $_ } split(/_/, shift)) };
    my %element = (
        name  => $attr->name,
        label => $word->( $attr->name ),
        stash => { order => $attr->insertion_order },
    );
    if ( $attr->has_type_constraint ) {
        my $tc = $attr->type_constraint;
        $element{type} = 'Text';

        if ( $tc->equals('Num') ) {
            $element{type} = 'Number';
        }
        elsif ( $tc->equals('Bool') ) {
            $element{type} = 'Checkbox';
            unless ( ref $attr->default ) {
                $element{value} = $attr->default;
            }
        }
        elsif ( $tc->isa('Moose::Meta::TypeConstraint::Enum') ) {
            $element{type} = 'Select';
            $element{options} = [ map { [ $_, $word->($_) ] } @{ $tc->values } ];
        }
    }

    for my $k ( keys %$desc ) {
        $element{$k} = $desc->{$k};
    }

    push @{ $element{constraints} }, 'Required' if $attr->is_required;

    return \%element;
}

sub process {
    my ($self, $req) = @_;
    $self->form->process($req);

    return $self->form->submitted_and_valid;
}

sub to_object {
    my ($self) = @_;
    my $form = $self->form;

    if ($form->submitted_and_valid) {
        my $class = $self->schema->name;
        my %init;
        for my $attr ($self->schema->get_all_attributes) {
            next unless $attr->does('MooseX::MetaDescription::Meta::Trait');

            my $key = $attr->init_arg;
            my $val = $form->param_value( $attr->name );

            if (defined($key) and defined($val)) {
                $init{ $key } = $val;
            }
        }
        return $class->new(\%init);
    }

    return undef;
}

__PACKAGE__->meta->make_immutable;
1;
