package NewsPackager::RSSFeed;

use Moose;

use HTML::Entities;
use HTML::Strip;
use NewsPackager::DB;
use XML::RSS;

has 'parser' => (
	is => 'ro',
	required => 1
);

sub cacheItems {
	my ($self) = @_;
	
	my $schema = NewsPackager::DB::schema;
	
	foreach my $feed ($self->parser->listFeeds) {
		my $http_response = $self->parser->user_agent->get($feed);
		
		my $rss = XML::RSS->new();
		$rss->parse($http_response->content);
	
		foreach my $item (@{$rss->{'items'}}) {
			my $count = $schema->resultset('NewsPackager::DB::Schema::Result::Story')->count(
				{
					url => $item->{'link'}
				}
			);
			
			if ($count == 0) {
				eval {
				  my $content = $self->parser->getContent($item->{'link'});

				  my $source_type = $schema->resultset('NewsPackager::DB::Schema::Result::SourceType')->find_or_create(
					{
						name => $self->parser->source_type
					}
				  );
				
				  $schema->resultset('NewsPackager::DB::Schema::Result::Story')->create(
					{
						url => $item->{'link'},
						title => $item->{'title'},
						summary => HTML::Strip->new()->parse(decode_entities($item->{'description'})),
						date => $item->{pubDate},
						content => $content,
						source_type => $source_type
					}
				  );
				} or do {
					print STDERR $item->{'link'}, "\n";
				};
			}
		}			
	}
}

1;