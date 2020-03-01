package Poller;

use strict;
use Git::Poller::Cache;
use Git;
use IPC::Cmd q/run/;
use File::Temp qw/tempdir/;


our $VERSION = 0.01;

sub new {
  my $class = shift;
  my $cache_file = shift;
  my $obj = {};
  $obj->{repos} = [];
  $obj->{cache} = Cache->new($cache_file);
  bless $obj, $class;
  return $obj;
}

sub add {
  my $self = shift;
  my %repo = @_;

  if (not defined $repo{url}) {
    die "No url provided.";
  }

  if (not defined $repo{watch}) {
    $repo{watch} = 'refs/heads/master';
  }

  if (not defined $repo{run}) {
    die "No run provided.";
  }
  
  push @{$self->{repos}}, \%repo;
}

sub poll {
  my $self = shift;
  my @repos = @{$self->{repos}};
  my $output = "";
  for (@repos) {
    my %repo = %$_;
    my $refs = Git::command("ls-remote", $repo{url});
    while($refs =~ /([a-f0-9]+)[\s\t]+($repo{watch})/g ) {
      my ($newhash, $ref) = ($1, $2);
      my $oldhash = $self->{cache}->lookup($repo{url}, $ref);
      if ($newhash ne $oldhash) {
        my @cmds = @{ $repo{run} };
        my $tmpdir = tempdir();
        $output .= Git::command(["clone", $repo{url}, "$tmpdir"], STDERR => 0);
        chdir $tmpdir;
        for (@cmds) {
          my $buffer = "";
          my ($ok, $err, $fullbuf) = run(command => "$_", buffer => \$buffer);
          $output .= $buffer;
        }
        $self->{cache}->store($repo{url}, $ref, $newhash);
      }
    }
  }
  return $output;
}

1;
