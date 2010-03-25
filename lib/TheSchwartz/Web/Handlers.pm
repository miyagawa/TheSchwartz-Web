package TheSchwartz::Web::Handlers;
use strict;
use warnings;
use TheSchwartz::Web::View;

# TODO replace all of these with Piglet::Routes

sub all {
    my $class = shift;
    return [
        '/func/(.+)' => 'TheSchwartz::Web::Handler::ListJobs',
        '/job/(\d+)' => 'TheSchwartz::Web::Handler::DetailJob',
        '/' => 'TheSchwartz::Web::Handler::Overview',
    ];
}

package TheSchwartz::Web::Handler;
use parent qw(Tatsumaki::Handler);

sub schwartz {
    my $self = shift;
    $self->application->service('schwartz');
}

package TheSchwartz::Web::Handler::Overview;
use parent -norequire => qw(TheSchwartz::Web::Handler);

sub get {
    my $self = shift;
    $self->write(TheSchwartz::Web::View->render_layout('overview', { handler => $self }));
}

package TheSchwartz::Web::Handler::ListJobs;
use parent -norequire => qw(TheSchwartz::Web::Handler);

sub get {
    my($self, $name) = @_;
    $self->write(TheSchwartz::Web::View->render_layout('list_jobs', { handler => $self, function => $name }));
}

package TheSchwartz::Web::Handler::DetailJob;
use parent -norequire => qw(TheSchwartz::Web::Handler);

sub get {
    my($self, $job_id) = @_;
    $self->write(TheSchwartz::Web::View->render_layout('job', { handler => $self, job_id => $job_id }));
}

1;
