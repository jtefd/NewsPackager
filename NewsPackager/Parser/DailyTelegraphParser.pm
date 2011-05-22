package NewsPackager::Parser::DailyTelegraphParser;

use base qw/NewsPackager::Parser/;

use HTML::TreeBuilder;

use vars qw/@feeds $__source_type/;

$__source_type = 'Telegraph';

my @feeds = qw{
	http://www.telegraph.co.uk/news/uknews/rss
	http://www.telegraph.co.uk/news/worldnews/rss
	http://www.telegraph.co.uk/news/newstopics/politics/rss
	http://www.telegraph.co.uk/comment/columnists/rss
	http://www.telegraph.co.uk/comment/rss
};

sub source_type() {
	return $__source_type;
}

sub list_feeds() {
	return @feeds;
}

sub format_url($) {
	my ($self, $url) = @_;

	#($url) = ($url =~ /^(.+\/)?.+$/);
	
	print $url, "\n";
	
	return $url;
}

sub get_content {
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
		
	return $content;
}

1;