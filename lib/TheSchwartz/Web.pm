package TheSchwartz::Web;

use strict;
use 5.008_001;
our $VERSION = '0.01';

use Tatsumaki::Application;
use TheSchwartz::Web::Handlers;
use TheSchwartz::Web::Client;

sub handler {
    my $class = shift;
    my($dsn) = @_;

    my $schwartz = TheSchwartz::Web::Client->new(dsn => $dsn);

    my $app = Tatsumaki::Application->new(TheSchwartz::Web::Handlers->all);
    $app->add_service(schwartz => $schwartz);
    $app->psgi_app;
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

TheSchwartz::Web -

=head1 SYNOPSIS

  use TheSchwartz::Web;

=head1 DESCRIPTION

TheSchwartz::Web is

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 COPYRIGHT

Copyright 2010- Tatsuhiko Miyagawa

HTML layout and stylesheet are borrowed from resque-web: Copyright 2009 Chris Wanstrath

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
