package NewsPackager::Parser::TelegraphBlogsParser;

use base qw/NewsPackager::Parser/;

use HTML::TreeBuilder;

use vars qw/@feeds $__source_type/;

$__source_type = 'TelegraphBlogs';

my @feeds = qw{
	http://blogs.telegraph.co.uk/feed-2/
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

sub get_content {
	my ($self, $url) = @_;
	
	my $response = $self->user_agent->get($url);

	my $tree = HTML::TreeBuilder->new_from_content($response->decoded_content);
	
	my $main = $tree->look_down('_tag', 'div', 'class', 'entry');

	my $content = '';
	
	foreach my $p ($main->find_by_tag_name('p')) {
		$content .= $p->as_text . "\n\n";
	}
		
	return $content;
}

1;