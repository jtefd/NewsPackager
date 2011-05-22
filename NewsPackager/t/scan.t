use strict;

use Test::More;

BEGIN {
	use FindBin;
	use Module::Load;
	
	push @INC, $FindBin::Bin . '/../..';
	
	use_ok(qw/NewsPackager::Parser/);
	use_ok(qw/NewsPackager::Parser::Util/);
	use_ok(qw/NewsPackager::DB/);
	use_ok(qw/NewsPackager::Persister/);
}

my $persister = NewsPackager::Persister->new();
my $schema = NewsPackager::DB::schema;

my @parsers = NewsPackager::Util::ListParsers();

isnt(scalar(@parsers), 0, 'At least one parser installed');
	
foreach my $parser (@parsers) {
	load $parser;
			
	foreach my $feed ($parser->get_feeds()) {
		$persister->persist($feed);

		my $row = $schema->resultset('NewsPackager::DB::Schema::Result::Story')->find(
			{
				'title' => $feed->title,
				'url' => $feed->url,
				'content' => $feed->content,
				'summary' => $feed->summary,
			},
		);
		
		isnt($row, undef, 'Retrieved row');
	
		is($row->get_column('title'), $feed->title, 'Title stored');
		is($row->get_column('url'), $feed->url, 'URL stored');
		is($row->get_column('content'), $feed->content, 'Content stored');
		is($row->get_column('summary'), $feed->summary, 'Summary stored');
		
		$row->delete();
	}
}	

done_testing();