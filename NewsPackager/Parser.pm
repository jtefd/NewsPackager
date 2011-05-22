package NewsPackager::Parser;

use strict;
use warnings;

use LWP::UserAgent;
use NewsPackager::Feed;
use XML::RSS;

sub new() {
	my ($class) = @_;
	
	return bless({}, ref $class || $class);
}

sub get_feeds() {
	my ($self) = @_;
	
	my @feeds = ();
	
	foreach ($self->list_feeds()) {
		my $rss = XML::RSS->new();
		$rss->parse($self->user_agent->get($_)->content);
	
		foreach my $item (@{$rss->{'items'}}) {
			eval {
				my $feed = NewsPackager::Feed->new();
				
				$feed->url($item->{'link'});
				$feed->title($item->{'title'});
				$feed->summary($item->{'description'});
				$feed->date($item->{pubDate});
				$feed->content($self->get_content($feed->url));
				$feed->type($self->source_type());
				
				if ($self->can('format_url')) {
					$feed->url($self->format_url($feed->url));
				}
				
				push @feeds, $feed;	
			} or do {
				print $@, "\n";
			};
		}
	}
	
	return @feeds;
}

sub user_agent() {
	my ($self) = @_;
	
	return LWP::UserAgent->new();
}

1;