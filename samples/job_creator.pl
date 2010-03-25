#!perl
use strict;
use DBI;
use TheSchwartz::Simple;

my $how_many = shift || 1000;

my $dbh = DBI->connect('DBI:mysql:database=schwartz', 'root', undef)
    or die "Can't connect to the database ", DBI->errstr;

my $client = TheSchwartz::Simple->new([ $dbh ]);

for (1..$how_many) {
    my $job_id = $client->insert("TestJob", { counter => $_ });
}

warn "Created $how_many jobs\n";

