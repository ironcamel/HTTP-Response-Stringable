package HTTP::Response::Stringable;
use Role::Tiny;
use overload '""' => sub { $_[0]->status_line . "\n" . $_[0]->content };

# VERSION

# ABSTRACT: Makes HTTP::Response objects stringable

=head1 SYNOPSIS

    my $res = LWP::UserAgent->new->get('http://example.com');
    Role::Tiny->apply_roles_to_object($res, 'HTTP::Response::Stringable');
    print "$res";


=head1 DESCRIPTION

This module is a role that can be applied to L<HTTP::Response> objects to
make them stringable.

After applying this role to the response object, you can use it in string
context.
The resulting string will be of the form:

    $res->status_line . "\n" . $res->content

My motivation for creating this module was that I wanted to throw
C<HTTP::Response> objects as exceptions, and exception objects should have a
string representation so that they can be properly logged.
Here is an example use case:

    package WidgetFactory;
    use Moo;
    use LWP::UserAgent;

    sub create_widget {
        my $res = LWP::UserAgent->new->post('http://widget-factory/widgets');
        if (not $res->is_success) {
            require Role::Tiny;
            Role::Tiny->apply_roles_to_object($res, 'HTTP::Response::Stringable');
            die $res;
        }
    }

    # ...

    package main;
    use WidgetFactory;
    use TryCatch;

    my $wf = WidgetFactory->new;
    try {
        $wf->create_widget();
    } catch (HTTP::Response $res) {
        debug "Creating widget failed: $res";
    }

=cut

1;
