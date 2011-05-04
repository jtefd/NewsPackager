package NewsPackager::Parser::Telegraph;

use Moose;

with 'NewsPackager::Parser';

use Encode qw/encode/;
use HTML::Strip;
use HTML::TreeBuilder;

has 'source_type' => (
	is => 'ro',
	isa => 'Str',
	default => 'Telegraph'
);

my @feeds = qw{
	http://www.telegraph.co.uk/news/uknews/rss
	http://www.telegraph.co.uk/news/worldnews/rss
	http://www.telegraph.co.uk/news/newstopics/politics/rss
	http://www.telegraph.co.uk/comment/columnists/rss
	http://www.telegraph.co.uk/comment/rss
};

sub listFeeds {
	return @feeds;
}

sub getContent {
	my ($self, $url) = @_;
	
	my $response = $self->user_agent->get($url);

	my $tree = HTML::TreeBuilder->new_from_content($response->decoded_content);
	
	my $main = $tree->look_down('_tag', 'div', 'id', 'mainBodyArea');
	
	if (defined(my $related_links = $main->look_down('_tag', 'div', 'class', 'related_links_inline'))) {
		$related_links->delete();
	}

	my $content = '';
	
	foreach my $p ($main->find_by_tag_name('p')) {
		$content .= $p->as_text . "\n\n";
	}
		
	return encode('UTF-8', $content);
}

1;;
