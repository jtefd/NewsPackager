use strict;

use Test::More;

BEGIN {
	use FindBin;
	
	push @INC, $FindBin::Bin . '/../..';
	
	use_ok(qw/NewsPackager::Persister/);
	use_ok(qw/NewsPackager::Feed/);
	use_ok(qw/NewsPackager::DB/);
}

my $feed = NewsPackager::Feed->new();
$feed->url('http://www.google.com/' . time);
$feed->title('Title');
$feed->summary('Summary');
$feed->date('2000/01/01 00:00:00');
$feed->type('TestType');
$feed->content('Content');

my $persister = NewsPackager::Persister->new();
$persister->persist($feed);

my $schema = NewsPackager::DB::schema;

isnt($schema, undef, 'Loaded schema');

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

done_testing();