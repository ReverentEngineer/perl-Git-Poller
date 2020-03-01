use strict;
use Test;
use Git::Poller;
use Git;
use File::Temp qw/tempdir/;

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


my $poller = Poller->new(
  CacheFile => "./test_cache"
);

my @command = ("echo hi", "echo hello");
$poller->add(url=>"$gitdir", watch=>"refs/heads/master", run=>\@command);

ok($poller->poll(), "hi\nhello\n");
