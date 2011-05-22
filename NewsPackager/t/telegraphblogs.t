use strict;

use Test::More;

BEGIN {
	use FindBin;
	
	push @INC, $FindBin::Bin . '/../..';
	
	use_ok(qw/NewsPackager::Parser::TelegraphBlogsParser/); 
}

my $mail = NewsPackager::Parser::TelegraphBlogsParser->new();

my @feeds = $mail->get_feeds();

isnt(scalar(@feeds), 0, 'Returned more than 0 feeds');

my $feed = $feeds[0];

isnt($feed->title, undef, 'Title success');
isnt($feed->url, undef, 'URL success');
isnt($feed->content, undef, 'Content success');
isnt($feed->type, undef, 'Type success');
isnt($feed->date, undef, 'Date success');
isnt($feed->summary, undef, 'Summary success');

done_testing();