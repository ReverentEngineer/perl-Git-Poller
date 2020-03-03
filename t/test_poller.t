use strict;
use Test;
use Git::Poller;
use Git::Poller::Cache;
use Git::Poller::Mailer;
use Git;
use File::Temp qw/tempdir/;
use Test2::Mock;

BEGIN { plan tests => 1 }

my $tmpdir = tempdir();
my $gitdir = "$tmpdir";
Git::command("init",  $gitdir);
my $repo = Git->repository(Directory=> $gitdir);
open(my $fh, ">", "$tmpdir/testfile")
  or die("Can't write testfile: $!");
close($fh);
$repo->command("add", "$tmpdir/testfile");
$repo->command("commit", "-m", "test message");

my $cache = Cache->new();

my $mailer = Test2::Mock->new(
  class => 'Git::Poller::Mailer',
  add => [
    send => sub { return 1;  }
  ]
);


my $poller = Poller->new(
  cache => $cache,
  mailer => $mailer,
);



my @command = ("echo hi", "echo hello");
$poller->add(url=>"$gitdir", watch=>"refs/heads/master", run=>\@command);
ok($poller->poll(), 1);
