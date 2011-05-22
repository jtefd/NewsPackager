package NewsPackager::Util;

use strict;
use warnings;

use File::Basename qw/dirname/;
use File::Spec::Functions qw/catdir/;

sub ListParsers {
	my @parsers = ();
	
	my $parser_dir = catdir(dirname(__FILE__), 'Parser');
	
	opendir DIR, $parser_dir;
	
	foreach my $f (grep { !/^\./ } readdir DIR) {
		$f =~ s/\.pm$//;
		
		push @parsers, "NewsPackager::Parser::$f";
	}
	
	closedir DIR;
	
	return sort @parsers;
}

1;