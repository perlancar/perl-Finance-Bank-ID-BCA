package Finance::BankUtils::ID::Mechanize;

use 5.010;
use Log::Any qw($log);
use parent qw(WWW::Mechanize);

# VERSION

sub new {
    my ($class, %args) = @_;
    my $mech = WWW::Mechanize->new;
    $mech->{verify_https} = $args{verify_https} // 0;
    $mech->{https_ca_dir} = $args{https_ca_dir} // "/etc/ssl/certs";
    $mech->{https_host}   = $args{https_host};
    bless $mech, $class;
}

# will be set by some other code, and will be immadiately consumed and emptied
# by _make_request().
our $saved_resp;

sub _make_request {
    my $self = shift;
    my $req = shift;
    local $ENV{HTTPS_CA_DIR} = $self->{verify_https} ?
        $self->{https_ca_dir} : '';
    $log->tracef("HTTPS_CA_DIR = %s", $ENV{HTTPS_CA_DIR});
    if ($self->{verify_https} && $self->{https_host}) {
        $req->header('If-SSL-Cert-Subject',
                     qr!\Q/CN=$self->{https_host}\E(/|$)!);
    }
    $log->trace('Mech request: ' . $req->headers_as_string);
    my $resp;
    if ($saved_resp) {
        $resp = $saved_resp;
        $saved_resp = undef;
        $log->trace('Mech response (from saved): ' . $resp->headers_as_string);
    } else {
        $resp = $self->SUPER::_make_request($req, @_);
        $log->trace('Mech response: ' . $resp->headers_as_string);
    }
    $resp;
}

1;
# ABSTRACT: A subclass of WWW::Mechanize

=head1 SYNOPSIS

 my $mech = Finance::BankUtils::ID::Mechanize->new(
     verify_https => 1,
     #https_ca_dir => '/etc/ssl/certs',
     https_host   => 'example.com',
 );
 # use as you would WWW::Mechanize object ...


=head1 DESCRIPTION

This is a subclass of WWW::Mechanize that can do some extra stuffs:

=over

=item * HTTPS certificate verification

=item * use saved response from a file

=item * log using Log::ny

=back


=head1 METHODS

=head2 new()

=head2 request()

=cut
