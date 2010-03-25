package TheSchwartz::Web::View;
use strict;
use Markapl;
use Data::Dump ();

sub css($) {
    html_link(href => "/static/$_[0]", media => "screen", rel => "stylesheet", type => "text/css");
}

sub js($) {
    script(src => "/static/$_[0]", type => "text/javascript");
}

sub render_layout {
    my($class, $page, $stash) = @_;

    my $included = $class->render($page, $stash);
    return $class->render('layout', $included, $stash);
}

template 'overview' => sub {
    my($class, $stash) = @_;
    my $client = $stash->{handler}->schwartz->client;

    div {
        h1(class => "wi") { "Functions" };
        p(class => 'intro') {
            "The list below constians all the registered functions with the number of jobs currently outstanding. ".
                "Select a function from above to view all the jobs currently pending.";
        };

        table(class => 'queues') {
            row {
                th { "Names" };
                th { "Jobs" };
            };
            for my $func ($client->list_funcnames) {
                my @jobs = $client->list_jobs({ funcname => $func });
                row {
                    cell(class => 'queue') { a(class => "queue", href => "/func/$func") { $func } };
                    cell(class => 'args')  { @jobs + 0 };
                }
            }
        }
    }
};

template 'list_jobs' => sub {
    my($class, $stash) = @_;
    my $client = $stash->{handler}->schwartz->client;

    div {
        h1 {
            outs "Pending jobs on ";
            span(class => 'hl') { $stash->{function} };
        };

        # TODO pager
        p(class => "sub") {
            outs "Showing X jobs";
        };

        table(class => 'jos') {
            row {
                th { "id" };
                th { "args" };
            };
            my @jobs = $client->list_jobs({ funcname => $stash->{function} });
            unless (@jobs) {
                row {
                    cell(class => 'no-data', colspan => 2) {
                        "There are no pending jobs in this function";
                    }
                };
                return;
            }

            for my $job (@jobs[0..100]) {
                my $arg = $job->decode_arg;
                row {
                    cell(class => 'class') { a(href => "/job/".$job->jobid) { $job->jobid } };
                    cell(class => 'args')  { ref $arg ? Data::Dump::dump($arg) : $arg }
                }
            }
        }
    }
};

template 'job' => sub {
    my($class, $stash) = @_;

    div { "Job" }
};

template 'layout' => sub {
    my($class, $outs, $stash) = @_;
    html {
        head {
            css 'reset.css';
            css 'style.css';
            js 'jquery-1.3.2.min.js';
            js 'jquery.relatize_date.js';
            js 'ranger.js';
        };
        body {
            div(class => "header") {
                ul(class => "nav") {
                    li { "Foo" }
                    li { "Bar" }
                }
            }
            div(id => "main") { outs_raw $outs }
            div(id => "footer") {
                p {
                    outs "Powered by ";
                    a(href => "http://github.com/miyagawa/TheSchwartz-Web") { "TheSchwartz-Web" };
                    outs " $TheSchwartz::Web::VERSION";
                }
            }
        }
    };
};

1;
