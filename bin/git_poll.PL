#!/usr/bin/env perl

use strict;
use YAML qw(LoadFile);
use Git;
use File::Temp qw/tempdir/;
use Env qw(HOME);

my ($config) = @ARGV;
my $cache_file = "$HOME/.cache/git_poll";

if (not defined $config) {
	die 'Need config';
}

my ($repos) = LoadFile($config);
my @repos = @{ $repos };

foreach (@repos) {
  my %repo = %$_;
  my $url = $repo{url};
  my $watch = $repo{watch};
  my $run = $repo{run};
  my @run = @{ $run };
  $watch = "refs/heads/master" if not defined $watch;
  my $refs = Git::command("ls-remote", $url);
}
