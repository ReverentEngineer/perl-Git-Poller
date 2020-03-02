=head1 NAME

Git::Poller::Cache - A Git poll cache object.

=cut
package Cache;

use strict;
use Env qw(HOME);

=head1 CONSTRUCTORS

=over 4

=item new ( [ CACHE_FILE ] )

Construct a cache object. The CACHE_FILE is optional and will retain an 
an in-memory cache if not provided.

=cut

sub new {
  my $class = shift;
  my $cache_file = shift;

  my $obj = {
    cache => "",
  };

  if (defined $cache_file and -e $cache_file) {
    open(my $fh, "<", $cache_file) 
      or die "Can't read cache: $!";
    $obj->{cache} = do { local $/; <$fh> };
    close($fh);
    $obj->{cacheFile} => $cache_file,
  }

  bless $obj, $class;

  return $obj;
}

=back

=head1 METHODS

=over 4

=item lookup ( URL, REF )

Looks up cached hash of the URL and REF.

=cut

sub lookup {
  my $self = shift;
  my ($url, $ref) = @_;
  if (not defined $url or not defined $ref) {
    die "Invalid arguments.";
  }

  if ($self->{cache} =~ /$url $ref ([a-f0-9]{40})/) {
    return $1;
  } else {
    return undef;
  }
}

=item store ( URL, REF, HASH)

Stores HASH for URL and REF.

=cut

sub store {
  my $self = shift;
  my ($url, $ref, $hash) = @_;

  if (not $self->{cache} =~ s/$url $ref [a-f0-9]{40}/$url $ref $hash/) {
    $self->{cache} .= "$url $ref $hash\n"; 
  }
}

=item write()

Writes the cache to disk.

=cut

sub write {
  my %self = shift;
  if (defined $self{cacheFile}) {
    open(my $fh, ">". $self{cacheFile})
      or die "Can't write to cache: $!";
    print $fh $self{cache};
    close($fh);
  }
}
1;
