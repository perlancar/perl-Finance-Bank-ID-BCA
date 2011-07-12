package Finance::BankUtils::ID::Mechanize;

use 5.010;
use Crypt::SSLeay;
use Log::Any qw($log);
use base qw(WWW::Mechanize);

# VERSION

sub new {
    my ($class, %args) = @_;
    my $mech = WWW::Mechanize->new;
    $mech->{verify_https} = $args{verify_https} // 0;
    $mech->{https_ca_dir} = $args{https_ca_dir} // "/etc/ssl/certs";
    $mech->{https_host}   = $args{https_host};
    bless $mech, $class;
}

sub request {
    my ($self, $req) = @_;
    local $ENV{HTTPS_CA_DIR} = $self->{verify_https} ?
        $self->{https_ca_dir} : '';
    $log->tracef("HTTPS_CA_DIR = %s", $ENV{HTTPS_CA_DIR});
    if ($self->{verify_https} && $self->{https_host}) {
        $req->header('If-SSL-Cert-Subject',
                     qr!\Q/CN=$self->{https_host}\E(/|$)!);
    }
    $log->trace('Mech request: ' . $req->headers_as_string);
    my $resp = $self->SUPER::request($req);
    $log->trace('Mech response: ' . $resp->headers_as_string);
    $resp;
}

1;
# ABSTRACT: A subclass of WWW::Mechanize that does HTTPS certificate verification

=head1 SYNOPSIS

 my $mech = Finance::BankUtils::ID::Mechanize->new(
     verify_https => 1,
     #https_ca_dir => '/etc/ssl/certs',
     https_host   => 'example.com',
 );
 # use as you would WWW::Mechanize object ...

=head1 DESCRIPTION

This is a subclass of WWW::Mechanize that does (optional) HTTPS certificate verification.

=head1 METHODS

=head2 new()

=head2 request()

=cut
