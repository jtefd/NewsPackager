#!/usr/bin/env perl

=pod

=head1 NAME

newspkg - Online news serialisation, packaging and distribution.

=head1 SYNOPSIS

newspkg [options]

=head1 DESCRIPTION

This application retrieves news from a variety of sources and packages it into a
format for viewing offline.

=head1 OPTIONS

=over 8

=item B<install-db>

(Re)installs the database. Note: this will clear the current content.

=item B<scan>

Performs a scan of the news sources, adding content to the database.

=item B<assemble>

Packages content from the database into a file.

=over 8

=item B<out FILENAME>

Stores packaged content into a file (writes to STDOUT otherwise)

=back

=back

=cut

BEGIN {
	use FindBin;
	
	push @INC, $FindBin::Bin;
}

use strict;

use Getopt::Long;
use Module::Load;
use NewsPackager::DB;
use NewsPackager::RSSFeed;
use NewsPackager::Parser::Util;
use NewsPackager::Assembler;
use Pod::Usage;

my %opts;

GetOptions(
	\%opts, 
	'help',
	'man',
	'install-db',
	'scan',
	'assemble',
	'out=s'
);	

if ($opts{'help'}) {
	pod2usage( -verbose => 1, -exitval => 0 );
}
elsif ($opts{'man'}) {
	pod2usage( -verbose => 2, -exitval => 0 )
}
elsif ($opts{'install-db'}) {
	my $schema = NewsPackager::DB::schema;

	$schema->deploy( { add_drop_table => 1 } );
}
elsif ($opts{'scan'}) {
	foreach my $parser (NewsPackager::Parser::Util::listParsers) {
		eval {
			load $parser;
			
			my $rssfeed = NewsPackager::RSSFeed->new(parser => $parser->new());
			$rssfeed->cacheItems();		
		} or do {
			print STDERR $@, "\n";
		};
	}	
}
elsif ($opts{'assemble'}) {
	my $h;
	
	if ($opts{'out'}) {
		open $h, '>', $opts{'out'}; 	
	}
	else {
		$h = *STDOUT;
	}

	my $assembler = NewsPackager::Assembler->new();
	
	print $h $assembler->source;

	close $h;	
}