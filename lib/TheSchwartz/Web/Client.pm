package TheSchwartz::Web::Client;
use Any::Moose;
extends 'Tatsumaki::Service';

use DBI;
use TheSchwartz::Simple;

has dsn    => (is => 'rw', isa => 'ArrayRef');
has client => (is => 'rw', isa => 'TheSchwartz::Simple');

sub start {
    my $self = shift;

    my $dbh = DBI->connect(@{$self->dsn})
        or die "Can't connect to the database ", DBI->errstr;

    my $client = TheSchwartz::Simple->new([ $dbh ]);
    $self->client($client);

    return 1;
}

1;
