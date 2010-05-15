#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Finance::Bank::ID::BCA' );
}

diag( "Testing Finance::Bank::ID::BCA $Finance::Bank::ID::BCA::VERSION, Perl $], $^X" );
