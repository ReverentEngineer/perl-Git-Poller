package Cache;

use strict;
use Env qw(HOME);

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

sub store {
  my $self = shift;
  my ($url, $ref, $hash) = @_;

  if (not $self->{cache} =~ s/$url $ref [a-f0-9]{40}/$url $ref $hash/) {
    $self->{cache} .= "$url $ref $hash\n"; 
  }
}

sub close {
  my %self = shift;
  if (defined $self{cacheFile}) {
    open(my $fh, ">". $self{cacheFile})
      or die "Can't write to cache: $!";
    print $fh $self{cache};
    close($fh);
  }
}
1;
