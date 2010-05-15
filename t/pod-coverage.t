use strict;
use warnings;
use Test::More;
use Pod::Coverage;
use Test::Pod::Coverage;

all_pod_coverage_ok({ also_private => [ qr/^(BUILD)$/ ], });
