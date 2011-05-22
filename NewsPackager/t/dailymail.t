use strict;

use Test::More;

BEGIN {
	use FindBin;
	
	push @INC, $FindBin::Bin . '/../..';
	
	use_ok(qw/NewsPackager::Parser::DailyMailParser/); 
}

@NewsPackager::Parser::DailyMailParser::feeds = qw{
	http://www.dailymail.co.uk/news/index.rss
};

my $mail = NewsPackager::Parser::DailyMailParser->new();

my @feeds = $mail->get_feeds();

isnt(scalar(@feeds), 0, 'Returned more than 0 feeds');

my $feed = $feeds[0];

isnt($feed->title, undef, 'Title success');
isnt($feed->url, undef, 'URL success: ' . $feed->url);
isnt($feed->content, undef, 'Content success');
isnt($feed->type, undef, 'Type success');
isnt($feed->date, undef, 'Date success');
isnt($feed->summary, undef, 'Summary success');

done_testing();