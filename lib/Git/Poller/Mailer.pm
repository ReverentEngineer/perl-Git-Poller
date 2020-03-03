=head1 NAME

Git::Poller::Mailer - Perl interface for mailing based off polling.

=cut

package Mailer;

use strict;
use Net::SMTP;

=head1 CONSTRUCTORS

=over 4

=item new ( OPTIONS )

Contruct a new mailer object.

B<smtp> - The SMTP connection

B<send_from> - From address to use.

=cut

sub new {
  my $class = shift;
  my %config = @_;
  my $obj = {
    conn => $config{smtp},
    send_from => $config{send_from},
  };
  bless $obj, $class;
  return $obj;
}

=back

=head1 METHODS

=over 4

=item send ( ARGUMENTS )

Sends mail based on arguments.

B<mailing_list> - List of email addresses to send notifications.

B<commits> - Commits to nofify list

B<status> - Status of the actions.

B<log> - Log of actions. 

=cut

sub send {
  my $self = shift;
  my %args = @_;

  $self->{conn}->mail($self->{send_from});
  if ($self->{conn}->to($args{mailing_list})) {

  }
}


1;
