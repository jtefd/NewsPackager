package NewsPackager::Parser::Util;

use strict;

use File::Basename qw/dirname/;

sub listParsers {
	my @parsers = ();
	
	my $parser_dir = dirname(__FILE__);
	
	opendir DIR, $parser_dir;
	
	foreach my $f (grep { !/^\./ } readdir DIR) {
		if ($f eq 'Util.pm') {
			next;
		}
		
		$f =~ s/\.pm$//;
		
		push @parsers, "NewsPackager::Parser::$f";
	}
	
	closedir DIR;
	
	return sort @parsers;
}

1;