package NewsPackager::Parser::DailyMailParser;

use base qw/NewsPackager::Parser/;

use HTML::TreeBuilder;

use vars qw/@feeds $__source_type/;

$__source_type = 'DailyMail';

@feeds = qw{
	http://www.dailymail.co.uk/news/index.rss
	http://www.dailymail.co.uk/news/columnist-228/quentin-letts.rss
	http://www.dailymail.co.uk/news/columnist-1003404/norman-tebbit.rss
	http://www.dailymail.co.uk/news/columnist-322/richard-littlejohn.rss
	http://www.dailymail.co.uk/news/columnist-464/max-hastings.rss
	http://www.dailymail.co.uk/news/columnist-1041755/andrew-pierce.rss
	http://www.dailymail.co.uk/news/columnist-256/melanie-phillips.rss
	http://www.dailymail.co.uk/news/columnist-224/peter-hitchens.rss
	http://www.dailymail.co.uk/news/columnist-1000961/tom-utley.rss
};

sub source_type() {
	return $__source_type;
}

sub list_feeds() {
	return @feeds;
}

sub format_url($) {
	my ($self, $url) = @_;
	
	($url) = ($url =~ /^(.+\/)?.+$/);
	
	return $url;
}

sub get_content($) {
	my ($self, $url) = @_;
	
	my $response = $self->user_agent->get($url);

	my $tree = HTML::TreeBuilder->new_from_content($response->content);
	
	my $main = $tree->look_down('_tag', 'div', 'id', 'js-article-text');

	if (defined(my $art_splitter = $main->look_down('_tag', 'div', 'class', 'artSplitter'))) {
		$art_splitter->delete();
	}
	
	if (defined(my $thin_centre = $main->look_down('_tag', 'div', 'class', 'thinCenter'))) {
		$thin_centre->delete();
	}
	
	if (defined(my $related_items = $main->look_down('_tag', 'div', 'class', 'relatedItems'))) {
		$related_items->delete();
	}
	
	if (defined(my $float = $main->look_down('_tag', 'div', 'class', 'floatRHS'))) {
		$float->delete();
	}
	
	if (defined(my $comments = $main->look_down('_tag', 'div', 'id', 'reader-comments'))) {
		$comments->delete();
	}

	my $content = '';
	
	foreach my $p ($main->find_by_tag_name('p')) {
		$content .= $p->as_text . "\n\n";
	}
		
	return $content;
}

1;