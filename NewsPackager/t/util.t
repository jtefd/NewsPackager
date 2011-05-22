use strict;

use Test::More;

BEGIN {
	use FindBin;
	
	push @INC, $FindBin::Bin . '/../..';
	
	use_ok(qw/NewsPackager::Util/); 
}

my @parsers = NewsPackager::Util::ListParsers();

isnt(scalar(@parsers), 0, 'At least one parser installed');

done_testing();