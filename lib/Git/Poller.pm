=head1 NAME

Git::Poller - Polls repository and performs actions.

=cut

package Poller;

use strict;
use Git::Poller::Cache;
use Git;
use IPC::Cmd q/run/;
use File::Temp qw/tempdir/;


our $VERSION = 0.01;

=head1 CONSTRUCTORS

=over 4

=item new ( OPTIONS )

Constructs Git poller object.

B<mailer> - The mailer object to handle mailing based on repository.

B<cache> - The cache object to handle Git repository polling.

=cut

sub new {
  my $class = shift;
  my %args = @_;

  my $obj = {
    repos => [],
    cache => $args{cache},
    mailer => $args{mailer},
  };
  bless $obj, $class;
  return $obj;
}

=back

=head1 METHODS

=over 4

=item add ( ARGUMENTS )

Adds a repository to poll.

B<url> - The url of the Git repository.

B<watch> - Regex of refs to poll.
 
B<run> - The commands to run upon change.

=cut

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
        my $repo = Git->repository($tmpdir);
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
