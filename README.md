# NAME

HTTP::Response::Stringable - Makes HTTP::Response objects stringable

# VERSION

version 0.0002

# SYNOPSIS

    my $res = LWP::UserAgent->new->get('http://example.com');
    Role::Tiny->apply_roles_to_object($res, 'HTTP::Response::Stringable');
    print "$res";

# DESCRIPTION

This module is a role that can be applied to [HTTP::Response](http://search.cpan.org/perldoc?HTTP::Response) objects to
make them stringable.

After applying this role to the response object, you can use it in string
context.
The resulting string is simply the return value of the HTTP::Response
`as_string` method.

My motivation for creating this module was that I wanted to throw
`HTTP::Response` objects as exceptions, and exception objects should have a
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

# AUTHOR

Naveed Massjouni <naveed@vt.edu>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Naveed Massjouni.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
