package NewsPackager::Parser::TelegraphBlogs;

use Moose;

with 'NewsPackager::Parser';

use Encode qw/encode/;
use HTML::Strip;
use HTML::TreeBuilder;

has 'source_type' => (
	is => 'ro',
	isa => 'Str',
	default => 'TelegraphBlogs'
);

my @feeds = qw{
	http://blogs.telegraph.co.uk/feed-2/
};

sub listFeeds {
	return @feeds;
}

sub getContent {
	my ($self, $url) = @_;
	
	my $response = $self->user_agent->get($url);

	my $tree = HTML::TreeBuilder->new_from_content($response->decoded_content);
	
	my $main = $tree->look_down('_tag', 'div', 'class', 'entry');

	my $content = '';
	
	foreach my $p ($main->find_by_tag_name('p')) {
		$content .= $p->as_text . "\n\n";
	}
		
	return encode('UTF-8', $content);
}

1;;
